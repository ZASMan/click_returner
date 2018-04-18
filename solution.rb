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
      hash_of_hours.each do |hour, clicks|
        # Sort by amount
        # Use bang to modify original array
        clicks.sort_by! { |click| click[:amount] }
        # Only continue if there are multiple clicks
        # per hour
        # This is for saving the earlier occurence that is equal
        # To the highest amount
        duplicates = []
        if clicks.length > 1
          array_length = clicks.length
          click_index = Array(0..array_length)
          highest_click = clicks.last
          # Dont modify original
          sorted_clicks = clicks.sort_by { |click| click[:timestamp].to_time }
          # Push the earliest click to array if its amount is equal to the greatest amount
          # But occured earlier
          clicks.each { |click| duplicates.push(click) if click[:timestamp].to_time > highest_click[:timestamp].to_time }
          # Duplicates will be equal to clicks that occurred before the highest amount one but have the same amount
          # Now re sort and return the earliest one
          if duplicates.length > 1
            duplicates.sort_by! {|click| click[:timestamp].to_time }
            earliest_click = duplicates.last
            result.push(earliest_click)
          elsif duplicates.length == 1
            earliest_click = duplicates.last
            result.push(earliest_click)
          else
            result.push(highest_click)
          end
        else
          # Push to original results
          # Should only be one per hour
          # Push last because clicks array
          # Is sorted by highest amount
          highest_click = clicks.last
          result.push(highest_click)
        end
      end
    end
    result
  end
end

clicks = [
{ ip:'22.22.22.22', timestamp:'3/11/2016 02:02:58', amount: 7.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 02:13:54', amount: 8.75 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 05:02:45', amount: 11.00 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 06:32:42', amount: 5.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 06:35:12', amount: 2.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 06:45:01', amount: 12.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 06:59:59', amount: 11.75 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 07:01:53', amount: 1.00 },
{ ip:'11.11.11.11', timestamp:'3/11/2016 07:02:54', amount: 4.50 },
{ ip:'33.33.33.33', timestamp:'3/11/2016 07:02:54', amount: 15.75 },
{ ip:'66.66.66.66', timestamp:'3/11/2016 07:02:54', amount: 14.25 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 07:03:15', amount: 12.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 08:02:22', amount: 3.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 09:41:50', amount: 4.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 10:02:54', amount: 5.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 11:05:35', amount: 10.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 13:02:21', amount: 6.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:02:40', amount: 8.00 },
{ ip:'44.44.44.44', timestamp:'3/11/2016 13:02:55', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:33:34', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:42:24', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 13:47:44', amount: 6.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 14:02:54', amount: 4.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 14:03:04', amount: 5.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 15:12:55', amount: 6.25 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 16:02:36', amount: 8.00 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 16:22:11', amount: 8.50 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 17:18:19', amount: 11.25 },
{ ip:'55.55.55.55', timestamp:'3/11/2016 18:19:20', amount: 9.00 },
{ ip:'22.22.22.22', timestamp:'3/11/2016 23:59:59', amount: 9.00 }
]

solution = ClickReturner.new(clicks)
file = "result-set.txt"
File.open(file, 'w') { |file| file.write(solution.click_results.to_s) }
puts("Writing to result set file complete.")

