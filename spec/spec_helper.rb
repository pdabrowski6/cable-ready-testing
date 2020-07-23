# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "cable_ready"
require "action_controller/railtie"
require "action_view/railtie"
require "action_cable"

require "cable_ready/testing/rspec"

# Set test adapter and logger
ActionCable.server.config.cable = { "adapter" => "test" }
ActionCable.server.config.logger =
  ActiveSupport::TaggedLogging.new ActiveSupport::Logger.new(StringIO.new)
