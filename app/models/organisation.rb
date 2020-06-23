# frozen_string_literal: true

class Organisation < ApplicationRecord
  extend Reconcile

  has_many :affiliations
  has_many :admins, through: :affiliations, source: :individual, source_type: 'Admin', dependent: :destroy
  has_many :users, through: :affiliations, source: :individual, source_type: 'User', dependent: :destroy
  has_many :actions, dependent: :destroy

  attr_accessor :employee_count, :volunteer_count, :income, :income_fy, :region, :beneficiary

  before_validation :set_slug

  validates :name, presence: true

  def to_param
    slug
  end

  # TODO: avoid incrementing slug when reconciling
  def generate_slug(num = 1)
    slug = name.parameterize
    slug += "-#{num}" if num > 1
    return slug unless Organisation.find_by(slug: slug)

    generate_slug(num + 1)
  end

  def set_slug
    self[:slug] = generate_slug
  end

  def charity_numbers
    {
      'England & Wales' => ccew_number,
      'Scotland' => oscr_number,
      'Northern Ireland' => ccni_number
    }
  end

  def ccew_number
    get_org_id('GB-CHC-')
  end

  def oscr_number
    get_org_id('GB-SC-')
  end

  def ccni_number
    get_org_id('GB-NIC-')
  end

  def company_number
    get_org_id('GB-COH-')
  end

  def get_org_id(prefix)
    org_ids.find { |s| s =~ /#{prefix}/ }&.delete_prefix(prefix)
  end

  def fetch_cc_data
    return unless (charity_number = ccew_number || oscr_number || ccni_number)

    ftc_resp = Faraday.get('https://findthatcharity.uk/charity/' + charity_number + '.json')
    ftc_data = JSON.parse(ftc_resp.body)
    if !ftc_data['company_number'].empty? then self.org_ids.push('GB-COH-' + ftc_data['company_number'][0]['number']) end
    self.income = ftc_data['latest_income']

    return unless ccew_number

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
        num: charity_number
      }
    }
    cb_resp = Faraday.post('https://charitybase.uk/api/graphql', cb_form_params.to_json, {
                             'Content-Type' => 'application/json',
                             'Authorization' => "Apikey #{ENV['CHARITY_BASE_API_KEY']}"
                           })
    cb_data = JSON.parse(cb_resp.body)['data']['CHC']['getCharities']['list'][0]

    self.employee_count = cb_data['numPeople']['employees']
    self.volunteer_count = cb_data['numPeople']['volunteers']
    self.income = cb_data['finances'][0]['income']
    self.income_fy = Date.parse(cb_data['finances'][0]['financialYear']['end'])
    self.region = cb_data['geo']['european_electoral_region']
    self.beneficiary = cb_data['beneficiaries'][0]['name']
  end
end
