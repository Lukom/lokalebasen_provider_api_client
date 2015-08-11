require 'spec_helper'

describe LokalebasenApi::Mapper::Contact do
  let(:contact_resource) do
    double(
      "ContactResource",
      to_hash: {
        ext_key: "contact_ext_key"
      }
    )
  end

  it "mapifies a simple contact resource" do
    expected_value = {
      ext_key: "contact_ext_key",
      resource: contact_resource
    }

    expect(LokalebasenApi::Mapper::Location.new(contact_resource).mapify)
      .to eq(expected_value)
  end
end
