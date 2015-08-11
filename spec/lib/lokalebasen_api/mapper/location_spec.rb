require 'spec_helper'

describe LokalebasenApi::Mapper::Location do
  context 'without assets' do
    let(:location_resource) do
      double(
        'Location',
        to_hash: {
          ext_key: 'location_key'
        }
      )
    end

    let(:expected_value) do
      {
        ext_key: 'location_key',
        resource: location_resource
      }
    end

    it 'mapifies a simple resource without photos or floor plans correctly' do
      expect(LokalebasenApi::Mapper::Location.new(location_resource).mapify)
        .to eq(expected_value)
    end
  end

  context 'with photos' do
    let(:photo_resource) do
      double(
        'Photo',
        to_hash: {
          ext_key: 'photo_key'
        }
      )
    end

    let(:location_resource) do
      double(
        'Location',
        to_hash: {
          ext_key: 'location_key',
          photos: [photo_resource]
        }
      )
    end

    let(:expected_value) do
      {
        ext_key: 'location_key',
        resource: location_resource,
        photos: [photo_resource.to_hash]
      }
    end

    it 'mapifies a resource with photos correctly' do
      expect(LokalebasenApi::Mapper::Location.new(location_resource).mapify)
        .to eq(expected_value)
    end
  end

  context 'with floor plans' do
    let(:floor_plan_resource) do
      double(
        'FloorPlan',
        to_hash: {
          ext_key: 'floor_plan_key'
        }
      )
    end

    let(:location_resource) do
      double(
        'Location',
        to_hash: {
          ext_key: 'location_key',
          floor_plans: [floor_plan_resource]
        }
      )
    end

    let(:expected_value) do
      {
        ext_key: 'location_key',
        resource: location_resource,
        floor_plans: [floor_plan_resource.to_hash]
      }
    end

    it 'mapifies a resource with floor plans correctly' do
      expect(LokalebasenApi::Mapper::Location.new(location_resource).mapify)
        .to eq(expected_value)
    end
  end
end
