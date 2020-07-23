require "spec_helper"

RSpec.describe "mutated_element matchers" do
  let(:channel) do
    Class.new(ActionCable::Channel::Base) do
      def self.channel_name
        "broadcast"
      end
    end
  end

  def broadcast(stream, selector, html)
    cable_ready = CableReady::Channels.instance
    cable_ready[stream].outer_html(
      selector: selector,
      html: html
    )

    cable_ready.broadcast
  end

  before do
    server = ActionCable.server
    test_adapter = ActionCable::SubscriptionAdapter::Test.new(server)
    server.instance_variable_set(:@pubsub, test_adapter)
  end

  describe 'mutated_element' do
    it 'passes' do
      expect {
        broadcast('broadcast', '#content', 'some html')
      }.to mutated_element('#content')
       .on_channel('broadcast')
       .with(:outer_html, { 'html' => 'some html' })
    end

    it 'fails when channel is not specified' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content')
      }.to raise_error(ArgumentError, 'Please specify the channel using .on_channel')
    end

    it 'fails when mutation is not specified' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content')
         .on_channel('broadcast')
      }.to raise_error(ArgumentError, 'Please specify the type of element mutation using .with(type_of_mutation, options)')
    end

    it 'fails when no messages are found on specified channel' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content')
         .on_channel('broadcast2')
         .with(:outer_html, { 'html' => 'some html' })
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected to mutate element `#content` on channel broadcast2 but no broadcasted messages were found')
    end

    it 'fails when options broadcasted to the channel are not matching' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content')
         .on_channel('broadcast')
         .with(:outer_html, { 'html' => 'html' })
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected to mutate element `#content` on channel broadcast with {"html"=>"html"} but mutated element with {"html"=>"some html"}')
    end

    it 'fails when given mutation is not found' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content')
         .on_channel('broadcast')
         .with(:inner_html, { 'html' => 'some html' })
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected to mutate element `#content` on channel broadcast but no broadcasted messages with this mutation were found')
    end

    it 'fails when mutated element is not found' do
      expect {
        expect {
          broadcast('broadcast', '#content', 'some html')
        }.to mutated_element('#content1')
         .on_channel('broadcast')
         .with(:outer_html, { 'html' => 'some html' })
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError, 'expected to mutate element `#content1` on channel broadcast but message for given element was not found')
    end
  end
end
