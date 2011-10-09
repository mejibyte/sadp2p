class CreateClientsSharedFilesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :clients_shared_files, :id => false do |t|
      t.integer :client_id
      t.integer :shared_files_id
    end
  end

  def self.down
    drop_table :client_shared_files
  end
end
