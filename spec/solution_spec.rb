require_relative '../solution.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"

  context "general functionality" do
    it "should not raise errors on initialization" do
      expect { click_returner }.to_not raise_error
    end

    it 'returns a hash with clicks divided by IP address' do
      by_ip_address_clicks = click_returner.hash_with_ips_as_keys
      expect(by_ip_address_clicks.has_key?("22.22.22.22")).to eq true
    end

    it 'returns a hash with clicks divided by IPs' do
      clicks_by_ips = click_returner.hash_of_clicks_divided_by_ip
      first_ip = clicks_by_ips["22.22.22.22"]
      first_ip.each do |click|
        expect(click[:ip]).to eq "22.22.22.22"
      end
    end
  end

  context "For each IP within each one hour period" do
    it "should only place the most expensive click in the result set" do
      expect(click_returner_2am_hash.click_results["22.22.22.22"]["2"].length).to eq 1
      expect(click_returner_2am_hash.click_results["22.22.22.22"]["2"].first).to eq highest_value_2am_22_ip
    end
  end

  context "More than one click from the same IP ties for the most expensive click in a one hour period" do
    it "should only place the earliest click into the result set" do
      two_am_result = click_returner_2am_hash.click_results["22.22.22.22"]["2"]
      expect(two_am_result.length).to eq 1
      expect(two_am_result.first[:amount]).to eq 7
      expect(two_am_result.first[:timestamp]).to eq '3/11/2016 02:02:58'
    end
  end

  context "There are more than 10 clicks for an IP in the overall array of clicks" do
    it "should not return any of those clicks in the result set" do
      # Check the original array has more than 10 22.22.22.22 IP elements
      number_of_elements = 0
      clicks_array.each { |click| number_of_elements += 1 if click[:ip] == "22.22.22.22" }
      expect(number_of_elements).to eq 12
      # This initializers with clicks_array element
      expect(click_returner.click_results.has_key?("22.22.22.22")).to eq false
    end
  end
end