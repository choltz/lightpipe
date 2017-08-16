module Lightpipe
  class LpString
    include Lightpipe
    include Lightpipe::Util

    # Create a function for all String methods: gsub, strip, etc.
    delegate_all_to_functions ::String

    # Capitalize all words in the given string
    function :capitalize_all, LpString.split(/\s+/)     |
                              LpArray.map(&:capitalize) |
                              LpArray.join(' ')

    function :split_sentences,    split(/ *\. */)
    function :remove_line_feeds,  gsub(/\n+/, '')
    function :remove_markup_tags, gsub(/(<([^>]+)>)/, '')
  end
end
