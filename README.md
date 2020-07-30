> CableReady helps you create great real-time user experiences by making it simple to trigger client-side DOM changes from server-side Ruby.

This gem makes the testing of your broadcast classes easier by providing custom matchers that will verify that the expected message was broadcasted to the expected channel.

## 📚 Docs

- [Cable Ready official Documentation](https://cableready.stimulusreflex.com)
- [Instruction how to install Cable Ready on a Rails application](https://pdabrowski.com/articles/cable-ready-with-action-cable)

## 🚀 Install

Open `Gemfile` and add the following line to the `test` group:

```sh
group :test do
  gem 'cable-ready-testing'
end
```

now load the library for RSpec by editing the file `spec/rails_helper.rb` and loading the gem after initializing the environment with the following line:

```ruby
require 'cable_ready/testing/rspec'
```

you are now ready to use the matchers inside your RSpec tests.
