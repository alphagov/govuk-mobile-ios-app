# frozen_string_literal: true

require 'yaml'

# Configuration class to interface with .build.yml
class Configuration
  def initialize(lane_name, yaml)
    @lane_name = lane_name
    @yaml = YAML.load_file(yaml, aliases: true)[lane]
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

  def app_project
    setting(:app, :project)
  end

  def app_bundle_identifier
    setting(:app, :bundle_identifier)
  end

  def app_args
    [
      '-allowProvisioningUpdates'
    ].join(' ')
  end

  def app_configuration
    setting(:app, :build_configuration)
  end

  def app_export_method
    setting(:app, :export_method)
  end

  def app_export_options
    {
      provisioningProfiles: app_profile_specifiers
    }
  end

  def scan_devices
    setting(:scan, :devices)
  end

  def scan_output_directory
    setting(:scan, :output_directory)
  end

  def deliver_key_id
    ENV['APP_STORE_KEY_ID']
  end

  def deliver_key_issuer_id
    ENV['APP_STORE_KEY_ISSUER_ID']
  end

  def deliver_key_content
    ENV['APP_STORE_KEY_CONTENT']
  end

  def deliver_groups
    setting(:deliver, :groups)
  end

  def match_method
    setting(:match, :method)
  end

  def match_identifiers
    app_bundle_identifier
  end

  def match_certificate_token
    ENV['MATCH_CERTIFICATE_TOKEN']
  end

  def firebase_app_id
    setting(:app, :firebase_app_id)
  end

  def firebase_token
    ENV['FIREBASE_TOKEN']
  end

  private

  attr_reader :lane_name, :yaml

  def app_profile_specifiers
    setting(:app, :profile_specifiers)
  end

  def setting(prefix, key)
    yaml[prefix.to_s][key.to_s]
  end

  def lane
    @lane ||= lane_name.split(' ').last
  end
end
