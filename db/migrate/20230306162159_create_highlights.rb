class CreateHighlights < ActiveRecord::Migration[7.0]
  def change
    create_table :highlights do |t|
      t.text :quote
      t.integer :page
      t.integer :location_start
      t.integer :location_end
      t.datetime :highlight_date
      t.boolean :public
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
