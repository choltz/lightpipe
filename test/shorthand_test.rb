require 'test_helper'

# Function tests
class DirectiveTest < Minitest::Test
  include Lightpipe

  context 'Shorthand tests' do
    setup do
      Lightpipe.enable_shorthand
    end

    should 'allow lambdas to be piped' do
      add_two = ->(x) { x + 2 }
      double  = ->(x) { x * 2 }

      assert_equal 8, (add_two | double).call(2)
    end
  end

end
