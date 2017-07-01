require 'test_helper'

class FunctionTest < Minitest::Test
  context "Composition tests" do
    should "compose multiple functions into one" do
      add_one      = ->(number) { number + 1 }
      multiply_two = ->(number) { number * 2 }
      functions    = [add_one, multiply_two]

      composition = Lightpipe::Function.compose functions

      assert_equal 4, composition.call(1)
    end
  end
end
