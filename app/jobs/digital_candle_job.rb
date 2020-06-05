class DigitalCandleJob < ActiveJob::Base
  queue_as :default

  def perform()
    
    @rows = GoogleSheetsImport.new.extract(ENV['DIGITAL_CANDLE_CONFIG'])
    
    @hopAttendees = Airrecord.table(ENV['AIRTABLE_API_KEY'], "appchfb5dUtfrlVSZ", "Attendee sign-up data")

    @rows.each do |row|
      domain = row[:email].split("@").last.strip

      @org = Organisation.find_by({domain: domain})
      if @org
        Action.create(
          potential_action: PotentialAction.find(3), 
          organisation: @org,
          details: {
            person_name: row[:name]
          }, 
          start_time: row[:timestamp], 
          end_time: row[:timestamp]
        )
        
        Action.create(
          potential_action: PotentialAction.find(4), 
          organisation: @org,
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