

class Gets

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
