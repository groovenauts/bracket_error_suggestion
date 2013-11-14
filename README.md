# BracketErrorSuggestion

```
describe BracketErrorSuggestion do
  it "suggests the place where invalid access happens" do
    tree = {foo: { bar: [{baz: "foo"}] }  }

    BracketErrorSuggestion.enable do
      expect{ tree[:foo][:bar][:baz] }.to raise_error(TypeError, "no implicit conversion of Symbol into Integer, it attempted to access <Hash>[:foo][:bar][:baz] but <Hash>[:foo][:bar] is an Array")
      expect{ tree[:foo][:baz][:bar] }.to raise_error(NoMethodError, "undefined method `[]' for nil:NilClass, maybe it attempted to access: <Hash>[:foo][:baz][:bar] but <Hash>[:foo][:baz] is nil")
    end
  end
```

## Installation

Add this line to your application's Gemfile:

    gem 'bracket_error_suggestion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bracket_error_suggestion

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
