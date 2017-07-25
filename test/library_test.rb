require 'test_helper'

# Function tests
class LibraryTest < Minitest::Test
  include Lightpipe

  context 'Shorthand tests' do
    should 'String libraries' do
      assert_equal '123', String.gsub(/ /, '').call(' 1 2 3 ')
    end

    should 'remove markup from a string' do
      assert_equal 'this is a test.', String.remove_markup_tags.call('this is a <b>test</b>.')
    end

    should 'remove leading and trailing spaces' do
      assert_equal 'test', String.strip.call('  test  ')
    end

    should 'capitalize all words' do
      assert_equal 'This Is A Test.', String.capitalize_all.call('this is a test.')
    end

    should 'remove linefeeds' do
      assert_equal 'this is a test.', String.remove_line_feeds.call("this is a\n test.")
    end

    should 'split text into an array for each sentence' do
      text     = 'Sentence one. Sentence two. Sentence three.'
      expected = ['Sentence one', 'Sentence two', 'Sentence three' ]

      assert_equal expected, String.split_sentences.call(text)
    end

    should 'compose multiple functions' do
      text     = '  this is a <b>test</b>.   '
      expected = 'This Is A Test.'

      results = String.strip              |
                String.remove_markup_tags |
                String.capitalize_all

      assert_equal expected, results.call(text)
    end
  end
end
