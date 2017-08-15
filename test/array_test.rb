require 'test_helper'

module Lightpipe
  class ArrayTest < Minitest::Test
    include Lightpipe

    context 'Spot check Array function tests' do
      should 'map over elements of the array' do
        results = Lightpipe::LpArray.map(&:to_s).call([1,2,3])

        assert_equal ['1', '2', '3'], results
      end

      should 'select elements of the array' do
        results = Lightpipe::LpArray.select{ |i| i >= 2 }.call([1, 2, 3])

        assert_equal [2, 3], results
      end

      should 'get the first element in the array' do
        results = Lightpipe::LpArray.first.call([1, 2, 3])

        assert_equal 1, results
      end

      should 'compose multiple functions' do
        function = Lightpipe::LpArray.select{ |i| i > 1 } |
                   Lightpipe::LpArray.reverse             |
                   Lightpipe::LpArray.map(&:to_s)         |
                   Lightpipe::LpArray.first

        assert_equal '3', function.call([1,2,3])
      end
    end
  end
end
