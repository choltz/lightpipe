require 'test_helper'

module Lightpipe
  class ToFunctionTest < Minitest::Test
    include Lightpipe

    # Disclaimer: Monkey patching is bad. But in this case, it provides a lot
    # of power. By adding a to_function method to all objects, we can begin
    # any transformation chain with a value. This is more intuitive than putting
    # the starting value of the transformation at the end of a composition as
    # the argument of a call() method.
    context 'to_function monkey patch tests' do
      should 'convert strings to functions' do
        function = 'this is a test'.to_function | LpString.capitalize

        assert_equal 'This is a test', function.call
      end

      should 'convert arrays to functions' do
        increment = ->(x){ x + 1 }
        function = [1,2,3].to_function |
                   LpArray.map(&increment)

        assert_equal [2,3,4], function.call
      end

      should 'convert hashes to functions' do
        function = { x: { y: 2 } }.to_function |
                   Lightpipe::LpHash.dig(:x, :y)

        assert_equal 2, function.call
      end
    end
  end
end
