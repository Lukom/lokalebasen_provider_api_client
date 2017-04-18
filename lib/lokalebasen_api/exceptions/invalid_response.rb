module LokalebasenApi
  module Exceptions
    class InvalidResponse < Base;
      attr_reader :data

      def initialize(data)
        @data = data
      end
    end
  end
end
