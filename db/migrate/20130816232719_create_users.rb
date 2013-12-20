class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :limit => 50, :unique => true
      t.boolean :admin, :default => false
      t.boolean :public, :default => true

      t.timestamps
    end
  end
end
