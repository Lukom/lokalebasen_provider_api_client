module LokalebasenApi
  module ClientHelper
    # Sets state on the resource, by calling post on relation
    # defined by relation_type e.g.
    # set_state(:deactivation, location_resource) #=> location
    # @param relation_type [Symbol] state e.g. :deactivation
    # @param resource [Sawyer::Resource] the resource to set state on
    # @return [Sawyer::Resource] response
    def set_state(relation_type, resource)
      relation = add_method(resource.rels[relation_type], :post)
      response = relation.post
      check_response(response)
      response
    end

    # PATCH: Because Lokalebasen API relations URLs do not include
    # possible REST methods, Sawyer defaults to :get only.
    # This methods adds a REST method to the relation
    # @!visibility private
    # @param method [Symbol] - :put, :post, :delete
    # @return [Sawyer::Relation] patched relation
    def add_method(relation, method)
      relation.instance_variable_get(:@available_methods).add(method)
      relation
    end

    def check_response(response)
      case response.status
      when 400..499
        fail "Error occured -> #{response.data.message}"
      when 500..599
        fail "Server error -> #{error_msg(response)}"
      end
    end

    def error_msg(response)
      return 'Server returned HTML in error' if response.data.index('html')
      data
    end
  end
end
