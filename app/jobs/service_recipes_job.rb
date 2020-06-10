# frozen_string_literal: true

class ServiceRecipesJob < ApplicationJob
  queue_as :default

  def perform
    @service_recipes = Airrecord.table(ENV['AIRTABLE_API_KEY'], 'appL7gqKhmfsrP0Ex', 'Recipes to go online')

    @service_recipes.all(filter: "{Recipe progress} = 'Step 10: Published'").each do |record|
      org_name = record['Charity / org'].strip

      # Create new org
      @org = Organisation.find_by({ name: org_name })
      if @org.nil?
        @org = Organisation.create(
          name: org_name
        )
        @org.get_charity_number
      end

      # Record action
      Action.create(
        potential_action: PotentialAction.find(2),
        organisation_id: @org.id,
        person_id: nil,
        start_time: record.created_at,
        end_time: record.created_at,
        details: {
          recipe_name: record['Name of the thing']
        }
      )
    end
  end
end
