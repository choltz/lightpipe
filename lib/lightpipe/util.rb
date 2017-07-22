module Lightpipe
  module Util
    # Public: Hook class methods into the included class
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Public: Convert the given method name into a class function
      #
      # Example:
      # class Test
      #   include Lightpipe::Util
      #
      #   delegate_function :gsub
      # end
      #
      # > Test.gsub.call(/_/, '-').call("test_test")
      # => "test-test"
      def delegate_function(name)
        (class << self; self; end).class_eval do
          define_method name do |*args|
            Function.new do |arg|
              arg.send(name, *args)
            end
          end
        end
      end

    end
  end
end
