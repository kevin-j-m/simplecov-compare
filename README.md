# Simplecov::Compare

Simplecov's coverage report will tell the coverage of an application at a moment
of time. You may want to track differences over time though. This provides a
mechanism to compare two Simplecov results.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add simplecov-compare
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install simplecov-compare
```

## Usage

### Command Line

Given an earlier coverage JSON output named `path/to/before.json` and a later
report named `path/to/after.json`, you can run:

```sh
simplecov-compare path/to/before.json path/to/after.json
```
### In Ruby

Given an earlier coverage JSON output named `path/to/before.json` and a later
report named `path/to/after.json`, you can run:

```ruby
Simplecov::Compare.report(
  base_path: "path/to/before.json",
  to_path: "path/to/after.json",
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kevin-j-m/simplecov-compare. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kevin-j-m/simplecov-compare/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Simplecov::Compare project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kevin-j-m]/simplecov-compare/blob/main/CODE_OF_CONDUCT.md).
