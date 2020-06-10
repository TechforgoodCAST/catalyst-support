# frozen_string_literal: true

class Organisation < ApplicationRecord
  has_many :affiliations
  has_many :admins, through: :affiliations, source: :individual, source_type: 'Admin', dependent: :destroy
  has_many :users, through: :affiliations, source: :individual, source_type: 'User', dependent: :destroy
  has_many :tickets
  has_many :actions

  attr_accessor :employee_count, :volunteer_count, :income, :income_fy, :region, :beneficiary

  def get_charity_number
    return self.charity_number if self.charity_number

    if (charity_number = CharityDomainLookup.lookup_domain(self.domain))
      self.update!({ charity_number: charity_number })
      return charity_number
    end

    nil
  end

  def fetch_cc_data
    return unless get_charity_number

    charity_no = get_charity_number.split('-').last.strip

    ftc_resp = Faraday.get('https://findthatcharity.uk/charity/' + charity_no + '.json')
    ftc_data = JSON.parse(ftc_resp.body)
    self.company_number = !ftc_data['company_number'].empty? ? ftc_data['company_number'][0]['number'] : nil
    self.income = ftc_data['latest_income']

    return unless england_and_wales?

    cb_form_params = {
      query: 'query SearchCharities($num: [ID]) {
                CHC {
                  getCharities(filters: {
                    id: $num
                  }) {
                    list(limit: 30) {
                      id
                      areas{
                        name
                      }
                      beneficiaries {
                        name
                      }
                      geo {
                        postcode
                        european_electoral_region
                      }
                      finances {
                        income
                        financialYear {
                          begin
                          end
                        }
                      }
                      numPeople {
                        employees
                        volunteers
                      }
                    }
                  }
                }
              }',
      variables: {
        num: charity_no
      }
    }
    cb_resp = Faraday.post('https://charitybase.uk/api/graphql', cb_form_params.to_json, {
                             'Content-Type' => 'application/json',
                             'Authorization' => 'Apikey 41f6fde1-7ab2-47bd-a069-39112c1d4339'
                           })
    cb_data = JSON.parse(cb_resp.body)['data']['CHC']['getCharities']['list'][0]

    self.employee_count = cb_data['numPeople']['employees']
    self.volunteer_count = cb_data['numPeople']['volunteers']
    self.income = cb_data['finances'][0]['income']
    self.income_fy = Date.parse(cb_data['finances'][0]['financialYear']['end'])
    self.region = cb_data['geo']['european_electoral_region']
    self.beneficiary = cb_data['beneficiaries'][0]['name']
  end

  def england_and_wales?
    get_charity_number.start_with?('GB-CHC')
  end
end
