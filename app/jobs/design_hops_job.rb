class DesignHopsJob < ActiveJob::Base
  queue_as :default

  def perform()
    @hopAttendees = Airrecord.table(ENV['AIRTABLE_API_KEY'], "appchfb5dUtfrlVSZ", "Attendee sign-up data")

    @hopAttendees.all.each do |record|
      domain = record['Email'].split("@").last.strip
      org_name = record['Organisation name'].strip

      @org = Organisation.find_by({name: org_name}) || Organisation.find_by({domain: domain]})
      if @org
        Action.create(
          potential_action: PotentialAction.find(1), 
          organisation: @org,
          details: {
            person_name: record['First name'] + " " + record['Last name'], 
            hop: record['Which design hop are you applying to join?'].first
          }, 
          start_time: record.created_at, 
          end_time: record.created_at
        )
      end
    end
  end
end