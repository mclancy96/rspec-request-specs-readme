class CreateResults < ActiveRecord::Migration[8.0]
  def change
    create_table :results do |t|
      t.string :value
      t.references :experiment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
