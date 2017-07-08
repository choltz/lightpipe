module Lightpipe
  class Function < Proc
    attr_accessor :context

    def initialize
      caller_function = caller[1]

      # Calculate the function's display name in a console
      if caller_function =~ /\.rb/
        class_name    = caller[1].match(/[^\/]+(?=\.rb)/).to_s.capitalize
        function_name = caller[1].match(/(?<=`)[^']+/)
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
    def |(function)
      Function.compose(self, function)
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
      self.new do |arg|
        [functions].flatten.reduce(arg) do |result, function|
          function.call(result)
        end
      end
    end

  end
end
