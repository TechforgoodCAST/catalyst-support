# frozen_string_literal: true

require 'csv'

namespace :seed do
  # usage: rake seed:domain_lookups ROW_START=2
  desc 'Import data for lookup table of website domains for charities'
  task domain_lookups: :environment do
    file = File.read(Rails.root.join('lib/data/charity_domains_with_web.csv'))
    csv = CSV.parse(file, headers: true)
    row_start = ENV['ROW_START']&.to_i || 2

    csv[row_start..csv.size].find_all.with_index do |row, i|
      CharityDomainLookup.find_or_create_by!(row.to_hash.except('generic_domain', 'web'))
      print("\r#{i + 1} of #{csv.size}")
    end
    puts
  end
end
