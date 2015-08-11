require 'spec_helper'

describe LokalebasenApi::Resource::Root do
  let(:agent)    { double('Agent').as_null_object }
  let(:data)     { double('Data') }
  let(:response) { double('Response', data: data) }

  it 'returns data from the response returned by ResponseChecker' do
    allow(LokalebasenApi::ResponseChecker)
      .to receive(:check)
      .and_yield(response)

    expect(LokalebasenApi::Resource::Root.new(agent).get)
      .to eq(data)
  end
end
