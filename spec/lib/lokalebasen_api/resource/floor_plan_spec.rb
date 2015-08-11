require 'spec_helper'

describe LokalebasenApi::Resource::FloorPlan do
  it_behaves_like 'an asset', :floor_plans, :floor_plan do
    let(:asset_resource) do
      LokalebasenApi::Resource::FloorPlan.new(location_resource)
    end
  end
end
