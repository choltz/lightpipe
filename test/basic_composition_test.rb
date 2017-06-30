require 'test_helper'

class BasicCompositionTest < Minitest::Test
  context "Basic Composition Tests" do
    should "compose with vanilla ruby lambdas" do
      add_one      = ->(number) { number + 1 }
      multiply_two = ->(number) { number * 2 }

      # compositon calls one function and passes the result into the next
      composition  = multiply_two.call(add_one.call(1))

      assert_equal 4, composition
    end

    should "compose map functions with vanilla ruby lambdas" do
      numbers     = [1,2,3,4]
      increment   = ->(array) { array.map{ |i| i + 1 } }
      string      = ->(array) { array.map(&:to_s) }

      # compositon that passes array values
      composition = string.call(increment.call(numbers))

      assert_equal ['2', '3', '4', '5'], composition
    end

    should "compose across data types" do
      data       = ['key1', '1', 'key2', '2']
      to_hash    = ->(array) { Hash[*data] }
      key_to_sym = ->(hash)  { hash.reduce({}) { |hash, (key, value)| hash.merge(key.to_sym => value) } }
      val_to_num = ->(hash)  { hash.reduce({}) { |hash, (key, value)| hash.merge(key => value.to_i) } }

      # compostion can receive one data type and return another, so long as the
      # results of the first call match the expected type of the parameter of
      # second call.
      composition = val_to_num.call(
        key_to_sym.call(
          to_hash.call(data)
        )
      )

      expected = { key1: 1, key2: 2}
      assert_equal expected, composition
    end
  end
end
