module ActiveAdmin
  module Mongoid
    module Adapter
      class Search
        attr_reader :base, :query, :query_hash, :search_params

        def initialize(object, search_params = {})
          @base = object
          @search_params = search_params
          @query = @base.where(build_query(search_params))
        end

        def respond_to?(method_id)
          @query.send(:respond_to?, method_id)
        end

        def method_missing(method_id, *args, &block)
          is_available?(method_id) ? @search_params[method_id] : @query.send(method_id, *args, &block)
        end

        private

        def is_available?(method_id)
          method_id.to_s =~ /_(gte?|lte?|eq|ne|contains)\Z/
        end

        def build_query(search_params)
          query = {}
          search_params.each do |k, v|
            case k.to_s
            when /\A(.*)_([^_]+)\Z/
              method = $1.to_sym

              case $2
              when 'contains'
                query.merge!(method => Regexp.new(Regexp.escape(v), Regexp::IGNORECASE))

              when 'eq'
                query.merge!(method => k.to_i)

              when /\A(lte?|gte?)\Z/
                query.merge!(method.send($1) => k)

              else
                raise "unhandled conditional operator: #{$2}"
              end
            end
          end
          query
        end

      end
    end
  end
end