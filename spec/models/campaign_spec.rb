# frozen_string_literal: true

require 'spec_helper'

module Sync
  RSpec.describe Sync::Campaign, type: :model do
    it { is_expected.to validate_presence_of(:job_id) }
    it { is_expected.to validate_presence_of(:external_reference) }
    it { is_expected.to validate_presence_of(:ad_description) }
  end
end
