# frozen_string_literal: true

module RubyEventStore
  class TransformKeys
    def self.stringify(data)
      transform(data) {|k| k.to_s}
    end

    def self.symbolize(data)
      transform(data) {|k| k.to_sym}
    end

    private
    def self.transform(data, &block)
      data.each_with_object({}) do |(k, v), h|
        h[yield(k)] = case v
          when Hash
            transform(v, &block)
          when Array
            v.map{|i| Hash === i ? transform(i, &block) : i}
          else
            v
        end
      end
    end
  end
end
