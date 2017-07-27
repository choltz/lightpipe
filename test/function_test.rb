require 'test_helper'

# Function tests
class FunctionTest < Minitest::Test
  include Lightpipe

  context 'Composition tests' do
    should 'compose multiple functions into one' do
      add_one      = ->(number) { number + 1 }
      multiply_two = ->(number) { number * 2 }
      composition  = Function.compose [add_one, multiply_two]

      assert_equal 4, composition.call(1)
    end

    should 'compose across data types' do
      source            = "This is an <b>example</b> of\n text. it has formatting issues."
      remove_line_feeds = ->(text) { text.gsub(/\n+/, '') }
      remove_markup     = ->(text) { text.gsub(/(<([^>]+)>)/, '') }
      split_sentences   = ->(text) { text.split(/ *\. */) }
      strip             = ->(text) { text.strip }
      capitalize        = ->(text) { text.map(&:capitalize) }
      join              = ->(array) { array.join('. ') }

      composition = Function.compose [strip,
                                      remove_line_feeds,
                                      remove_markup,
                                      split_sentences,
                                      capitalize,
                                      join]

      expected = 'This is an example of text. It has formatting issues'
      assert_equal expected, composition.call(source)
    end

    should 'allow a param list of functions rather than an array of functions' do
      source            = "This is an <b>example</b> of\n text. it has formatting issues."
      remove_line_feeds = ->(text) { text.gsub(/\n+/, '') }
      remove_markup     = ->(text) { text.gsub(/(<([^>]+)>)/, '') }
      split_sentences   = ->(text) { text.split(/ *\. */) }
      strip             = ->(text) { text.strip }
      capitalize        = ->(text) { text.map(&:capitalize) }
      join              = ->(array) { array.join('. ') }

      composition = Function.compose  strip,
                                      remove_line_feeds,
                                      remove_markup,
                                      split_sentences,
                                      capitalize,
                                      join

      expected = 'This is an example of text. It has formatting issues'
      assert_equal expected, composition.call(source)
    end
  end

  context "operator override" do
    should 'override the pipe operator' do
      source              = "This is an <b>example</b> of\n text. it has formatting issues."
      remove_line_feeds = Function.new { |text| text.gsub(/\n+/, '') }
      remove_markup     = Function.new { |text| text.gsub(/(<([^>]+)>)/, '') }
      split_sentences   = Function.new { |text| text.split(/ *\. */) }
      strip             = Function.new { |text| text.strip }
      capitalize        = Function.new { |text| text.map(&:capitalize) }
      join              = Function.new { |array| array.join('. ') }

      composition = strip             |
                    remove_line_feeds |
                    remove_markup     |
                    split_sentences   |
                    capitalize        |
                    join

      expected =  'This is an example of text. It has formatting issues'
      assert_equal expected, composition.call(source)
    end

    should 'compose nested functions' do
      source            = "This is an <b>example</b> of\n text. it has formatting issues."
      remove_line_feeds = Function.new { |text| text.gsub(/\n+/, '') }
      remove_markup     = Function.new { |text| text.gsub(/(<([^>]+)>)/, '') }
      split_sentences   = Function.new { |text| text.split(/ *\. */) }
      capitalize        = Function.new { |text| text.map(&:capitalize) }
      join              = Function.new { |array| array.join('. ') }

      remove_line_feeds_and_markup = remove_line_feeds |
                                     remove_markup
      capitalize_each_sentence     = split_sentences   |
                                     capitalize        |
                                     join

      composition = remove_line_feeds_and_markup |
                    capitalize_each_sentence

      expected = 'This is an example of text. It has formatting issues'
      assert_equal expected, composition.call(source)
    end
  end

end
