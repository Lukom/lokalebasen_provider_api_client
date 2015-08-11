require 'spec_helper'

describe LokalebasenApi::SubscriptionClient do
  let(:location_resource)     { double('LocationResource') }
  let(:subscription_resource) { double('SubscriptionResource') }

  let(:contact_resource) do
    double(
      'ContactResource',
      rels: {
        self: double(href: 'http://www.contact.dk/1')
      }
    )
  end

  it 'returns a list of mapified subscriptions for the given location' do
    subscriptions = [double('Subscription')]
    mapped_subscription = double('MappedSubscription')

    allow(LokalebasenApi::Resource::Subscription)
      .to receive_message_chain(:new, :all)
      .and_return(subscriptions)

    allow(LokalebasenApi::Mapper::Subscription)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_subscription)

    expect(LokalebasenApi::SubscriptionClient.new.subscriptions_for_location(location_resource))
      .to match_array([mapped_subscription])
  end

  it 'creates a sugsbscription by a given location resource and contact resource' do
    allow(LokalebasenApi::Resource::Subscription)
      .to receive(:new)
      .and_return(subscription_resource)

    subscription_params = { contact: 'http://www.contact.dk/1' }

    expect(subscription_resource)
      .to receive(:create)
      .with(subscription_params)

    LokalebasenApi::SubscriptionClient.new
      .create_subscription(location_resource, contact_resource)
  end

  it 'returns a mapped version of the response after create' do
    allow(LokalebasenApi::Resource::Subscription)
      .to receive_message_chain(:new, :create)

    mapped_subscription = double('MappedSubscription')

    allow(LokalebasenApi::Mapper::Subscription)
      .to receive_message_chain(:new, :mapify)
      .and_return(mapped_subscription)

    expect(LokalebasenApi::SubscriptionClient.new.create_subscription(location_resource, contact_resource))
      .to eq(mapped_subscription)
  end

  it 'deletes a subscription by the resource' do
    subscription = double('Subscription')

    allow(LokalebasenApi::Resource::Subscription)
      .to receive(:new)
      .and_return(subscription_resource)

    expect(subscription_resource)
      .to receive(:delete)
      .with(subscription)

    LokalebasenApi::SubscriptionClient.new.delete_subscription(subscription)
  end
end
