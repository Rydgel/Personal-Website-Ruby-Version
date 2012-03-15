require "rubygems"
require "feedzirra"
require "open-uri"
require "yajl"

module Utils
  
  def Utils.getRSS(blog_rss)
    # We take all the RSS entries and we put them in memcache for 1 hour
    cache(3600, 'rss') do
      begin
        Feedzirra::Feed.fetch_and_parse(blog_rss).entries.first(5)
      rescue Exception => e
        print e
        nil
      end
    end
  end

  def Utils.getTwitterNbFollowers(username)
    # Retrieve the number of followers, then put it in the damn cache bitch
    cache(600, 'twitter') do
      begin
        url = "https://api.twitter.com/1/users/show.json?screen_name=" + username
        json = open(url).read
        Yajl::Parser.parse(json)['followers_count']
      rescue Exception => e
        print e
        0
      end
    end
  end

  def Utils.getDribbbleShots(username, count = 1)
    # Retrieve last Dribbble shots, then again memcache its ass off
    cache(3600, 'dribbble') do
      begin
        url = "http://api.dribbble.com/players/" + username + "/shots"
        json = open(url).read
        Yajl::Parser.parse(json)['shots'].first(count)
      rescue Exception => e
        print e
        nil
      end
    end
  end
  
end