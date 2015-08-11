require 'spec_helper'

module LokalebasenApi
  describe ContactClient do
    let(:agent)          { double('Agent') }
    let(:mapped_contact) { double('MappedContact') }

    let(:contact_params) do
      {
        external_key: 'ext_key'
      }
    end

    before do
      allow(Resource::Root)
        .to receive_message_chain(:new, :get)

      allow(Mapper::Contact)
        .to receive_message_chain(:new, :mapify)
        .and_return(mapped_contact)
    end

    it 'returns all contacts as maps' do
      contact_resources = 2.times.map { double('ContactResource') }

      allow(Resource::Contact)
        .to receive_message_chain(:new, :all)
        .and_return(contact_resources)

      mapped_contacts = 2.times.map { mapped_contact }

      expect(ContactClient.new(agent).contacts)
        .to eq(mapped_contacts)
    end

    it 'returns a mapped contact resource by external key' do
      allow(Resource::Contact)
        .to receive_message_chain(:new, :find_by_external_key)

      expect(ContactClient.new(agent).find_contact_by_external_key('ext_key'))
        .to eq(mapped_contact)
    end

    it 'creates a contact' do
      contact_resource = double('ContactResource')

      allow(Resource::Contact)
        .to receive(:new)
        .and_return(contact_resource)

      expect(contact_resource)
        .to receive(:create)
        .with(contact_params)

      ContactClient.new(agent).create_contact(contact_params)
    end

    it 'returns a mapped contact of the respone from contact create' do
      allow(Resource::Contact)
        .to receive_message_chain(:new, :create)

      expect(ContactClient.new(agent).create_contact('ext_key'))
        .to eq(mapped_contact)
    end

    it 'updates a contact' do
      input_resource = double('Resource')
      contact_resource = double('ContactResource')

      allow(Resource::Contact)
        .to receive(:new)
        .and_return(contact_resource)

      expect(contact_resource)
        .to receive(:update_by_resource)
        .with(input_resource, contact_params)

      ContactClient
        .new(agent)
        .update_contact_by_resource(input_resource, contact_params)
    end

    it 'returns a mapped contact of the respone from contact update' do
      input_resource = double('Resource')
      params = { contact: contact_params }

      allow(Resource::Contact)
        .to receive_message_chain(:new, :update_by_resource)

      contacts =
        ContactClient
          .new(agent)
          .update_contact_by_resource(input_resource, params)

      expect(contacts)
        .to eq(mapped_contact)
    end
  end
end
