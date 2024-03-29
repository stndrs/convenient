# frozen_string_literal: true

module Convenient
  # == DataObject ==
  #
  # For making JSON nicer, allowing its values
  # to be accessed like methods. While intended for
  # JSON, it can also be used for regular Hashes
  class DataObject
    # Initialize the object with a JSON document.
    # A parent object can be provided
    #
    # @param [String | Hash] data
    # @param [Convenient::DataObject] parent
    def initialize(data)
      data = data.is_a?(Hash) ? data.to_json : data
      @data = JSON.parse(data, symbolize_names: true)
    end

    # Allow parsed JSON to be accessed normally
    #
    # @param [Symbol] key
    def [](key)
      @data[key]
    end

    # Pretty JSON output
    def to_s
      JSON.pretty_generate(@data)
    end

    # From Stripe: https://github.com/stripe/stripe-ruby/blob/44766516d973f92f1a3f654c38cfb3dd9946db4b/lib/stripe/stripe_object.rb#L124
    #
    # Override the default inspect method to
    # display a pretty version of the DataObject
    def inspect
      "#<#{self.class}:0x#{object_id.to_s(16)}> JSON: " +
        JSON.pretty_generate(@data)
    end

    protected

    # Retruns the data Hash value based on the provided
    # method name, if present.
    # Will return nil if the value is not present in
    # the hash instead of the typical NoMethodError
    #
    # @param [Symbol] name
    def method_missing(method)
      raise NoMethodError, "undefined method `#{method}` for #{self.class.name}:Class" unless respond_to?(method)

      return @data.public_send(method) unless @data.keys.include?(method)

      value = @data[method]
      handle_value(value)
    end

    def respond_to_missing?(symbol, include_private = false)
      @data&.key?(symbol) || @data.respond_to?(symbol) || super
    end

    private

    def handle_value(value)
      case value
      when Hash
        DataObject.new(value)
      when Array
        parse_array(value)
      else
        value
      end
    end

    # Map array values
    # For each member of the array, handle_value is
    # called so that Hashes are turned into nested DataObject
    # objects, while arrays are recursively parsed, and other
    # values are returned unchanged
    def parse_array(values)
      values.map { |value| handle_value(value) }
    end
  end
end
