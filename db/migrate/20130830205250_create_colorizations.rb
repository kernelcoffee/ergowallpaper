class CreateColorizations < ActiveRecord::Migration
  def change
    create_table :colorizations do |t|
      t.integer :wallpaper_id
      t.integer :coloration_id

      t.timestamps
    end
  end
end
