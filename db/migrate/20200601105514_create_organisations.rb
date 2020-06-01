# frozen_string_literal: true

class CreateOrganisations < ActiveRecord::Migration[6.0]
  def change
    create_table :organisations do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
