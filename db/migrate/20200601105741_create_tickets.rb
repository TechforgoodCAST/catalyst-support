# frozen_string_literal: true

class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.references :organisation, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.jsonb :body
      t.string :source

      t.timestamps null: false
    end
  end
end
