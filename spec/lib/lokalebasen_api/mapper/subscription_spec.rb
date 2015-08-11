require 'spec_helper'

describe LokalebasenApi::Mapper::Subscription do
  let(:subscription_resource) do
    double(
      "SubscriptionResource",
      to_hash: {
        ext_key: "subscription_ext_key"
      }
    )
  end

  it "mapifies a simple subscription resource" do
    expected_value = {
      ext_key: "subscription_ext_key",
      resource: subscription_resource
    }

    expect(LokalebasenApi::Mapper::Location.new(subscription_resource).mapify)
      .to eq(expected_value)
  end
end
