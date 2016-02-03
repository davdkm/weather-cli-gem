require 'pry'
require 'open-uri'
require 'nokogiri'
require 'colorize'

class Weather

  @@city = ''
  @@country = ''
  @@weather = []
  @@days = []
  @@day = []

  attr_accessor :temp, :humidity, :location, :temp, :humidity, :cloud, :precipitation, :symbol, :wind, :time, :weather_data;

  def self.get_location
    puts "Please enter the name of the city or zip code, country."
    input = gets.strip
    @@city, @@country = input.split(", ").first, input.split(", ").last
  end

  def self.get_day
    puts "Please enter the number of the day to forecast."
    input = gets.strip.to_i
    case input
    when 1..5
      input
    else
      self.get_day
    end
  end

  def self.get_input
    input = gets.strip
    ['yes', 'y', 'n', 'no'].detect(input.downcase) ? input.downcase : self.get_input
  end

  def self.clear_all
    @@weather.clear
    @@days.clear
    @@city = ''
    @@country = ''
  end

  def self.city
    @@city
  end

  def self.country
    @@country
  end

  def self.weather
    @@weather
  end

  def self.location
    @@location
  end

  def self.call
    # Gets weather data
    xml = Nokogiri::HTML(open("http://api.openweathermap.org/data/2.5/forecast?q=#{self.city},#{self.country}&mode=xml&units=imperial&APPID=a44943d6e75bdea08371d2e9fb59e9a2"))

    xml.css("weatherdata").each do |element|
      @@location = element.css("location name").text
      element.css("forecast time").each do |item|
        @@weather << {
          :time => item.attribute("from").value,
          :temp => item.css("temperature").attribute("value").value,
          :humidity => item.css("humidity").attribute("value").value,
          #:clouds => item.css("clouds").attribute("value").value,
          :condition => item.css("symbol").attribute("name").value
        }
      end
    end
  end

  def self.forecast
    days = self.split_time
    day = days.uniq[self.get_day - 1]

    puts "Here's the weather forecast for " + "#{self.location}".colorize(:red) + " on " + "#{day}.".colorize(:light_blue)
    @@weather.each do |item|
      if item[:time].split("T").first == day
        puts "-------------------"
        puts "At " + "#{item[:time].split("T").last}:".colorize(:red) + " #{item[:condition]}.".colorize(:light_blue)
        puts "The temperature will be " + "#{item[:temp]}F.".colorize(:red)
        puts "Humidity will be at " + "#{item[:humidity]}%.".colorize(:light_blue)
      end
    end
  end

  def self.day_to_forecast
    days = self.split_time
    days.uniq.each_with_index{|date, index| puts "#{index + 1}. #{date}"}
  end

  def self.split_time
    array = []
    @@weather.each{|key, value| array << key[:time].split("T").first}
    array
  end

  def self.start
    self.get_location
    self.call

    puts "Please select a day to forecast for #{self.location}."
    self.day_to_forecast
    self.forecast
    self.again?
  end

  def self.again?
    puts "Would you like to receive another forecast?"
    input = self.get_input
    if input == 'y' || input == 'yes'
      self.clear_all
      self.start
    elsif input == 'n' || input == 'no'
      puts "Goodbye!"
    else
      self.again?
    end
  end
end
