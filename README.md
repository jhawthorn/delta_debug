# DeltaDebug

This implements Andreas Zeller's Delta Debugging ddmin algorithm, which aims to take a failing test input and reduce it to a smaller failing input.

See [Simplifying and Isolating Failure-Inducing Input](https://www.st.cs.uni-saarland.de/papers/tse2002/tse2002.pdf) (PDF) and [Why Programs Fail](https://www.whyprogramsfail.com/).

## Usage

To run, we need to provide a test harness to tell the algorithm the test result of the generated reduced inputs.

Unlike some implementations, **the test harness should return `true` for
"interesting" results** usually this means returning `true` for a failing test.
`nil` (indeterminate) and `false` (passing) should be returned for other
inputs.

For example, if we had a buggy HTML parser which crashed on any `SELECT` tag, we could discover this starting from a larger HTML input.

``` ruby
require "delta_debug"

input = '<SELECT NAME="priority" MULTIPLE SIZE=7>'
harness = -> (html) do
  # Here's where we would test some "real" problem
  if html =~ /<SELECT.*>/
    puts "found failure: #{html.dump}"
    true
  else
    false
  end
end

result = DeltaDebug.new(harness).ddmin(input)
p result
```

```
$ be ruby examples/html_select.rb
found failure: "<SELECT NAME=\"priority\" MULTIPLE SIZE=7>"
found failure: "<SELECT NAty\" MULTIPLE SIZE=7>"
found failure: "<SELECT NALE SIZE=7>"
found failure: "<SELECT NAZE=7>"
found failure: "<SELECT N=7>"
found failure: "<SELECT 7>"
found failure: "<SELECT7>"
found failure: "<SELECT>"
"<SELECT>"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jhawthorn/delta_debug. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/jhawthorn/delta_debug/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DeltaDebug project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jhawthorn/delta_debug/blob/main/CODE_OF_CONDUCT.md).
