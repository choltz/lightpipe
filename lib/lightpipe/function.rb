module Lightpipe
  # Public: This is an extension of the Proc class that adds functional
  # composition capabilities
  class Function < Proc
    attr_accessor :context

    def initialize
      # Calculate the function's display name in a console
      if caller_name =~ /\.rb/
        class_name    = camelize(caller_name)
        function_name = caller_name.match(/(?<=`)[^']+/)
        @context      = "#{class_name}.#{function_name}"
      else
        @context      = 'anonymous'
      end
    end

    # Public: used for display purposes in places like irb and pry
    def inspect
      "#<Function context: \"#{@context}\">"
    end

    # Public: Override the pipe operator to simplify functional composition
    #
    # function - function to compose with the current function
    #
    # Examples
    #
    # > functions = strip_string | remove_markup | capitalize
    # > functions.call("  <b>this is a test</b>  ")
    # => "This is a test"
    #
    # Returns a composition of the two functions
    def |(other)
      Function.compose(self, other)
    end

    #
    # Class methods
    #

    # Public: build a composition of functions.
    #
    # functions - either an array of functions or a parameter list of functions
    #
    # Notes: The functions provided can be any class that has a call method
    #
    # Returns an instance of this class whose call method invokes the chain
    # of functions provided
    def self.compose(*functions)
      new do |arg|
        [functions].flatten.reduce(arg) do |result, function|
          function.call(result)
        end
      end
    end

    private

    # Internal: Extract the file path and function for function name inspection
    def caller_name
      caller(3..3).first
    end

    # Internal: Convert snake-case text to camelcase
    def camelize(text)
      text.match(%r{[^\/]+(?=\.rb)})
          .to_s
          .split('_')
          .map(&:capitalize)
          .join
    end
  end
end
