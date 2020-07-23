# frozen_string_literal: true

module RSpec
  module Rails
    module Matchers
      module CableReady
        # @private
        class MutatedElement < RSpec::Matchers::BuiltIn::BaseMatcher
          def initialize(target)
            @target = target
            @channel_not_found = false
            @mutation_not_found = false
            @element_not_found = false
          end

          def with(action, data = {}, &block)
            @data = data
            @action = action.to_s.camelize(:lower)
            @data = @data.with_indifferent_access if @data.is_a?(Hash)
            @data = @data.transform_keys { |key| key.camelize(:lower) }
            @block = block if block_given?
            self
          end

          def on_channel(channel_name)
            @channel_name = channel_name
            self
          end

          def matches?(proc)
            verify_channel_name_presence
            verify_action_presence

            proc.call

            if (options = mutation_options)
              @message_data = mutated_element_options(options)

              if @message_data.present?
                @message_data.except('selector') == @data
              else
                @element_not_found = true
                false
              end
            elsif broadcasted_message.blank?
              @channel_not_found = true
              false
            else
              @mutation_not_found = true
              false
            end
          end

          def supports_block_expectations?
            true
          end

          def failure_message
            if @channel_not_found
              "#{base_failure_message} but no broadcasted messages were found"
            elsif @mutation_not_found
              "#{base_failure_message} but no broadcasted messages with this mutation were found"
            elsif @element_not_found
              "#{base_failure_message} but message for given element was not found"
            else
              "#{base_failure_message} with #{@data} but mutated element with #{@message_data.except('selector')}"
            end
          end

          private

          def mutation_options
            return unless broadcasted_message

            broadcasted_message.dig('operations', @action)
          end

          def broadcasted_message
            message = pubsub_adapter.broadcasts(@channel_name).first
            return unless message

            decoded = ActiveSupport::JSON.decode(message)
            decoded.with_indifferent_access if decoded.is_a?(Hash)
          end

          def verify_action_presence
            return if @action.present?

            message = 'Please specify the type of element mutation using .with(type_of_mutation, options)'
            raise ArgumentError, message
          end

          def verify_channel_name_presence
            return if @channel_name.present?

            message = 'Please specify the channel using .on_channel'
            raise ArgumentError, message
          end

          def base_failure_message
            "expected to mutate element `#{@target}` on channel #{@channel_name}"
          end

          def pubsub_adapter
            ::ActionCable.server.pubsub
          end

          def mutated_element_options(values)
            values.flatten.find { |el| el['selector'] == @target }
          end
        end
      end
    end
  end
end
