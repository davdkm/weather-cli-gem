require 'pry'
require 'colorize'
require_relative 'apicall.rb'
require_relative 'get_input.rb'

class Weather

  attr_accessor :temp, :humidity, :location, :temp, :humidity, :cloud, :precipitation, :symbol, :wind, :time, :weather;

  def initialize(city, country)
    @city = city
    @country = country
    @weather = []
  end

  def day
    days = self.split_time
    day = days.uniq[Gets.get_day - 1]
    day
  end

  def display_forecast(day)
    puts "Here's the weather forecast for " + "#{self.location}".colorize(:red) + " on " + "#{day}.".colorize(:light_blue)


    @weather.each do |item|
      if item[:time].split("T").first == day
        puts "-------------------"
        puts "At " + "#{item[:time].split("T").last}:".colorize(:red) + " #{item[:condition]}.".colorize(:light_blue)
        puts "The temperature will be " + "#{item[:temp]}F.".colorize(:red)
        puts "Humidity will be at " + "#{item[:humidity]}%.".colorize(:light_blue)
      end
    end
  end

  def day_to_forecast
    days = self.split_time
    days.uniq.each_with_index{|date, index| puts "#{index + 1}. #{date}"}
  end

  def split_time
    array = []
    @weather.each{|key, value| array << key[:time].split("T").first}
    array
  end

  def self.start
    location = Gets.get_location
    city, country = location.first, location.last
    new_forecast = Weather.new(city, country)
    api_data = Apicall.call(city, country)
    new_forecast.weather = api_data[1]
    new_forecast.location = api_data[0]
    puts "Please select a day to forecast for #{new_forecast.location}."
    new_forecast.day_to_forecast
    new_forecast.display_forecast(new_forecast.day)
    self.again?
  end

  def self.again?
    puts "Would you like to receive another forecast?"
    input = Gets.get_input
    if input == 'y' || input == 'yes'
      self.start
    elsif input == 'n' || input == 'no'
      puts "Goodbye!"
    else
      self.again?
    end
  end
end
