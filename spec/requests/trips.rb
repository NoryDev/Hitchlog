require 'spec_helper'

describe "trips" do
  describe "GET /trips/index" do
    it "should be able to sort trips by country" do
      german_trip = Factory.build(:trip, :from => 'Berlin', :to => 'Freiburg')
      german_trip.country_distances <<  CountryDistance.new(:country => 'Germany')
      german_trip.save!
      
      english_trip = Factory.build(:trip, :from => 'London', :to => 'Manchester')
      english_trip.country_distances <<  CountryDistance.new(:country => 'United Kingodm')
      english_trip
      visit trips_path
      page.should have_content "Berlin"
      page.should have_content "London"
      save_and_open_page
      select  "Germany", :from => "country"
      click_button "Search"
      page.should have_content "Berlin"
      page.should_not have_content "London"
      # "distance"=>807402, "duration"=>12, "end"=>nil, "from"=>"Berlin (Germany)", "from_city"=>"Berlin", "from_country"=>"Germany", "from_formatted_address"=>"Berlin, Germany", "from_lat"=>nil, "from_lng"=>nil, "from_postal_code"=>nil, "from_street"=>nil, "from_street_no"=>nil, "gmaps_duration"=>nil, "id"=>5, "money_spent"=>nil, "route"=>nil, "start"=>nil, "to"=>"Freiburg (Germany)", "to_city"=>"Freiburg", "to_country"=>"Germany", "to_formatted_address"=>"Freiburg im Breisgau, Germany", "to_lat"=>nil, "to_lng"=>nil, "to_postal_code"=>nil, "to_street"=>nil, "to_street_no"=>nil, "travelling_with"=>nil, "updated_at"=>Mon, 11 Jul 2011 15:50:14 UTC +00:00, "user_id"=>2}
    end
  end
end
