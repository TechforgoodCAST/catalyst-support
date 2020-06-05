class CreatePotentialActions < ActiveRecord::Migration[6.0]
  def change
    create_table :potential_actions do |t|
      t.string :name
      t.string :format

      t.timestamps
    end
  end
end
