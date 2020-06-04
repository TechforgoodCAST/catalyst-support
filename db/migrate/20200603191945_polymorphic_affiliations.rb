# frozen_string_literal: true

class PolymorphicAffiliations < ActiveRecord::Migration[6.0]
  def change
    rename_column :affiliations, :user_id, :individual_id
    add_column :affiliations, :individual_type, :string, null: false, default: 'User'
    add_index :affiliations, %i[individual_id individual_type]
  end
end
