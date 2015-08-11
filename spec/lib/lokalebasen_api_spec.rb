require 'spec_helper'

describe LokalebasenApi do
  let(:url)    { 'http://www.service_url.com' }
  let(:client) { double('Client') }

  let(:credentials) do
    {
      api_key: 'MyApiKey'
    }
  end

  it 'returns a client with given arguments' do
    allow(LokalebasenApi::Client)
      .to receive(:new)
      .and_return(client)

    expect(LokalebasenApi.client(credentials, url))
      .to eq(client)
  end
end
