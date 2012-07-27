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
          method_id.to_s =~ /_(gte?|lte?|eq|ne|in|contains)\Z/
        end

        def build_query(search_params)
          query = {}
          search_params.each do |key, value|
            case key.to_s
            when /\A(.*)_([^_]+)\Z/
              field, operator = [$1, $2].map!(&:to_sym)

              case operator.to_sym
              when :contains
                query.merge!(field => Regexp.new(Regexp.escape(value), Regexp::IGNORECASE))

              when :eq, :in
                query.merge!(field => value)

              when :lt, :lte, :gt, :gte
                query.merge!(field.send($1) => value)

              else
                raise "Unhandled conditional operator: #{operator}"
              end
            end
          end
          query
        end

      end
    end
  end
end