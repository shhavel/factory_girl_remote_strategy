require "active_support/core_ext/module/delegation"
require "factory_girl"
require "active_resource"
##
# FactoryGirl strategy for remote entities
#
# - FactoryGirl.remote(:incident) builds incident and registers get url with FakeWeb;
# - remote associations are added to response json:
#     FactoryGirl.remote(:incident, victims: FactoryGirl.remote_list(:victim, 2))
# - also allows to create has_many association with <assotiation(s)>_ids option:
#     FactoryGirl.remote(:incident, victim_ids: [2, 3])
# - belongs_to association id is added to response json:
#     FactoryGirl.remote(:membership, group: group) # group_id is added to serialized hash
# - after(:remote) callback in factories.
#
module FactoryGirl
  class RemoteStrategy
    def initialize
      @strategy = FactoryGirl.strategy_by_name(:build).new
    end

    delegate :association, to: :@strategy

    def result(evaluation)
      @strategy.result(evaluation).tap do |e|
        self.class.register_request(:get, self.class.entity_url(e), body: self.class.entity_hash(e).to_json)
        self.class.register_request(:put, self.class.entity_url(e), body: self.class.entity_hash(e).to_json)
        remote_search(e, search: { :"#{e.class.primary_key}_eq" => e.public_send(e.class.primary_key) })
        remote_search(e, search: { :"#{e.class.primary_key}_in" => [e.public_send(e.class.primary_key)] })
        evaluation.notify(:after_remote, e) # runs after(:remote) callback
      end
    end

    class << self
      def entity_hash(entity, params = {})
        raise ArgumentError, "cann't construct hash for non ActiveResource::Base object" unless entity.is_a?(ActiveResource::Base)
        attributes = entity.attributes
        # Set belongs_to <association>_id instead of each <association>.
        attributes.select { |k, v| v.is_a?(ActiveResource::Base) }.each do |k, v|
          attributes[:"#{k}_id"] = v.id
          attributes.delete(k)
        end
        # Set has_many <association> instead of each <association(s)>_ids.
        attributes.map do |k, v|
          next unless k.to_s =~ /^(\w+)_ids$/ && FactoryGirl.factories.map(&:name).include?(f = $1.singularize.to_sym) && v.is_a?(Array)
          [k, v, f, $1.pluralize.to_sym]
        end.compact.each do |k, v, f, r|
          attributes[r] = v.map { |id| FactoryGirl.remote(f, id: id) }
          attributes.delete(k)
        end
        # Serilaize has_many associations.
        attributes.each do |k, v|
          if v.is_a?(Array) && v.first.is_a?(ActiveResource::Base)
            attributes[k] = v.map { |e| entity_hash(e) }
          end
        end
        { entity.class.element_name => attributes }.tap do |h|
          h[:_metadata] = { abilities: %w(update destroy) } unless params[:metadata] == false
        end
      end

      def entity_url(entity)
        "#{entity.class.site}#{entity.class.prefix}#{entity.class.collection_name}/#{entity.id}.json"
      end

      def collection_url(collection, params = {})
        (collection.first.is_a?(Class) ? collection.first : collection.first.class).instance_eval { "#{site}#{prefix}#{collection_name}.json#{'?' if params.any?}#{params.to_query}" }
      end

      def stub_requests_with(library)
        library = library.to_s
        raise ArgumentError, "Unknown library '#{library}', please try :webmock or :fakeweb" unless %w(webmock fakeweb).include?(library)
        require library
        @@library = library.to_sym
      rescue LoadError
        worn "WARNING: gem '#{library}' is not installed"
      end

      def register_request(http_method, uri, options)
        if @@library == :fakeweb
          FakeWeb.register_uri(http_method, uri, options)
        else
          WebMock.stub_request(http_method, uri).to_return(options)
        end
      end
    end
  end

  class RemoteNotFoundStrategy < RemoteStrategy
    def result(evaluation)
      @strategy.result(evaluation).tap do |e|
        body = { errors: [{ code: 'resource_not_found',
          message: "Couldn't find #{e.class} with #{e.class.primary_key}=#{e.public_send(e.class.primary_key)}" } ] }.to_json
        self.class.register_request(:get, self.class.entity_url(e), body: body, status: 404)
        remote_search(e.class, search: { :"#{e.class.primary_key}_eq" => e.public_send(e.class.primary_key) }) # empty search
        remote_search(e.class, search: { :"#{e.class.primary_key}_in" => [e.public_send(e.class.primary_key)] }) # empty search
      end
    end
  end
end

FactoryGirl.register_strategy(:remote, FactoryGirl::RemoteStrategy)
FactoryGirl.register_strategy(:remote_not_found, FactoryGirl::RemoteNotFoundStrategy)

##
# Helper method for register search url with provided params and serialized collection as response.
#
def remote_search(*args)
  params = args.extract_options!
  collection = args.flatten
  ::FactoryGirl::RemoteStrategy.register_request(:get, FactoryGirl::RemoteStrategy.collection_url(collection, params),
    body: (collection.first.is_a?(Class) ? "[]" : collection.map { |e| FactoryGirl::RemoteStrategy.entity_hash(e, params) }.to_json))
end
