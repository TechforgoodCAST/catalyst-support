# frozen_string_literal: true

class AddSlugToOrganisations < ActiveRecord::Migration[6.0]
  def change
    add_column :organisations, :slug, :string, null: false
    add_index :organisations, :slug, unique: true
  end
end
