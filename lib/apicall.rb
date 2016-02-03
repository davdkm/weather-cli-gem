require 'pry'
require 'nokogiri'
require 'open-uri'

class Apicall

  def self.call(city, country)
    # Gets weather data
    xml = Nokogiri::HTML(open("http://api.openweathermap.org/data/2.5/forecast?q=#{city},#{country}&mode=xml&units=imperial&APPID=a44943d6e75bdea08371d2e9fb59e9a2"))
    weather_data = []
    weather_data[1] = []
    xml.css("weatherdata").each do |element|
      #weather_data = []
      weather_data[0] = element.css("location name").text
      element.css("forecast time").each do |item|
        weather_data[1] << {
          :time => item.attribute("from").value,
          :temp => item.css("temperature").attribute("value").value,
          :humidity => item.css("humidity").attribute("value").value,
          #:clouds => item.css("clouds").attribute("value").value,
          :condition => item.css("symbol").attribute("name").value
        }
      end
    end
    weather_data
  end

end
