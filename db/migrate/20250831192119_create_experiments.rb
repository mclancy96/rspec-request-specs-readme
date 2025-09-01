class CreateExperiments < ActiveRecord::Migration[8.0]
  def change
    create_table :experiments do |t|
      t.string :title
      t.references :scientist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
