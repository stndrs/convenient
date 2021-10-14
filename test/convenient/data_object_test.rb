# frozen_string_literal: true

require 'test_helper'

module Convenient
  class DataObjecTest < Minitest::Test
    def setup
      @json = {
        key1: 'value1',
        array: [{ key2: 'value2' }],
        nested: {
          key3: 'value3'
        }
      }
      @obj = DataObject.new(@json.to_json)
    end

    def test_it_returns_nil_if_value_is_nil
      @json[:null_key] = nil
      obj = DataObject.new(@json)

      assert_nil obj.null_key
    end

    def test_it_reponds_like_a_hash
      Hash.methods.each do |method|
        @obj.respond_to?(method)
      end
    end

    def test_it_raises_an_error
      assert_raises ArgumentError do
        DataObject.new
      end
    end

    def test_it_initializes
      refute_nil @obj
    end

    def test_it_responds_to_keys
      @json.each_key do |key|
        assert @obj.respond_to?(key)
      end
    end

    def test_it_returns_a_value
      assert_equal @obj.key1, @json[:key1]
    end

    def test_it_returns_a_nested_object
      assert_instance_of DataObject, @obj.nested
      assert_equal @obj.nested.key3, @json[:nested][:key3]
    end

    def test_it_returns_an_array
      assert_instance_of Array, @obj.array
    end

    def test_it_returns_an_array_of_objects
      assert_instance_of DataObject, @obj.array.first
      assert_equal @obj.array.first.key2, @json[:array].first[:key2]
    end

    def test_it_allows_hash_access
      assert_equal @obj[:key1], @json[:key1]
    end

    def test_it_prints
      @json.each_key do |key|
        assert @obj.to_s.include?(key.to_s)
      end
    end

    def test_it_is_inspectable
      @json.each_key do |key|
        assert @obj.inspect.include?(key.to_s)
      end

      object_name = "#{@obj.class}:0x#{@obj.object_id.to_s(16)}"
      assert @obj.inspect.include?(object_name)
    end
  end
end
