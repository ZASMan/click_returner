require_relative '../solution.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"

  context "general functionality" do
    it "should not raise errors on initialization" do
      expect { click_returner }.to_not raise_error
    end

    it "returns a hash with hour strings as keys" do
      hours_hash = click_returner.click_hours_hash
      expect(hours_hash.has_key?("2")).to eq true
      expect(hours_hash.has_key?("18")).to eq true
    end

    it 'returns a hash with clicks divided into hashes of respective hours' do
      two_am_clicks = click_returner.clicks_divided_into_hours_hash["2"]
      expect(two_am_clicks.first).to eq first_2am_click_hash_element
      binding.pry
    end
  end

  context "For each IP within each one hour period" do
    it "should only place the most expensive click in the result set" do

    end
  end

  context "More than one click from the same IP ties for the most expensive click in a one hour period" do
    it "should only place the earliest click into the result set" do
    end
  end

  context "There are more than 10 clicks for an IP in the overall array of clicks" do
    it "should not return any of those clicks in the result set" do
    end
  end
end