# frozen_string_literal: true

class OnlineDesignHopsJob < ApplicationJob
  queue_as :default

  def perform(row_start: 2)
    @rows = GoogleSheetsImport.new.extract(ENV['ONLINE_DESIGN_HOPS_CONFIG'], row_start: row_start)

    @rows.each do |row|
      org = Organisation.new_or_reconcile(domain_or_email: row[:email])

      next if org.new_record?

      create_affiliation(org, row[:email])

      action = build_action('Enrolled In Online Design Hop', org, row[:timestamp])
      action.details = { email: row[:email] }
      action.save!
    end
  end
end
