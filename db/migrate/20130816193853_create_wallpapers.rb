class CreateWallpapers < ActiveRecord::Migration
  def change
    create_table :wallpapers do |t|
      t.string :name
      t.string :image
      t.string :format
      t.integer :filesize
      t.integer :purity
      t.string :fingerprint

      t.string :author
      t.string :author_website

      t.integer :multi, :default => 1
      t.boolean :portrait, :default => false
      t.boolean :processed, :default => false
      t.boolean :reviewed, :default => false

      t.belongs_to :user
      t.belongs_to :resolution

      t.timestamps
    end
  end
end
