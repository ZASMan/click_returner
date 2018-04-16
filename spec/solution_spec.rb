require_relative '../click_returner.rb'
require_relative 'clicks_context.rb'
require 'pry'

describe 'Click Returner' do
  include_context "clicks context"
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