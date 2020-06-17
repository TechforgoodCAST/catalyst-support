# frozen_string_literal: true

class DesignHopsJob < ApplicationJob
  queue_as :default

  def perform
    @hop_attendees = Airrecord.table(ENV['AIRTABLE_API_KEY'], 'appchfb5dUtfrlVSZ', 'Attendee sign-up data')

    @hop_attendees.all.each do |record|
      domain = record['Email'].split('@').last.strip
      org_name = record['Organisation name']&.strip

      org = Organisation.new_or_reconcile(domain_or_email: domain, name: org_name)

      if org.new_record? && org_name.present?
        org.name = org_name
        org.save!
      end

      next if org.new_record?

      create_affiliation(org, record['Email'])

      action = build_action('Signed Up For Design Hop', org, record.created_at)
      action.details = {
        name: "#{record['First name']} #{record['Last name']}",
        email: record['Email']
      }
      action.save!
    end
  end
end
