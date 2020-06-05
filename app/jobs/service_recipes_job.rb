class ServiceRecipesJob < ActiveJob::Base
  queue_as :default
  
  def perform()
    @hopAttendees = Airrecord.table(ENV['AIRTABLE_API_KEY'], "appL7gqKhmfsrP0Ex", "Recipes to go online")

    @hopAttendees.all(filter: "{Recipe progress} = 'Step 10: Published'").each do |record|
      org_name = record['Charity / org'].strip
      
      @org = Organisation.find_by({name: org_name})
      if @org
        Action.create(
          potential_action: PotentialAction.find(2), 
          organisation: @org,
          start_time: record.created_at, 
          end_time: record.created_at,
          details: {
             recipe_name: record['Name of the thing']
          }
        )
      end
    end
  end
end