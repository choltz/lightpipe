require 'test_helper'

# Function tests
class ShorthandTest < Minitest::Test
  include Lightpipe

  context 'Shorthand tests' do
    should "create a function" do
      results = Test.remove_markup.call '<b>test</b>'
    end
  end

  class Test
    include Lightpipe

    function :remove_markup, -> {
      gsub(/(<([^>]+)>)/, '')
    }

    def self.gsub(regex, replacement)
      Function.new do |text|
        text.gsub(regex, replacement)
      end
    end
  end
end
