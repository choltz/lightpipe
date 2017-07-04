require 'test_helper'

class FunctionTest < Minitest::Test
  include Lightpipe

  context "Composition tests" do
    should "compose multiple functions into one" do
      add_one      = ->(number) { number + 1 }
      multiply_two = ->(number) { number * 2 }
      composition  = Function.compose [add_one, multiply_two]

      assert_equal 4, composition.call(1)
    end

    should "compose across data types" do
      text    = "This is an <b>example</b> of\n text. it has formatting issues."
      remove_line_feeds = ->(text) { text.gsub(/\n+/, '') }
      remove_markup     = ->(text) { text.gsub(/(<([^>]+)>)/, '') }
      split_sentences   = ->(text) { text.split(/ *\. */) }
      strip             = ->(text) { text.strip }
      capitalize        = ->(text) { text.map(&:capitalize) }
      join              = ->(array) { array.join('. ') }

      composition = Function.compose [ strip,
                                       remove_line_feeds,
                                       remove_markup,
                                       split_sentences,
                                       capitalize,
                                       join ]

      assert_equal "This is an example of text. It has formatting issues", composition.call(text)
    end
  end
end
