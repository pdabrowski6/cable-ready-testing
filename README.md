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

## 🎲 Usage

Let's consider the following usage of Cable Ready:

```ruby
class Broadcaster
  include CableReady::Broadcaster

  def call(channel_name, selector)
    cable_ready[channel_name].outer_html(
      selector: selector,
      html: 'html'
    )

    cable_ready.broadcast
  end
end
```

without custom matchers you may end-up with the following test:

```ruby
RSpec.describe Broadcaster do
  subject { described_class.new }

  describe '#call' do
    it 'broadcasts the html' do
      cable_ready = double(outer_html: double)

      expect(CableReady::Channels.instance)
        .to receive(:[])
        .with('custom_channel')
        .and_return(cable_ready)
      expect(cable_ready)
        .to receive(:outer_html)
        .with(selector: '#some-div', html: 'html')
      expect(CableReady::Channels.instance)
        .to receive(:broadcast).once

      subject.call('custom_channel', '#some-div')
    end
  end
end
```

after using `cable-ready-testing` gem:

```ruby
RSpec.describe Broadcaster do
  subject { described_class.new }

  describe '#call' do
    it 'broadcasts the html' do
      expect {
        subject.call('custom_channel', '#some-div')
      }.to mutated_element('#some-div')
       .on_channel('custom_channel')
       .with(:outer_html, { 'html' => 'html' })
    end
  end
end
```
