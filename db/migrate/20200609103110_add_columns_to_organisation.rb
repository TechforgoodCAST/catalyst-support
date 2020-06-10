class AddColumnsToOrganisation < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :charity_number, :string
    add_column :organisations, :company_number, :string
    add_column :organisations, :location, :jsonb
    add_column :organisations, :audience, :string
    add_column :organisations, :subsector, :jsonb
    add_column :organisations, :maturity, :int
    add_column :organisations, :anchor_org, :bool
  end
end
