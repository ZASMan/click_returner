require_relative '../solution.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"

  context "general functionality" do
    it "should not raise errors on initialization" do
      expect { click_returner }.to_not raise_error
    end
  end

  describe "Challenge Requirements" do 
    context "More than one click from the same IP ties for the most expensive click in a one hour period" do
      # Created a new data set for this that has ties
      # See clicks context
      it "should only place the earliest click into the result set" do
        expect(highest_earliest_result_2am_ip[:timestamp].to_time.hour).to eq 2
        expect(highest_later_2am_result[:timestamp].to_time.hour).to eq 2
        expect(highest_earliest_result_2am_ip[:amount]).to eq 7
        expect(highest_later_2am_result[:amount]).to eq 7
        expect(two_am_hash_array).to include(highest_earliest_result_2am_ip)
        expect(two_am_hash_array).to include(highest_later_2am_result)
        results = click_returner_2am_hash.click_results
        expect(results).to include(highest_earliest_result_2am_ip)
        expect(results).not_to include(highest_later_2am_result)
      end
    end

    context "For each IP within each one hour period" do
      it "should only place the most expensive click in the result set" do
        same_hour_highest_click = { ip:'11.11.11.11', timestamp:'3/11/2016 02:13:11', amount: 7.25 }
        same_hour_lesser_click = { ip:'11.11.11.11', timestamp:'3/11/2016 02:12:32', amount: 6.50 }
        expect(clicks_array).to include(same_hour_highest_click)
        expect(clicks_array).to include(same_hour_lesser_click)
        results = click_returner.click_results
        expect(results).not_to include(same_hour_lesser_click)
        expect(results).to include(same_hour_highest_click)
      end
    end

    context "There are more than 10 clicks for an IP in the overall array of clicks" do
      it "should not return any of those clicks in the result set" do
        # Number of 22.22.22.22 ip's
        excess_ip = "22.22.22.22"
        excess_ip_clicks = []
        clicks_array.each { |click| excess_ip_clicks.push(click) if click[:ip] == excess_ip }
        expect(excess_ip_clicks.length).to be > 10
        # Executes a new instance of click returner
        results = click_returner.click_results
        results.each { |click| expect(click[:ip]).not_to eq excess_ip}
      end
    end
  end
end
