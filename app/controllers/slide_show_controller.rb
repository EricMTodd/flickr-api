require 'json'
require 'pry'

class SlideShowController < ApplicationController
  @@city = "Denver"

  def index
    compiled_weather_data = compile_weather_data
    @city = @@city
    @temperature = compiled_weather_data[:temperature_data]
    @urls = compile_image_urls
    @weather = compiled_weather_data[:weather_data]
  end
  
  private
  
  def make_photos_request
    url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=39ebf8206b5f188179bf4176fadf9407&user_id=194608125%40N04&format=json&nojsoncallback=1"
    response = RestClient.get(url.to_s, accept: :json)
    json = JSON.parse(response)
    photos = json["photos"]["photo"]
  end
  
  def compile_image_urls
    compiled_urls = Array.new
    photos = make_photos_request
    photos.each do |photo|
      new_url = "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_b.jpg"
      compiled_urls << new_url
    end
    return compiled_urls
  end

  def make_weather_request
    response = RestClient.get("api.openweathermap.org/data/2.5/weather?q=#{@@city}&appid=8d9b598296f463cb05d7baea7c741c65", accept: :json)
  end

  def compile_weather_data
    weather = make_weather_request
    json = JSON.parse(weather)
    temperature_data = json['main']
    weather_data = json['weather']
    compiled_weather_data = {
      temperature_data: temperature_data,
      weather_data: weather_data[0]
    }
  end
end