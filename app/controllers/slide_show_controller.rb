require 'json'
require 'pry'

class SlideShowController < ApplicationController
  def index
    @urls = compile_urls
  end
  
  private
  
  def make_request
    
    response = RestClient.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=97fddea17599b8f6e7e5f833f30c2b9b&user_id=194608125%40N04&format=json&nojsoncallback=1&auth_token=72157720826237112-ddfe63c915adad78&api_sig=9b6a3bdc3fc4b525ff9c0a518f4fe6e9", accept: :json)
    json = JSON.parse(response)
    photos = json["photos"]["photo"]
  end
  
  def compile_urls
    compiled_urls = Array.new
    template_url = "https://live.staticflickr.com/{server-id}/{id}_{secret}_{size-suffix}.jpg"
    photos = make_request
    photos.each do |photo|
      new_url = "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_b.jpg"
      compiled_urls << new_url
    end
    return compiled_urls
  end
end