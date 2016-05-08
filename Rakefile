require 'hoe'
require './lib/slideshow/service/version.rb'

Hoe.spec 'slideshow-service' do

  self.version = SlideshowService::VERSION

  self.summary = 'slideshow-service gem - convert markdown to slide shows'
  self.description = summary

  self.urls    = ['https://github.com/slideshow-s9/slideshow-service']

  self.author  = 'Gerald Bauer'
  self.email   = 'wwwmake@googlegroups.com'
  
  self.extra_deps = [
    ['slideshow-models', '>= 3.1.1'],  ## slideshow markdown converter
    ['sinatra'],
    ['liquid'],
  ]
  
  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 1.9.2'
  }

end
