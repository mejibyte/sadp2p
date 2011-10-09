class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :ip
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end
