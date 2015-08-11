require 'spec_helper'

describe LokalebasenApi::Resource::Prospectus do
  it_behaves_like 'an asset', :prospectuses, :prospectus do
    let(:asset_resource) do
      LokalebasenApi::Resource::Prospectus.new(location_resource)
    end
  end
end
