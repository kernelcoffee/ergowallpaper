class CreateResolutions < ActiveRecord::Migration
  def change
    create_table :resolutions do |t|
      t.integer :width, :height
      t.integer :multi, :default => 3
	  t.boolean :portrait, :default => true

	  t.belongs_to :aspect_ratio

      t.timestamps
    end
  end
end
