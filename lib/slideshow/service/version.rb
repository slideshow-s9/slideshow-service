# encoding: utf-8

module SlideshowService

  MAJOR = 0
  MINOR = 3
  PATCH = 1
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "slideshow-service/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}] " +
    "using slideshow/#{Slideshow::VERSION} " +
    "on Sinatra/#{Sinatra::VERSION} (#{ENV['RACK_ENV']})"
  end

  def self.root
    "#{File.expand_path( File.dirname(File.dirname(File.dirname(File.dirname(__FILE__)))) )}"
  end

end  # module SlideshowService
