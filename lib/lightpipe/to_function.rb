# Disclaimer: Monkey patching is bad. But in this case, it provides a lot
# of power. By adding a to_function method to all objects, we can begin
# any transformation chain with a value. This can be  more intuitive than
# putting the starting value of the transformation at the end of a composition
# as the argument of a call() method.

class Object
  # Public: Returns a function that returns the object
  #
  # Example:
  # function = 'test'.to_function
  # function.call
  # => 'test'
  #
  # function = 'test value'.to_function |
  #            LpArray.split(/ /)       |
  #            LpArray.map(&LpString.capitalize)
  # function.call
  # => 'Test Value'
  #
  # If you are using ActiveRecord, to_function can be used to chain
  # the AR relation with other functions.
  #
  # function = User.where('condition > 1).to_function |
  #            LpArray.map{ |u| "#{u.first} #{u.last}"} |
  #            LpArray.map(&LpString.downcase)
  #
  def to_function
    Lightpipe::Function.new { self }
  end
end
