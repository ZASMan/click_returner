require_relative '../solution.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"

  context "general functionality" do
    it "should not raise errors on initialization" do
      expect { click_returner }.to_not raise_error
    end

    # Should have:
    # { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 },
    # { ip:'11.11.11.11', timestamp:'3/11/2016 06:45:01', amount: 12.00 },
    # { ip:'11.11.11.11', timestamp:'3/11/2016 07:02:54', amount: 4.50 },
    it "should return the appropriate number of clicks for a given ip" do
      results = click_returner.click_results
      ip_11_results = results.first["11.11.11.11"]
      binding.pry
      expect(ip_11_results.length).to eq 3
      #expect(ip_11_results.first.values.first).to eq { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 }
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
        results.each_with_index do |result, index|
          expect(result.keys.first).to eq("11.11.11.11") if index == 0
          expect(result.keys.first).not_to eq("22.22.22.22")
        end
      end
    end
  end
end
