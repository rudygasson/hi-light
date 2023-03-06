class CreateHiTags < ActiveRecord::Migration[7.0]
  def change
    create_table :hi_tags do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :highlight, null: false, foreign_key: true

      t.timestamps
    end
  end
end
