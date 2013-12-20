class CreateColorations < ActiveRecord::Migration
  def change
    create_table :colorations do |t|
      t.integer :r
      t.integer :b
      t.integer :g
      t.string :hex

      t.timestamps
    end
  end
end
