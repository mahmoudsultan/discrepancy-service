# frozen_string_literal: true

module Sync
  class Campaign < Sync::ApplicationRecord
    enum status: %i[enabled paused disabled]

    validates :job_id, :external_reference, :description, presence: true
  end
end
