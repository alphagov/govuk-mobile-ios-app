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

  def app_project
    setting(:app, :project)
  end

  def app_bundle_identifier
    setting(:app, :bundle_identifier)
  end

  def app_bundle_identifier_notification_service
    "#{app_bundle_identifier}.notification-service"
  end

  def app_base_url
    ENV['BASE_URL']
  end

  def app_assetcatalog_compiler_appicon_name
    ENV['ASSETCATALOG_COMPILER_APPICON_NAME']
  end

  def app_authentication_base_url
    ENV['AUTHENTICATION_BASE_URL']
  end

  def app_authentication_client_id
    ENV['AUTHENTICATION_CLIENT_ID']
  end

  def app_chat_base_url
    ENV['CHAT_BASE_URL']
  end

  def app_token_base_url
    ENV['TOKEN_BASE_URL']
  end

  def app_onesignal_app_id
    ENV['ONESIGNAL_APP_ID']
  end

  def app_google_services_file
    ENV['GOOGLE_SERVICES_FILE']
  end

  def app_additional_swift_flags
    setting(:app, :additional_swift_flags)
  end

  def app_args
    [
      "BASE_URL=\"#{app_base_url}\"",
      "ONESIGNAL_APP_ID=\"#{app_onesignal_app_id}\"",
      "ASSETCATALOG_COMPILER_APPICON_NAME=\"#{app_assetcatalog_compiler_appicon_name}\"",
      "AUTHENTICATION_BASE_URL=\"#{app_authentication_base_url}\"",
      "AUTHENTICATION_CLIENT_ID=\"#{app_authentication_client_id}\"",
      "CHAT_BASE_URL=\"#{app_chat_base_url}\"",
      "TOKEN_BASE_URL=\"#{app_token_base_url}\"",
      "GOOGLE_SERVICES_FILE=\"#{app_google_services_file}\"",
      "PRODUCT_BUNDLE_IDENTIFIER_APP=\"#{app_bundle_identifier}\"",
      "PRODUCT_BUNDLE_IDENTIFIER_NOTIFICATION_SERVICE=\"#{app_bundle_identifier_notification_service}\"",
      "PROFILE_SPECIFIER_APP=\"#{app_profile_specifiers[app_bundle_identifier]}\"",
      "PROFILE_SPECIFIER_NOTIFICATION_SERVICE=\"#{app_profile_specifiers[app_bundle_identifier_notification_service]}\"",
      "CODE_SIGN_ENTITLEMENTS_APP=\"#{app_entitlements[app_bundle_identifier]}\"",
      "CODE_SIGN_ENTITLEMENTS_NOTIFICATION_SERVICE=\"#{app_entitlements[app_bundle_identifier_notification_service]}\"",
      "ADDITIONAL_SWIFT_FLAGS=\"#{app_additional_swift_flags.join(' ')}\"",
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
    [
      app_bundle_identifier,
      app_bundle_identifier_notification_service
    ]
  end

  def match_certificate_token
    ENV['MATCH_CERTIFICATE_TOKEN']
  end

  def firebase_app_id
    ENV['FIREBASE_APP_ID']
  end

  def firebase_token
    ENV['FIREBASE_TOKEN']
  end

  def release_notes_file
    "release_notes.txt"
  end

  private

  attr_reader :lane_name, :yaml

  def app_profile_specifiers
    setting(:app, :profile_specifiers)
  end

  def app_entitlements
    setting(:app, :entitlements)
  end

  def setting(prefix, key)
    yaml[prefix.to_s][key.to_s]
  end

  def lane
    @lane ||= lane_name.split(' ').last
  end
end
