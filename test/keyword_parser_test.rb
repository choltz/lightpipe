require 'test_helper'

class BasicCompositionTest < Minitest::Test
  context "Crude text parser test" do
    should "process chained function aliases" do
      results = KeyWords.parse.call "very very long"
      assert_equal [['very', 2], ['long', 1]], results
    end

    should "process more chained function aliases" do
      results = KeyWords.parse.call "one two two three three three"
      assert_equal [['three', 3], ['two', 2], ['one', 1]], results
    end
  end

  class KeyWords
    include Lightpipe

    function :extract_words,      LpString.split(/\s+/)
    function :remove_apostrophes, LpString.gsub(/\'ll|n\'t|\'s/, '')
    function :remove_small_words, LpArray.select{ |word| word.length > 2 }
    function :sort_descending,    LpArray.sort{ |a,b| b[1] <=> a[1] }
    function :word_counts,        LpArray.group_by{ |word| word } |
                                  LpArray.map{ |word, list| [word, list.length] }

    def self.parse
      remove_apostrophes |
      extract_words      |
      remove_small_words |
      word_counts        |
      sort_descending
    end
  end

end
