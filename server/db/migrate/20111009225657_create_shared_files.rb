class CreateSharedFiles < ActiveRecord::Migration
  def change
    create_table :shared_files do |t|
      t.string :filename

      t.timestamps
    end
  end
end
