require 'pry'
require 'colorize'
require_relative 'apicall.rb'

class Weather

  attr_accessor :temp, :humidity, :location, :temp, :humidity, :cloud, :precipitation, :symbol, :wind, :time, :forecast;

  def initialize(city, country)
    @city = city
    @country = country
    @forecast = []
  end

  def day
    self.split_time.uniq[CLIController.get_day - 1]
  end

  def find_day(day)
    @forecast.detect{|item| item[:time].split("T").first == day}
  end

  def display_forecast(day)
    puts "Here's the weather forecast for " + "#{self.location}".colorize(:red) + " on " + "#{day}.".colorize(:light_blue)

    chosen_date = find_day(day)
    @forecast.each do |item|
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
    days.each_with_index{|date, index| puts "#{index + 1}. #{date}"}
  end

  def split_time
    @forecast.map{|key, value| key[:time].split("T").first}.uniq
  end

end
