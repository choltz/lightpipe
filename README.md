# Lightpipe

Lightpipe is a functional composition library for Ruby - it is inspired by Elixir's pipe operator. It takes the output from the function on the left and passes it as a parameter to the function on the right. Convenience functions are included to help make functional code readable to compact.


Example
-------
This is admittedly a very crude keyword parser, but it should convey how the Lightpipe can be used

```ruby
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

KeyWords.parse.call "very verly long text from which you want to get keywords"
```
In this example, the `function` directive is used to define a function and make it available as a class method. It is loosely analogous to ActiveRecord scopes, in that it allows for the creation of small and often reusable code blocks that can float to the top of a class definition.

The parse function composes the functions defined at the top of the class by chaining the results of one into the parameters of the next.

Lightpipe functions are a subclass of the Ruby Proc object, so it can be applied in similar ways. Using the above parse function, we can extract keywords form an array of paragraphs.
```ruby
  array_of_paragraphs.map(&KeyWords.parse)
```

Like Proc objects, Lightpipe functions can be called with shortened syntax:
```ruby
  KeyWords.parse.(text_to_parse)
```

Notice that calling `Keyword.parse` does not parse the text, it returns a function that parses text. In this way, function compositions have deferred execution - the only run when their call method is invoked.


A slightly more advanced example
```ruby
def get_external_project
  get_credentials  |
  configure        |
  get_raw_projects |
  map(&new_project)
end

def configure
  Function.new do |token|
    ::ExternalApi.configure do |config|
      config.endpoint       = 'https://test-api/v1'
      config.private_token  = token
    end
  end
end

def get_credentials
  Function.new
    Rails.application.secrets.external_token
  end
end

def get_raw_projects
  Function.new |external_api|
    external_api.projects page: 1, per_page: 100
  end
end

def map(&block)
  Function.new do |array|
    array.map(&block)
  end
end

def new_project
  Function.new do |project_data|
    Openstruct.new name:  project_data[:name],
                   owner: "#{project_data[:first_name]} project_data[:last_name]}"
  end
end
```

Lightpipe is a subclass of the Ruby Proc object. It adds functional composition capabilities and an operator override to make that composition short and readable. Functions can be defined in methods or created anonymously. Because function composition can be nested (compositions can contain compositions) a high degree of re-usability can be achieved.

Considerations
--------
Anonymous functions
Functional composition
Library of convenience functions
Private functions



Lightpipe is a functional composition library for Ruby. With it, you can create customizable functions that chain together into increasingly complex logic. Here are a few examples:

```

```



Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/lightpipe`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lightpipe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lightpipe

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lightpipe.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
