require 'pry'
require 'open-uri'
require 'nokogiri'

class Weather
  @@city = ''
  @@country = ''

  attr_accessor :temp, :humidity, :location, :temp, :humidity, :cloud, :precipitation, :symbol, :wind, :time

  def self.get_input
    puts "Please enter the name of the city or zip code, country"
    input = gets.strip
    @@city, @@country = input.split(", ").first, input.split(", ").last
  end

  def self.city
    @@city
  end

  def self.country
    @@country
  end

  def self.call
    # Gets weather data
    xml = Nokogiri::HTML(open("http://api.openweathermap.org/data/2.5/forecast?q=#{self.city},#{self.country}&mode=xml&units=imperial&APPID=a44943d6e75bdea08371d2e9fb59e9a2"))
    binding.pry
    weather = {}
    xml.css("weatherdata").each do |element|
      weather[:location] = element.css("location name").text
      weather[:time] = element.css("forecast time").attribute("from").value
      weather[:temp] = element.css("forecast time temperature").attribute("value").value
    end
  end

end
