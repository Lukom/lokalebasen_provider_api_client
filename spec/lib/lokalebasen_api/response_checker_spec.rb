require 'spec_helper'

describe LokalebasenApi::ResponseChecker do
  let(:data_with_message) { double('Data', error_message: 'ErrorMessage') }
  let(:raw_data)          { double('Data', index: false, to_s: 'RawError') }

  it 'fails with response error message if response status is 400' do
    response_400 = double('Response', status: 400, data: data_with_message)

    expect(lambda do
      LokalebasenApi::ResponseChecker.new(response_400).check
    end).to raise_error(LokalebasenApi::Exceptions::InvalidResponse)
  end

  it 'fails with response error message if response status is 404' do
    response_499 = double('Response', status: 404, data: data_with_message)

    expect(lambda do
      LokalebasenApi::ResponseChecker.new(response_499).check
    end).to raise_error(LokalebasenApi::Exceptions::InvalidResponse)
  end

  it 'fails with response data if response status is 500' do
    response_500 = double('Response', status: 500, data: raw_data)

    expect(lambda do
      LokalebasenApi::ResponseChecker.new(response_500).check
    end).to raise_error(RuntimeError)
  end

  it 'fails with response data if response status is 502' do
    response_502 = double('Response', status: 502, data: raw_data)

    expect(lambda do
      LokalebasenApi::ResponseChecker.new(response_502).check
    end).to raise_error(RuntimeError)
  end

  it 'yields response if response status is 200' do
    response_200 = double('Response', status: 200)

    expect(lambda do |block|
      LokalebasenApi::ResponseChecker.new(response_200).check(&block)
    end).to yield_with_args(response_200)
  end

  it 'returns response if response status is 200' do
    response_200 = double('Response', status: 200)

    expect(LokalebasenApi::ResponseChecker.new(response_200).check)
      .to eq(response_200)
  end
end
