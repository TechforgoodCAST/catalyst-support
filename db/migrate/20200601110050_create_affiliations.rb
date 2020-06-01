# frozen_string_literal: true

class CreateAffiliations < ActiveRecord::Migration[6.0]
  def change
    create_table :affiliations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.string :details

      t.timestamps null: false
    end
  end
end
