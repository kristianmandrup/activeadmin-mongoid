module ActiveAdmin
  module Mongoid
    module Adaptor
      class Search
        attr_reader :base, :query, :query_hash, :search_params

        def initialize(object, search_params = {})
          @base = object
          @query = @base.where(build_query(search_params))
        end

        def respond_to?(method_id)
          @query.send(:respond_to?, method_id)
        end

        def method_missing(method_id, *args, &block)
          if is_query(method_id)
            @search_params[method_id.to_s]
          else
            @query.send(method_id, *args, &block)
          end
        end

        private

        def available_methods
          %w(gte lte gt lt eq ne contains)
        end

        def build_query(search_params)
          query = {}
          search_params.each do |k, v|
            case k.to_s
            when /\A(.*)_([^_]+)\Z/
              method = $1.to_sym

              case $2
              when 'contains'
                query.merge!(method => Regexp.new(Regexp.escape("#{value}"), Regexp::IGNORECASE))

              when /\A(lte?|gte?|eq)\Z/
                query.merge!(method.send($1) => value)

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