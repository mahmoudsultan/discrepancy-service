# frozen_string_literal: true

module Sync
  class Campaign < Sync::ApplicationRecord
    enum status: %i[active paused deleted]

    validates :job_id, :external_reference, :ad_description, presence: true
  end
end
