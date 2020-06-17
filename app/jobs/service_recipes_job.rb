# frozen_string_literal: true

class ServiceRecipesJob < ApplicationJob
  queue_as :default

  def perform
    @service_recipes = Airrecord.table(ENV['AIRTABLE_API_KEY'], 'appL7gqKhmfsrP0Ex', 'Recipes to go online')

    @service_recipes.all(filter: "{Recipe progress} = 'Step 10: Published'").each do |record|
      org_name = record['Charity / org'].strip

      org = Organisation.new_or_reconcile(name: org_name)

      if org.new_record? && org_name.present?
        org.name = org_name
        org.save!
      end

      action = build_action('Published A Service Recipe', org, record.created_at)
      action.save!
    end
  end
end
