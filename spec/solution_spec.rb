require_relative '../solution.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"

  context "general functionality" do
    it "should not raise errors on initialization" do
      expect { click_returner }.to_not raise_error
    end

    it 'returns an array with clicks in hashes and blank arrays as values' do
      array_of_ips_as_keys = click_returner.array_of_ips_as_keys
      expect(array_of_ips_as_keys.length).to eq 6
      expect(array_of_ips_as_keys.first.class).to eq Hash
      expect(array_of_ips_as_keys.first["22.22.22.22"].class).to eq Array
    end

    it 'returns a hash with clicks divided by hours in ip address' do
      hours_of_ip_into_array = click_returner.hours_of_ip_into_array_of_ips
      expect(hours_of_ip_into_array.length).to eq 6
      binding.pry
      expect(hours_of_ip_into_array.first["22.22.22.22"].first).to eq(
        {"2"=>[{:ip=>"22.22.22.22", :timestamp=>"3/11/2016 02:02:58", :amount=>7.0}]}
      )
    end
  end

  describe "Challenge Requirements" do 
    context "More than one click from the same IP ties for the most expensive click in a one hour period" do
      it "should only place the earliest click into the result set" do
        two_am_result = click_returner_2am_hash.click_results
        result = two_am_result.first["22.22.22.22"].first.values.first.first
        expect(result).to eq highest_earliest_result_2am_ip
        expect(highest_earliest_result_2am_ip[:timestamp]).to eq '3/11/2016 02:02:58'
        # Also included this same value but later click from the same hour:
        # let(:highest_later_2am_result) { { ip:'22.22.22.22', timestamp:'3/11/2016 02:22:58', amount: 7.00 } }
      end
    end

    context "For each IP within each one hour period" do
      it "should only place the most expensive click in the result set" do
        # two_am_hash initializes the ClickReturner class like so:
        # let(:click_returner_2am_hash) { ClickReturner.new(two_am_hash) }
        # Includes a value with less than the max
        expect(two_am_hash).to include(lowest_value_2am_22_ip)
        expect(lowest_value_2am_22_ip[:amount]).to eq 3
        # Class is taking in a hash of more than one result
        expect(two_am_hash.length).to eq 4
        # Class is taking in hash from same hour
        two_am_hash.each do |click|
          expect(click[:timestamp].to_time.hour.to_s).to eq "2"
        end
        two_am_result = click_returner_2am_hash.click_results
        result = two_am_result.first["22.22.22.22"].first.values.first.first
        expect(result[:amount]).to eq 7
      end
    end

    context "There are more than 10 clicks for an IP in the overall array of clicks" do
      it "should not return any of those clicks in the result set" do
        # Check the original array has more than 10 22.22.22.22 IP elements
        number_of_elements = 0
        clicks_array.each { |click| number_of_elements += 1 if click[:ip] == "22.22.22.22" }
        expect(number_of_elements).to eq 12
        # This initializers with clicks_array element, from the original problem
        results = click_returner.click_results
        binding.pry
        expect(2).to eq 2
      end
    end
  end
end
