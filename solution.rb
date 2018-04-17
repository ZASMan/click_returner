require 'pry'
class ClickReturner
  require 'time'
  require 'active_support/all'
  attr_accessor :clicks_array

  def initialize(clicks_array)
    @clicks_array = clicks_array
  end

  def click_results
    hours_of_ip_into_array_of_ips
  end

  def array_of_ips_as_keys
    array_of_ips_as_keys = []
    @clicks_array.each do |click|
      click_ip = click[:ip].to_s
      click_ip_hash_array = { click_ip => [] }
      unless array_of_ips_as_keys.include?(click_ip_hash_array)
        array_of_ips_as_keys.push(click_ip_hash_array)
      end
    end
    array_of_ips_as_keys
  end

  def ips_with_over_10_clicks
    array_of_ips_as_keys = array_of_ips_as_keys
    @clicks_array.each do |click|
    end
  end

  def hours_of_ip_into_array_of_ips
    array_of_ips_as_keys = self.array_of_ips_as_keys
    @clicks_array.each do |click|
      array_of_ips_as_keys.each_with_index do |element, index|
        binding.pry
        ip_key = array_of_ips_as_keys[index].keys.first
        click_ip_array = array_of_ips_as_keys[index][ip_key]
        click_hour = click[:timestamp].to_time.hour.to_s
        new_amount = click[:amount]
        # Gets amount of last value for hour
        if click_ip_array.length > 0 
          last_amount = click_ip_array.last.values.first.first[:amount]
          if new_amount > last_amount # Get rid of the last amount if it is less than the new amount
            click_ip_array.pop
            click_ip_by_hour = { click_hour => [click] }
            click_ip_array.push(click_ip_by_hour) if ip_key == click[:ip]
          elsif new_amount == last_amount
            last_time_exact_time = click_ip_array.last.values.first.first[:timestamp].to_time
            new_time_exact_time = click[:timestamp].to_time
            if last_time_exact_time > new_time_exact_time # Otherwise ignore the later one
              click_ip_array.pop
              click_ip_by_hour = { click_hour => [click] }
              click_ip_array.push(click_ip_by_hour) if ip_key == click[:ip]
            end
          end
        else # Put the first click ins
          click_ip_by_hour = { click_hour => [click] }
          click_ip_array.push(click_ip_by_hour) if ip_key == click[:ip]
        end
      end
    end
    array_of_ips_as_keys
  end
end
