class AddDomainToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :domain, :string
    add_index :organisations, :domain, unique: true
  end
end
