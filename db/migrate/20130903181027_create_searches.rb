class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :keywords
      t.string :geometry
      t.string :color
      
      t.boolean :portrait

      t.boolean :checked, :default => true
      t.boolean :reviewed, :default => true

      t.boolean :purity_safe, default: true
      t.boolean :purity_sketchy, default: false
      t.boolean :purity_nsfw, default: false

      t.belongs_to :user
      t.timestamps
    end
  end
end
