class MakeOrganisationOptional < ActiveRecord::Migration[6.0]
  def change
    change_column :actions, :person_id, :bigint, null: true
    change_column :actions, :organisation_id, :bigint, null: true
  end
end
