class ClickReturner
  require 'time'
  require 'active_support/all'
  attr_accessor :clicks_array

  def initialize(clicks_array)
    @clicks_array = clicks_array
  end

  def click_results

  end

  def click_hours_hash
    hours = {}
    @clicks_array.each do |click|
      click_hour = click[:timestamp].to_time.hour.to_s
      unless hours.has_key?(click_hour)
        hours[click_hour] = []
      end
    end
    hours
  end

  def clicks_divided_into_hours_hash
    hours_hash = click_hours_hash
    @clicks_array.each do |click|
      binding.pry
      click_hour = click[:timestamp].to_time.hour.to_s
      binding.pry
      hours_hash[click_hour].push(click)
      binding.pry
    end
    hours_hash
  end

  def clicks_divided_by_ip_address_hash
    clicks_by_ip = {}
    @clicks_array.each do |click|
      click_ip = click[:ip].to_s
      unless clicks_by_ip.hash_key?(click_ip)
        clicks_by_ip[click_lip] = []
      end
    end
    clicks_by_ip
  end

  def highest_amount_each_hour
    hours = {}
    clicks.map { |click| click[:timestamp].to_time }
    clicks.each do |click|
      # Create array for each hour with hour as key
      click_hour = click[:timestamp].hour.to_s
      hours[click_hour] = []
    end
  end
end
