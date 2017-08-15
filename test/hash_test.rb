require 'test_helper'

module Lightpipe
  class LpHashTest < Minitest::Test
    include Lightpipe

    context 'Spot check LpHash function tests' do
      should 'return the hash keys' do
        hash    = { one: 1, two: 2, three: 3 }
        results = Lightpipe::LpHash.keys.call hash

        assert_equal [:one, :two, :three], results
      end

      should 'return the hash values' do
        hash    = { one: 1, two: 2, three: 3 }
        results = Lightpipe::LpHash.values.call hash

        assert_equal [1, 2, 3], results
      end

      should 'map across key value pairs' do
        hash    = { one: 1, two: 2, three: 3 }
        results = Lightpipe::LpHash.map{ |k,v| v + 1 }.call hash

        assert_equal [2, 3, 4], results
      end

      should 'compose multiple functions' do
        function = Lightpipe::LpHash.merge({ three: 3 }) |
                   Lightpipe::LpHash.invert              |
                   Lightpipe::LpHash.count

        assert_equal 3, function.call({ one: 1, two: 2 })
      end
    end
  end
end
