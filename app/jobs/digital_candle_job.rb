# frozen_string_literal: true

class DigitalCandleJob < ApplicationJob
  queue_as :default

  def perform
    @rows = GoogleSheetsImport.new.extract(ENV['DIGITAL_CANDLE_CONFIG'])

    @rows.each do |row|
      org = Organisation.new_or_reconcile(domain_or_email: row[:email])

      next if org.new_record?

      create_affiliation(org, row[:email])

      action = build_action('Submitted Digital Candle Form', org, row[:timestamp])
      action.details = { name: row[:name], email: row[:email] }
      action.save!
    end
  end
end
