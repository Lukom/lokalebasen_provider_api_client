require 'spec_helper'

describe LokalebasenApi::Resource::Photo do
  it_behaves_like 'an asset', :photos, :photo do
    let(:asset_resource) do
      LokalebasenApi::Resource::Photo.new(location_resource)
    end
  end
end
