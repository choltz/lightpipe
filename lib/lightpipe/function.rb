module Lightpipe
  # Public: Hook class methods into the included class
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Public: If desired, call this to monkey-patch Proc to allow composition of
  # ruby lambdas, procs, blocks
  #
  # Notes: If you are loading this into a rails app, add
  # Lightpipe.enabler_shorthand to your config/application.rb file:
  def self.enable_shorthand
    Proc.include Composition
  end

  module ClassMethods
    # public: shorthand for defining functions as class methods.
    #
    # name - name of function to define
    # proc - executable content of the function
    #
    # example:
    # class test
    #   include lightpipe
    #
    #   function :remove_markup, gsub(/(<([^>]+)>)/, '')
    #
    #   def self.gsub(regex, replacement)
    #     function.new do |text|
    #       text.gsub(regex, replacement)
    #     end
    #   end
    # end
    #
    # test.remove_markup.call '<b>test</b>'
    # => 'test'
    def function(name, proc)
      raise 'a function must be define as a proc/lambda' unless proc.is_a?(Proc)

      # dynamically add a method that calls the proc to the class.
      (class << self; self; end).class_eval do
        define_method name do
          proc
        end
      end
    end
  end

  # Public: This is an extension of the Proc class that adds functional
  # composition capabilities
  class Function < Proc
    include Composition
  end
end
