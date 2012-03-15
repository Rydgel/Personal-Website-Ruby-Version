require "rubygems"
require "sinatra"
require "haml"
require "./filters/numbers.rb"
require "./lib/cache"
require "./lib/utils"

configure do
  set :public_folder, "#{File.dirname(__FILE__)}/static"
  set :haml, { :format => :html5, :ugly => true }
  set :views, "#{File.dirname(__FILE__)}/views"
  
  @last_mod_time = Time.now
end

before do
  headers "X-UA-Compatible" => "IE=Edge,chrome=1"
  expires 300, :public, :must_revalidate
  last_modified(@last_mod_time)
end

get "/" do
  # Main page
  @rss = Utils.getRSS("http://feeds2.feedburner.com/phollow/iuEO")
  @twitter = Utils.getTwitterNbFollowers("phollow")
  @dribbble = Utils.getDribbbleShots("phollow")
  haml :index
end

not_found do
  haml :notfound
end

error do
  haml :error
end