# frozen_string_literal: true

require 'yaml'

# Conficuration class to interface with .build.yml
class Configuration
  def initialize(lane_name, yaml)
    @lane_name = lane_name
    @yaml = YAML.load_file(yaml, aliases: true)[lane]
  end

  def build_number
    ENV['BUILD_NUMBER'] || '1'
  end

  def app_scheme
    setting(:app, :scheme)
  end

  def app_output_directory
    setting(:app, :output_directory)
  end

  def app_display_name
    setting(:app, :display_name)
  end

  def scan_devices
    setting(:scan, :devices)
  end

  private

  attr_reader :lane_name, :yaml

  def setting(prefix, key)
    yaml[prefix.to_s][key.to_s]
  end

  def lane
    @lane ||= lane_name.split(' ').last
  end
end
