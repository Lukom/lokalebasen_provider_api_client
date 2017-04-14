module LokalebasenApi
  class ResponseChecker
    attr_reader :response

    class << self
      def check(response, &block)
        new(response).check(&block)
      end
    end

    def initialize(response)
      @response = response
    end

    def check(&block)
      check_status

      if block.nil?
        response
      else
        yield response
      end
    end

    private

    def check_status
      case response.status
      when 400..499
        raise LokalebasenApi::Exceptions::InvalidResponse.new(response.data.to_h)
      when 500..599
        fail "Server error -> #{error_msg(response)}"
      end
    end

    def error_msg(response)
      return 'Server returned HTML in error' if response.data.index('html')
      response.data
    end
  end
end
