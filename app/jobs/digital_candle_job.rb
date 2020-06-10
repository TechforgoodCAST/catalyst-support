# frozen_string_literal: true

class DigitalCandleJob < ApplicationJob
  queue_as :default

  def perform
    @rows = GoogleSheetsImport.new.extract(ENV['DIGITAL_CANDLE_CONFIG'])

    @rows.each do |row|
      domain = row[:email].split('@').last.strip
      first_name = row[:name].match('^(\w+) ')[1].strip
      last_name = row[:name].match(' (.*)$')[1].strip

      # Find org
      @org = Organisation.find_by({ domain: domain })

      unless @org.nil?
        # Create new person
        @person = Person.find_by({ email: row[:email] })
        if @person.nil?
          @person = Person.create!(
            first_name: first_name,
            last_name: last_name,
            email: row[:email],
            organisation: @org
          )
        end

        # Record actions
        Action.create!(
          potential_action: PotentialAction.find(3),
          organisation_id: @org.id,
          person_id: @person.id,
          details: {
            person_name: row[:name]
          },
          start_time: row[:timestamp],
          end_time: row[:timestamp]
        )

        Action.create!(
          potential_action: PotentialAction.find(4),
          organisation_id: @org.id,
          person_id: @person.id,
          details: {
            person_name: row[:name],
            intro: row[:intro],
            intro_date: row[:intro_date]
          },
          start_time: row[:intro_date],
          end_time: row[:intro_date]
        )
      end
    end
  end
end
