module Lightpipe
  class Function < Proc
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
  end
end
