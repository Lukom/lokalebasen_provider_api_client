require 'spec_helper'

describe LokalebasenApi::LocationClient do
  let(:agent) { double("Agent") }

  before do
    allow(LokalebasenApi::Resource::Root)
      .to receive_message_chain(:new, :get)
  end

  it "returns all location resources as map" do
    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    location_resources = 2.times.map { double("LocationResource") }

    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :all)
      .and_return(location_resources)

    mapped_locations = 2.times.map { mapped_location }

    expect(LokalebasenApi::LocationClient.new(agent).locations)
      .to eq(mapped_locations)
  end

  it "returns a mapped resource by external key" do
    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :find_by_external_key)

    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    expect(LokalebasenApi::LocationClient.new(agent).location("ext_key"))
      .to eq(mapped_location)
  end

  it "returns a mapped result of the location creation" do
    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :create)

    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    location_params = { :location => { :external_key => "external_key "}}

    expect(LokalebasenApi::LocationClient.new(agent).create_location(location_params))
      .to eq(mapped_location)
  end

  it "returns a mapped result of the updated location" do
    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :update)

    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    location_params = { "location" => { "external_key" => "external_key "}}

    expect(LokalebasenApi::LocationClient.new(agent).update_location(location_params))
      .to eq(mapped_location)
  end

  it "returns a mapped result of the deactivated location" do
    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :deactivate)

    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    expect(LokalebasenApi::LocationClient.new(agent).deactivate("external_key"))
      .to eq(mapped_location)
  end

  it "returns a mapped result of the activated location" do
    allow(LokalebasenApi::Resource::Location)
      .to receive_message_chain(:new, :activate)

    mapped_location = double("MappedLocation")

    allow(LokalebasenApi::Mapper::Location)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_location)

    expect(LokalebasenApi::LocationClient.new(agent).activate("external_key"))
      .to eq(mapped_location)
  end

  context "dealing with assets" do
    let(:asset_ext_key)    { "asset_ext_key" }
    let(:location_ext_key) { "location_ext_key" }
    let(:asset_url)        { "http://myhost.com/image/123" }
    let(:location)         { double("Location") }
    let!(:asset_resource)  { asset_resource_class.new(location) }

    let(:location_client) do
      LokalebasenApi::LocationClient.new(agent)
    end

    before do
      allow(asset_resource_class)
        .to receive(:new)
        .and_return(asset_resource)
    end

    shared_examples "an asset client" do |asset_type|
      it "returns a mapped job when creating a #{asset_type}" do
        allow(LokalebasenApi::Resource::Location)
          .to receive_message_chain(:new, :find_by_external_key)

        mapped_job = double("MappedJob")

        allow(LokalebasenApi::Mapper::Job)
          .to receive_message_chain(:new, :mapify)
          .and_return(mapped_job)

        allow(asset_resource)
          .to receive(:create)

        expect(
          location_client.public_send(
            "create_#{asset_type}",
            asset_url,
            asset_ext_key,
            location_ext_key
          )
        ).to eq(mapped_job)
      end

      it "deletes an #{asset_type}" do
        allow(LokalebasenApi::Resource::Location)
          .to receive_message_chain(:new, :find_by_external_key)
        allow(LokalebasenApi::Mapper::Job)
          .to receive_message_chain(:new, :mapify)

        expect(asset_resource)
          .to receive(:delete)
          .with(asset_ext_key)

        location_client.public_send(
          "delete_#{asset_type}",
          asset_ext_key,
          location_ext_key
        )
      end
    end

    describe "photos" do
      let(:asset_resource_class) { LokalebasenApi::Resource::Photo }

      it_behaves_like "an asset client", :photo do
      end

      it "creates a photo" do
        allow(LokalebasenApi::Resource::Location)
          .to receive_message_chain(:new, :find_by_external_key)
        allow(LokalebasenApi::Mapper::Job)
          .to receive_message_chain(:new, :mapify)

        expect(asset_resource)
          .to receive(:create)
          .with(asset_url, asset_ext_key, 1)

        location_client.public_send(
          "create_photo",
          asset_url,
          asset_ext_key,
          location_ext_key,
          1
        )
      end
    end

    describe "prospectus" do
      let(:asset_resource_class) { LokalebasenApi::Resource::Prospectus }

      it_behaves_like "an asset client", :prospectus do
      end

      it "creates a prospectus" do
        allow(LokalebasenApi::Resource::Location)
          .to receive_message_chain(:new, :find_by_external_key)
        allow(LokalebasenApi::Mapper::Job)
          .to receive_message_chain(:new, :mapify)

        expect(asset_resource)
          .to receive(:create)
          .with(asset_url, asset_ext_key)

        location_client.public_send(
          "create_prospectus",
          asset_url,
          asset_ext_key,
          location_ext_key
        )
      end
    end

    describe "floor plans" do
      let(:asset_resource_class) { LokalebasenApi::Resource::FloorPlan }

      it_behaves_like "an asset client", :floorplan do
      end

      it "creates a floor plan" do
        allow(LokalebasenApi::Resource::Location)
          .to receive_message_chain(:new, :find_by_external_key)
        allow(LokalebasenApi::Mapper::Job)
          .to receive_message_chain(:new, :mapify)

        expect(asset_resource)
          .to receive(:create)
          .with(asset_url, asset_ext_key, 1)

        location_client.public_send(
          "create_floorplan",
          asset_url,
          asset_ext_key,
          location_ext_key,
          1
        )
      end
    end
  end
end
