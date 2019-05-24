# frozen_string_literal: true

require_relative 'sync/version'
require 'active_record'

# Establish Database Connection
def lib_path
  File.expand_path(__dir__)
end

def db_config
  db_config_file = File.join(lib_path, 'db', 'config.yml')
  YAML.safe_load(File.read(db_config_file), [], [], true)
end

ActiveRecord::Base.establish_connection(db_config[ENV['env'] || 'development'])

module Sync
  # Include Models
  Dir.glob(File.join(lib_path, 'models/**/*.rb')).each do |model_file|
    require_dependency(model_file)
  end

  # Include Services Here
  Dir.glob(File.join(lib_path, 'services/**/*.rb')).each do |service_file|
    require_dependency(service_file)
  end
end
