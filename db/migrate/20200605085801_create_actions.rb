class CreateActions < ActiveRecord::Migration[6.0]
  def change
    create_table :actions do |t|
      t.references :potential_action, null: false, foreign_key: true
      t.references :organisation, null: false, foreign_key: true
      t.jsonb :details
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
