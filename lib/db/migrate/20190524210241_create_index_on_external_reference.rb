class CreateIndexOnExternalReference < ActiveRecord::Migration[5.2]
  def change
    add_index :campaigns, :external_reference
  end
end
