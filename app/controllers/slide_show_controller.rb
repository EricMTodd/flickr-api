require 'json'
require 'pry'

class SlideShowController < ApplicationController
  def index
    @urls = compile_urls
    @weather = make_weather_request
    binding.pry
  end
  
  private
  
  def make_photos_request
    response = RestClient.get("https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=d33654f7f4ba030ab30cf81840afd79d&user_id=194608125%40N04&format=json&nojsoncallback=1&auth_token=72157720826377356-e44d986edb9cc115&api_sig=8816b2fdd530943ee97d08d7e8ef5201", accept: :json)
    json = JSON.parse(response)
    photos = json["photos"]["photo"]
  end

  def make_weather_request
    response = RestClient.get("api.openweathermap.org/data/2.5/weather?q=Denver&appid=8d9b598296f463cb05d7baea7c741c65", accept: :json)
  end
  
  def compile_urls
    compiled_urls = Array.new
    template_url = "https://live.staticflickr.com/{server-id}/{id}_{secret}_{size-suffix}.jpg"
    photos = make_photos_request
    photos.each do |photo|
      new_url = "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_b.jpg"
      compiled_urls << new_url
    end
    return compiled_urls
  end
end