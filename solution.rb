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

  def hours_of_ip_into_array_of_ips
    array_of_ips_as_keys = self.array_of_ips_as_keys
    @clicks_array.each do |click|
      click_info = click[:ip].to_s + " at " + click[:timestamp].to_time.hour.to_s + " hour " + " with amount " + click[:amount].to_s
      #puts("Now processing click " + click_info)
      array_of_ips_as_keys.each_with_index do |element, index|
        ip_key = array_of_ips_as_keys[index].keys.first
        click_ip_array = array_of_ips_as_keys[index][ip_key]
        click_hour = click[:timestamp].to_time.hour.to_s
        new_amount = click[:amount]
        click_ip_by_hour = { click_hour => [click] }
        click_ip_array.push(click_ip_by_hour) if ip_key == click[:ip]
      end
    end
    # Remove results if greater than 10
    array_of_ips_as_keys.reject! { |click_hash| click_hash.first.second.length > 10 }
    # Remove lesser duplicates
    array_of_ips_as_keys.each do |click_hash|
      ip = click_hash.first.first
      values_by_hour = click_hash[ip]
      sorted_by_amount = values_by_hour.sort_by do |x|
        hour = x.keys.first
        x[hour].first[:amount]
      end
      highest_value_hash = sorted_by_amount.last
      values_by_hour.sort_by! do |x|
        hour = x.keys.first
        x[hour].first[:timestamp].to_time
      end
      # Sort by hour again
      values_by_hour.reject! do |value_hash|
        hour = value_hash.first.first
        values = value_hash["2"].first
        highest_value_hash_value = highest_value_hash[hour].first[:amount]
        values[:amount] < highest_value_hash_value
      end
      while values_by_hour.length > 1 do
        values_by_hour.pop
      end
      array_of_ips_as_keys
      binding.pry
    end
  end
end
