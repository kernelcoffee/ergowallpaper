class CreateAspectRatios < ActiveRecord::Migration
  def change
    create_table :aspect_ratios do |t|
      t.string :name
      t.decimal :ratio,  :precision => 12, :scale => 2

      t.timestamps
    end
  end
end
