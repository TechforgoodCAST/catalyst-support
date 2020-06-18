class DropColumnsFromOrganisations < ActiveRecord::Migration[6.0]
  def change
    remove_column :organisations, :domain, :string
    remove_column :organisations, :charity_number, :string
    remove_column :organisations, :company_number, :string
  end
end
