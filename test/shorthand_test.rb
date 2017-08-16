require 'test_helper'

# Function tests
class ShorthandTest < Minitest::Test
  include Lightpipe

  context 'Shorthand tests' do
    should "create a function" do
      results = Test.remove_markup.call '<b>test</b>'
      assert_equal 'test', results
    end

    should "create a function with a parameter" do
      results = Test.add_one.call 1
      assert_equal 2, results
    end

    should "not allow a non-proc function definition" do
      assert_raises RuntimeError do
        Test.function :test, nil
      end
    end
  end

  class Test
    include Lightpipe

    function :remove_markup, LpString.gsub(/(<([^>]+)>)/, '')
    function :add_one,       Function.new { |x| x + 1 } # -> (x) { x + 1 }

    def self.gsub(regex, replacement)
      Function.new do |text|
        text.gsub(regex, replacement)
      end
    end
  end
end
