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
  
    end
  end

  describe "Challenge Requirements" do 
    context "More than one click from the same IP ties for the most expensive click in a one hour period" do
      it "should only place the earliest click into the result set" do
        click_returner.click_results
        binding.pry
      end
    end

    context "For each IP within each one hour period" do
      it "should only place the most expensive click in the result set" do

      end
    end

    context "There are more than 10 clicks for an IP in the overall array of clicks" do
      it "should not return any of those clicks in the result set" do

      end
    end
  end
end
