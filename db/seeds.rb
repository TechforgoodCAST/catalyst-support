# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

CSV.foreach(Rails.root.join('lib/charity_domains_with_web.csv'), headers: true) do |row|
  CharityDomainLookup.create(name: row['name'], regno: row['org_id'], email_domain: row['domain_from_email'], web_domain: row['domain_from_web'])
end
