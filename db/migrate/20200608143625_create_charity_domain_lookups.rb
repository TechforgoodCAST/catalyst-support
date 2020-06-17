class CreateCharityDomainLookups < ActiveRecord::Migration[6.0]
  def change
    create_table :charity_domain_lookups do |t|
      t.string :regno, index: true
      t.string :name
      t.string :domain, index: true

      t.timestamps
    end
  end
end
