class CreateClientErrors < ActiveRecord::Migration
  def self.up
    create_table :client_errors do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :client_errors
  end
end
