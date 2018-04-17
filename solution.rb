class ClickReturner
  require 'time'
  require 'active_support/all'
  attr_accessor :clicks_array

  def initialize(clicks_array)
    @clicks_array = clicks_array
  end

  def click_results
    
  end

  def hash_with_ips_as_keys
    ip_key_hash = {}
    @clicks_array.each do |click|
      click_ip = click[:ip].to_s
      unless ip_key_hash.has_key?(click_ip)
        ip_key_hash[click_ip] = []
      end
    end
    ip_key_hash
  end

  def hash_of_clicks_divided_by_ip
    clicks_hash = hash_with_ips_as_keys
    @clicks_array.each do |click|
      click_ip = click[:ip].to_s
      clicks_hash[click_ip].push(click)
    end
    clicks_hash
  end

  def highest_value_per_ip
    highest_value_hash = {}
    amounts = []
    hash_of_clicks_divided_by_ip.keys do |ip|
      hash_of_clicks_divided_by_ip[ip].each do |click|
        click_amount = click[:amount]
        amounts.push(click_amount)
      end
    end
  end

  def hours_per_ip(ip_hash)
    hours = []
    ip_hash.each do |click|
      click_hour = click[:timestamp].hour.to_s
      hours.push(click_hour)
    end
    hours
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
