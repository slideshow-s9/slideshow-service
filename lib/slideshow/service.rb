# encoding: utf-8

######
# NB: use rackup to startup Sinatra service (see config.ru)
#
#  e.g. config.ru:
#   require './boot'
#   run Slideshow::Service


require 'pp'
require 'json'


# 3rd party libs/gems

require 'sinatra/base'
require 'liquid'    ## for (jekyll/github pages-like) templates


require 'slideshow/models'


# our own code

require 'slideshow/service/version'   # let version always go first



module Slideshow
  
class Service < Sinatra::Base


  PUBLIC_FOLDER = "#{SlideshowService.root}/lib/slideshow/service/public"
  VIEWS_FOLDER  = "#{SlideshowService.root}/lib/slideshow/service/views"

  puts "[boot] slideshow-service - setting public folder to: #{PUBLIC_FOLDER}"
  puts "[boot] slideshow-service - setting views folder to: #{VIEWS_FOLDER}"

  set :public_folder, PUBLIC_FOLDER   # set up the static dir (with images/js/css inside)   
  set :views,         VIEWS_FOLDER    # set up the views dir

  set :static, true   # set up static file routing


  ##############################################
  # Controllers / Routing / Request Handlers


  get '/s6' do
    ## todo/check:  works with .html too (e.g. gets hit before public file ?? check why? why not??)
    redirect to('/slideshow-s6-blank/slides') 
  end

  ###
  ##  todo/check - redirect
  ##     /slideshow-s6-blank/i/** to /i/**
  ##  to"i/slideshow.png"


  get '/slideshow-s6-blank/slides' do
  
   text = params.delete('text') || welcome_sample
   ## todo - check if ascii-7bit encoding ??
   ##  use (always) utf8 for now

   render_slideshow( text, 'slideshow-s6-blank/slides.html' )
  end


  get '/slideshow-s6-blank/slides.pdf' do
  
   text = params.delete('text') || welcome_sample
   ## todo - check if ascii-7bit encoding ??
   ##  use (always) utf8 for now

   render_slideshow( text, 'slideshow-s6-blank/slides.pdf.html' )
  end


  get '/slideshow-deck.js/slides' do
  
   text = params.delete('text') || welcome_sample
   ## todo - check if ascii-7bit encoding ??
   ##  use (always) utf8 for now

   render_slideshow( text, 'slideshow-deck.js/slides.html' )
  end
  

  get '/' do
    # note: allow optional params e.g. text and opts
    ##  note: for now only html supported on get form/url params

    text = params.delete('text') || welcome_sample

    @welcome_sample = text

    erb :index
  end


  get '/d*' do
    erb :debug
  end


private

  def welcome_sample
    ## todo: rotate welcome / use random number for index
    # place markdown docs in server/docs
     text = File.read( "#{SlideshowService.root}/lib/slideshow/service/docs/welcome.md" )
     text
  end


  def render_slideshow( text, template_path )

   opts    = Slideshow::Opts.new
   
   ## opts.verbose      = true     # turn on (verbose) debug output
   ## opts.output_path  = "#{Slideshow.root}/tmp/#{Time.now.to_i}"

   config  = Slideshow::Config.new( opts )
   config.load
   config.dump
  
   b = Slideshow::Build.new( config )
   deck = b.create_deck_from_string( text )

   pp deck
 
   puts "content:"
   pp deck.content
 
   ###########################################
   ## setup hash for binding
   assigns = { 'name'    => 'test',    ## todo/check: what name to use???
              'headers' => HeadersDrop.new( b.headers ), 
              'content' => deck.content,
              'slides'  => deck.slides.map { |slide| SlideDrop.new(slide) },  # strutured content - use LiquidDrop - why? why not?
             }
 
  #
  #  html = "<p>hello from s6</p>"
  #  html
  
    ## e.g. :s6 == s6.liquid file/template
  
    tpl = LiquidTemplate.from_public( template_path )
    tpl.render( assigns ) 
  end


  ## use our own litter liquid template handler
  ##   works like "original" in pakman template manager used by slideshow
  
class LiquidTemplate

  def self.from_file( path )
    puts "  Loading template (from file) >#{path}<..."
    text = File.read_utf8( path )     ## use/todo: use read utf8 - why? why not??
    self.new( text, path: path )   ## note: pass along path as an option
  end

  def self.from_public( name )
    path = "#{PUBLIC_FOLDER}/#{name}"
    puts "  Loading template (from builtin public) >#{path}<..."
    self.from_file( path )   ## note: pass along path as an option
  end
  
  def initialize( text, opts={} )
    @template = Liquid::Template.parse( text )   # parses and compiles the template
  end

  def render( hash )
    ## note: hash keys MUST be strings (not symbols) e.g. 'name' => 'Toby'
    ## pp hash
    @template.render( hash )
  end

end # class LiquidTemplate




end # class Service
end #  module Slideshow


# say hello
puts SlideshowService.banner

