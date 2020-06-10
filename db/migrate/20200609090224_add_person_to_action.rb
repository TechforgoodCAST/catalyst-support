class AddPersonToAction < ActiveRecord::Migration[6.0]
  def change
    add_reference :actions, :person, null: true, foreign_key: true
  end
end
