# frozen_string_literal: true

require 'spec_helper.rb'

module Sync
  RSpec.describe Sync::DiscrepancyService do
    let(:remote_server) { 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df' }

    before do
      Sync::Campaign.create!(external_reference: 1, status: :enabled,
                             description: 'Description for campaign 11', job_id: 1)
      Sync::Campaign.create!(external_reference: 2, status: :disabled,
                             description: 'Description for campaign 12', job_id: 1)
      Sync::Campaign.create!(external_reference: 3, status: :enabled,
                             description: 'Description for campaign 13', job_id: 1)
    end

    context 'when there is no discrepancies' do
      let(:service_response) { JSON.parse(Sync::DiscrepancyService.new(remote_server).execute) }

      it 'returns an empty array' do
        expect(service_response).to be_empty
      end
    end

    context 'when there is a discrepancy in status' do
      before(:each) do
        Sync::Campaign.first.disabled!
      end

      let!(:external_reference) { Sync::Campaign.first.external_reference }
      let(:service_response) { JSON.parse(Sync::DiscrepancyService.new(remote_server).execute) }
      let(:discreparency_obj) { service_response.first['discrepancies'].first }

      it 'returns a list of discrepancies' do
        expect(service_response).not_to be_empty
      end

      it 'returns a discreparency with the correct reference' do
        record_discreparency = service_response.first
        expect(record_discreparency['external_reference'].to_i).to eql external_reference
      end

      it 'returns a discrepancy with the correct field' do
        expect(discreparency_obj).to have_key 'status'
      end

      it 'returns a discrepancy with the correct values' do
        status_discreparency = discreparency_obj['status']
        expect([status_discreparency['remote'], status_discreparency['local']]).to eql %w[enabled disabled]
      end

      after(:each) do
        Sync::Campaign.first.enabled!
      end
    end

    context 'when there is a discrepancy in description' do
      before(:each) do
        Sync::Campaign.first.update(description: 'New Description')
      end

      let!(:external_reference) { Sync::Campaign.first.external_reference }
      let(:service_response) { JSON.parse(Sync::DiscrepancyService.new(remote_server).execute) }
      let(:discreparency_obj) { service_response.first['discrepancies'].first }

      it 'returns a list of discrepancies' do
        expect(service_response).not_to be_empty
      end

      it 'returns a discreparency with the correct reference' do
        record_discreparency = service_response.first
        expect(record_discreparency['external_reference'].to_i).to eql external_reference
      end

      it 'returns a discrepancy with the correct field' do
        expect(discreparency_obj).to have_key 'description'
      end

      it 'returns a discrepancy with the correct value' do
        status_discreparency = discreparency_obj['description']
        expect([status_discreparency['remote'], status_discreparency['local']])
          .to eql ['Description for campaign 11', 'New Description']
      end

      after(:each) do
        Sync::Campaign.first.update(description: 'Description for campaign 11')
      end
    end

    after do
      Sync::Campaign.delete_all
    end
  end
end
