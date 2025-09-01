class CreateScientists < ActiveRecord::Migration[8.0]
  def change
    create_table :scientists do |t|
      t.string :name
      t.string :field

      t.timestamps
    end
  end
end
