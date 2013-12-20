class CreateAlbumAssignments < ActiveRecord::Migration
  def change
    create_table :album_assignments do |t|
      t.integer :wallpaper_id
      t.integer :album_id

      t.timestamps
    end
  end
end
