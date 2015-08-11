require 'map'

module LokalebasenApi
  module Mapper
    class Location
      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def mapify
        resource_to_map_object(resource)
      end

      private

      def resource_to_map_object(resource)
        res = Map.new(resource)
        res.floor_plans = floor_plans(res) if res.has?(:floor_plans)
        res.photos = photos(res) if res.has?(:photos)

        res = Map.new(res.to_hash) # Minor hack
        res.resource = resource
        res
      end

      def floor_plans(resource)
        resource.floor_plans.map(&:to_hash)
      end

      def photos(resource)
        resource.photos.map(&:to_hash)
      end
    end
  end
end
