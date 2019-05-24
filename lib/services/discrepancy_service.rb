# frozen_string_literal: true

require 'net/http'
require 'json'

module Sync
  class DiscrepancyService
    def initialize(external_server, model=Sync::Campaign, ignore=[], json_data_key='ads')
      @external_server = external_server
      @model = model
      @keys_to_ignore = ignore
      @json_data_key = json_data_key
    end

    def execute
      # [1] Get all references and fetch local versions
      external_references = external_data.map { |external_record| external_record['reference'].to_i }
      local_data = @model.where(external_reference: external_references).all

      # [2] For each record get discrepancies with remote
      keys_to_check = keys(external_data)
      discrepancies_arr = discrepancies(external_data, local_data, keys_to_check)

      JSON.generate(discrepancies_arr)
    end

    private

    def external_data
      response = Net::HTTP.get_response(URI(@external_server))
      JSON.parse(response.body)[@json_data_key]
    end

    def discrepancies(external_data, local_data, keys_to_check)
      discrepancies_arr = []
      external_data.zip(local_data).each do |external_record, local_record|
        # For each field in external record get the value in local record
        record_discrepancies_arr = record_discrepancies(external_record, local_record, keys_to_check)

        unless record_discrepancies_arr.empty?
          discrepancies_arr << discrepancy_entry(external_record['reference'], record_discrepancies_arr)
        end
      end
      discrepancies_arr
    end

    def record_discrepancies(external_record, local_record, keys_to_check)
      record_discrepancies_arr = []
      keys_to_check.each do |key|
        if external_record[key] != local_record.send(key.to_sym)
          record_discrepancies_arr << record_discrepancy_entry(external_record, local_record, key)
        end
      end
      record_discrepancies_arr
    end

    def keys(external_records)
      external_records.first.keys - (['reference'] + @keys_to_ignore)
    end

    def record_discrepancy_entry(external_record, local_record, key)
      {
        key => {
          "remote": external_record[key],
          "local": local_record.send(key.to_sym)
        }
      }
    end

    def discrepancy_entry(external_reference, record_discrepancies)
      {
        "external_reference": external_reference,
        "discrepancies": record_discrepancies
      }
    end
  end
end
