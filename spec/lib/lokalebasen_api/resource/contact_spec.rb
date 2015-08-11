require 'spec_helper'

describe LokalebasenApi::Resource::Contact do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:agent)         { agent_mock(faraday_stubs) }
  let(:root_resource) { LokalebasenApi::Resource::Root.new(agent).get }

  let(:contact_resource) do
    LokalebasenApi::Resource::Contact.new(root_resource)
  end

  let(:contact_params) do
    {
      external_key: 'contact_ext_key1'
    }
  end

  before do
    stub_get(faraday_stubs, '/api/provider', 200, root_fixture)
    stub_get(faraday_stubs, '/api/provider/contacts', 200, contact_list_fixture)
  end

  it 'returns all contacts' do
    external_key_values = [
      { external_key: 'contact_ext_key1' },
      { external_key: 'contact_ext_key2' }
    ]

    contact_resource.all.each_with_index do |contact, index|
      expect(contact)
        .to be_an_instance_of(Sawyer::Resource)

      expect(contact.to_hash)
        .to include(external_key_values[index])
    end
  end

  it 'finds a contact by the external key' do
    stub_get(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)

    resource = contact_resource.find_by_external_key('contact_ext_key1')

    expect(resource)
      .to be_an_instance_of(Sawyer::Resource)

    expect(resource.to_hash)
      .to include(contact_params)
  end

  it 'finds contact_resource with email' do
    stub_get(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)
    stub_get(faraday_stubs, '/api/provider/contacts/456', 200, contact_456_fixture)

    resource = contact_resource.find_by_email('nis@ejendomsmaegler.dk')

    expect(resource.rels[:self].get.data.contact.email)
      .to eq('nis@ejendomsmaegler.dk')
  end

  it 'returns nil when no contact_resource with email' do
    stub_get(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)
    stub_get(faraday_stubs, '/api/provider/contacts/456', 200, contact_456_fixture)

    expect(contact_resource.find_by_email('unknown@ejendomsmaegler.dk'))
      .to be_nil
  end

  it 'performs the correct requests on creation' do
    stub_post(faraday_stubs, '/api/provider/contacts', 201, contact_fixture)

    contact_resource.create(contact_params)

    faraday_stubs.verify_stubbed_calls
  end

  it 'returns a resource with location params on creation' do
    stub_post(faraday_stubs, '/api/provider/contacts', 201, contact_fixture)

    contact = contact_resource.create(contact_params)

    expect(contact)
      .to be_an_instance_of(Sawyer::Resource)

    expect(contact.to_hash)
      .to include(contact_params)
  end

  it 'updates a contact by a resource' do
    stub_get(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)
    stub_put(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)

    resource = contact_resource.all.first
    params = { contact: { external_key: 'new_external_key' } }
    contact_resource.update_by_resource(resource, params)

    faraday_stubs.verify_stubbed_calls
  end

  it 'returns a resource of the updated contact' do
    stub_get(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)
    stub_put(faraday_stubs, '/api/provider/contacts/123', 200, contact_fixture)

    resource = contact_resource.all.first
    params = { contact: contact_params }
    contact = contact_resource.update_by_resource(resource, params)

    expect(contact)
      .to be_an_instance_of(Sawyer::Resource)

    expect(contact.to_hash)
      .to include(contact_params)
  end
end
