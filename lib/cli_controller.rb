class CLIController
  def self.start
    location = get_location
    city, country = location.first, location.last
    new_forecast = Weather.new(city, country)
    api_data = WeatherMapClient.call(city, country)
    new_forecast.forecast = api_data[:data][0]
    new_forecast.location = api_data[:location]
    puts "Please select a day to forecast for #{new_forecast.location}."
    new_forecast.day_to_forecast
    new_forecast.display_forecast(new_forecast.day)
    self.again?
  end

  def self.again?
    puts "Would you like to receive another forecast?"
    input = get_input
    if input == 'y' || input == 'yes'
      self.start
    elsif input == 'n' || input == 'no'
      puts "Goodbye!"
    else
      self.again?
    end
  end

  def self.get_location
    puts "Please enter the name of the city or zip code, country."
    input = gets.strip
    input.split(", ")
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
end
