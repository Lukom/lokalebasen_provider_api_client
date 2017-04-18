module LokalebasenApi
  class BaseError < ::StandardError; end

  class InvalidResponseError < BaseError;
    attr_reader :data

    def initialize(data)
      @data = data
    end
  end
end
