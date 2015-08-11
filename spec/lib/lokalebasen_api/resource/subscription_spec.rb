require 'spec_helper'

describe LokalebasenApi::Resource::Location do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:agent)         { agent_mock(faraday_stubs) }
  let(:root_resource) { LokalebasenApi::Resource::Root.new(agent).get }

  let(:location_resource) do
    LokalebasenApi::Resource::Location
      .new(root_resource)
      .find_by_external_key('location_ext_key')
  end

  let(:subscription_resource) do
    LokalebasenApi::Resource::Subscription.new(location_resource)
  end

  before do
    stub_get(
      faraday_stubs,
      '/api/provider',
      200,
      root_fixture
    )

    stub_get(
      faraday_stubs,
      '/api/provider/locations',
      200,
      location_list_fixture
    )

    stub_get(
      faraday_stubs,
      '/api/provider/locations/123',
      200,
      location_fixture
    )
  end

  it 'returns all subscriptions' do
    stub_get(
      faraday_stubs,
      '/api/provider/locations/123/subscriptions',
      200,
      subscription_list_fixture
    )

    subscription_values = [
      { contact: 'http://www.lokalebasen.dk/api/provider/contacts/123' },
      { contact: 'http://www.lokalebasen.dk/api/provider/contacts/456' }
    ]

    subscription_resource.all.each_with_index do |location, index|
      expect(location)
        .to be_an_instance_of(Sawyer::Resource)

      expect(location.to_hash)
        .to include(subscription_values[index])
    end
  end

  it 'performs the correct requests when creating a subscription' do
    stub_post(
      faraday_stubs,
      '/api/provider/locations/123/subscriptions',
      200,
      subscription_fixture
    )

    params = { contact: '/api/provider/contacts/123' }
    subscription_resource.create(params)

    faraday_stubs.verify_stubbed_calls
  end

  it 'returns a sawyer resource on creation' do
    stub_post(
      faraday_stubs,
      '/api/provider/locations/123/subscriptions',
      200,
      subscription_fixture
    )

    params = { contact: '/api/provider/contacts/123' }
    subscription = subscription_resource.create(params)

    expect(subscription)
      .to be_an_instance_of(Sawyer::Resource)

    expect(subscription.to_hash)
      .to include params
  end

  it 'performs the correct requests when deleting a subscription' do
    stub_get(
      faraday_stubs,
      '/api/provider/locations/123/subscriptions',
      200,
      subscription_list_fixture
    )

    stub_delete(
      faraday_stubs,
      '/api/provider/subscriptions/123',
      204,
      {}
    )

    first_subscription = subscription_resource.all.first
    subscription_resource.delete(first_subscription)

    faraday_stubs.verify_stubbed_calls
  end

  it 'returns the status code for the delete response' do
    stub_get(
      faraday_stubs,
      '/api/provider/locations/123/subscriptions',
      200,
      subscription_list_fixture
    )

    stub_delete(
      faraday_stubs,
      '/api/provider/subscriptions/123',
      204,
      {}
    )

    first_subscription = subscription_resource.all.first

    expect(subscription_resource.delete(first_subscription))
      .to eq(204)
  end
end
