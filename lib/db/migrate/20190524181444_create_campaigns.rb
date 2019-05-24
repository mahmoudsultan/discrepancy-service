# frozen_string_literal: true

class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.bigint :job_id
      t.integer :status, default: 0
      t.bigint :external_reference
      t.text :ad_description

      t.timestamps
    end
  end
end
