class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.belongs_to :user
      t.boolean :public, :default => false

      t.timestamps
    end
  end
end
