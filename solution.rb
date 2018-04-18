require 'pry'
class ClickReturner
  require 'time'
  require 'active_support/all'
  attr_accessor :clicks_array

  def initialize(clicks_array)
    @clicks_array = clicks_array
  end

  def click_results
    # Structure:
    # ip_address_click_count = {
    #   "22.22.22.22" => 10,
    #   "11.11.11.11" => 9

    # }
    all_clicks = @clicks_array
    ip_address_click_count = {}
    result = []
    # Gets total number of clicks per IP
    @clicks_array.each do |click_hash|
      ip = click_hash[:ip]
      if ip_address_click_count.has_key?(ip)
        current_count = ip_address_click_count[ip]
        ip_address_click_count[ip] = current_count + 1
      else
        ip_address_click_count[ip] = 1
      end
    end
    # Rejects clicks over 10 from single IP address
    all_clicks.reject! do |click_hash|
      ip = click_hash[:ip]
      ip_address_click_count[ip] > 10
    end
    # Get the amount for each IP for each hour
    # Structure will be as such:
    # {
    #   "11.11.11.11"=>
    #      {
    #       2=>
    #        [
    #         {:ip=>"11.11.11.11", :timestamp=>"3/11/2016 02:12:32", :amount=>6.5},
    #         {:ip=>"11.11.11.11", :timestamp=>"3/11/2016 02:13:11", :amount=>7.25}
    #        ],
    #       6=>
    #         [
    #          {:ip=>"11.11.11.11", :timestamp=>"3/11/2016 06:45:01", :amount=>12.0},
    #          {:ip=>"11.11.11.11", :timestamp=>"3/11/2016 06:59:59", :amount=>11.75}
    #         ],
    #       },
    # }
    ips_by_hour = {}
    all_clicks.each do |click_hash|
      ip = click_hash[:ip]
      hour = click_hash[:timestamp].to_time.hour
      ips_by_hour[ip] = {} unless ips_by_hour.has_key?(ip)
      if ips_by_hour[ip].has_key?(hour)
        ips_by_hour[ip][hour].push(click_hash)
      else
        ips_by_hour[ip][hour] = []
        ips_by_hour[ip][hour].push(click_hash)
      end
    end
    ips_by_hour.each do |ip, hash_of_hours|
      binding.pry
    end
  end
end
