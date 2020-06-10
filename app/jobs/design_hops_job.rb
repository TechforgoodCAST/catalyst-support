# frozen_string_literal: true

class DesignHopsJob < ApplicationJob
  queue_as :default

  def perform
    @hop_attendees = Airrecord.table(ENV['AIRTABLE_API_KEY'], 'appchfb5dUtfrlVSZ', 'Attendee sign-up data')

    @hop_attendees.all.each do |record|
      domain = record['Email'].split('@').last.strip
      org_name = record['Organisation name'].strip

      # Create new org
      @org = Organisation.find_by({ name: org_name }) || Organisation.find_by({ domain: domain })
      if @org.nil?
        @org = Organisation.create!(
          name: org_name,
          domain: domain
        )
        @org.get_charity_number
      end

      # Create new org
      @person = Person.find_by({ email: record['Email'] })
      if @person.nil?
        @person = Person.create!(
          first_name: record['First name'],
          last_name: record['Last name'],
          email: record['Email'],
          organisation: @org
        )
      end

      # Record action
      Action.create!(
        potential_action: PotentialAction.find(1),
        organisation_id: @org.id,
        person_id: @person.id,
        details: {
          person_name: record['First name'] + ' ' + record['Last name'],
          hop: record['Which design hop are you applying to join?'].first
        },
        start_time: record.created_at,
        end_time: record.created_at
      )
    end
  end
end
