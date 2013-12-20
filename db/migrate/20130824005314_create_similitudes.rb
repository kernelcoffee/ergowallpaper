class CreateSimilitudes < ActiveRecord::Migration
  def change
    create_table :similitudes do |t|
      t.integer :wallpaper_id
      t.integer :similar_id

      t.timestamps
    end
  end
end
