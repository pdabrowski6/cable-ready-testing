# frozen_string_literal: true

require 'rspec/rails/matchers/cable_ready/mutated_element'

module RSpec
  module Rails
    module Matchers
      # Namespace for various implementations of CableReady features
      #
      # @api private
      module CableReady
      end

      # @api public
      # Passes if a message has been sent to a stream/object inside a block.
      # To specify channel from which message has been broadcasted to object use `on_channel`.
      #
      #
      # @example
      #     expect {
      #       cable_ready['channel'].outer_html(
      #         selector: '#content',
      #         html: 'some html'
      #       )
      #
      #       cable_ready.broadcast
      #     }.to mutated_element('#content')
      #      .on_channel('channel')
      #      .with(:outer_html, { 'html' => 'some html' })
      #
      #

      def mutated_element(target = nil)
        CableReady::MutatedElement.new(target)
      end

      %i[mutated_attribute mutated_css_class mutated_dataset mutated_style].each do |alt_method|
        alias_method alt_method, :mutated_element
      end
    end
  end
end
