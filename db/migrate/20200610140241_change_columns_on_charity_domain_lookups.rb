class ChangeColumnsOnCharityDomainLookups < ActiveRecord::Migration[6.0]
  def change
    rename_column :charity_domain_lookups, :domain, :email_domain
    add_column :charity_domain_lookups, :web_domain, :string, index: true
  end
end
