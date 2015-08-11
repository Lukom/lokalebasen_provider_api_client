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
      case response.status
      when 400..499
        fail "Error occured -> #{response.data.message}"
      when 500..599
        fail "Server error -> #{error_msg(response)}"
      end

      if block.nil?
        response
      else
        yield response
      end
    end

    private

    def error_msg(response)
      return "Server returned HTML in error" if response.data.index("html")
      response.data
    end
  end
end
