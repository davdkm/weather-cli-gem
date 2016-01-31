require 'pry'
require 'net/http'
require 'json'

class Weather
  @@city = ''
  @@country = ''

  def self.get_input
    input = gets.strip
    @@city, @@country = input.split(", ").first, input.split(", ").last
  end

  def self.api_call
    http = "http://api.openweathermap.org/data/2.5/forecast?q=#{self.city},#{self.country}&mode=xml&APPID=a44943d6e75bdea08371d2e9fb59e9a2"
    response = Net::HTTP.get(URI(http))
    puts response
  end

  def self.city
    @@city
  end

  def self.country
    @@country
  end

end
