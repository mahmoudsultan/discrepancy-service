# frozen_string_literal: true

module Sync
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
