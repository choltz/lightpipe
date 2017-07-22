require 'test_helper'

# Function tests
class LibraryTest < Minitest::Test
  include Lightpipe

  context 'Shorthand tests' do
    should 'String libraries' do
      assert_equal '123', String.gsub(/ /, '').call(' 1 2 3 ')
    end
  end

  # class Test
  #   include Lightpipe

  #   function :remove_markup, -> { gsub(/(<([^>]+)>)/, '') }
  #   function :add_one,       -> (x) { x + 1 }

  #   def self.gsub(regex, replacement)
  #     Function.new do |text|
  #       text.gsub(regex, replacement)
  #     end
  #   end
  # end
end
