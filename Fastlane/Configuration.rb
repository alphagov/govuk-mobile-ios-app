require 'yaml'

class Configuration

  attr_reader :build_number
  attr_reader :app_scheme, :app_output_directory, :app_display_name
  attr_reader :scan_devices

  def initialize(lane_name, yaml)
    @lane_name = lane_name
    @yaml = YAML.load(yaml)[lane]
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
  def setting(prefix, key)
    puts("------")
    puts(prefix)
    puts(lane)
    puts(@yaml)
    puts("------")
    @yaml[prefix.to_s][key.to_s]
  end

  def lane
    @lane ||= @lane_name.split(' ').last
  end

end
