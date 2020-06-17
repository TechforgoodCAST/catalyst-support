# frozen_string_literal: true

class AnchorOrgFormJob < ApplicationJob
  queue_as :default

  def perform(row_start: 2)
    @rows = GoogleSheetsImport.new.extract(ENV['ANCHOR_CONFIG'], row_start: row_start)

    @rows.each do |row|
      org = Organisation.new_or_reconcile(domain_or_email: row[:user_email], name: row[:organisation_name])

      if org.new_record? && row[:organisation_name].present?
        org.name = row[:organisation_name]
        org.save!
      end

      next if org.new_record?

      create_affiliation(org, row[:user_email])

      action = build_action('Submitted Anchor Org Form', org, row[:timestamp])
      action.details = { name: row[:user_name], email: row[:user_email] }
      action.save!
    end
  end
end
