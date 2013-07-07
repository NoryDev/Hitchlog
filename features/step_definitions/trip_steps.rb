Given /^a trip exists from "([^"]*)" to "([^"]*)"$/ do |from, to|
  @trip = FactoryGirl.create(:trip, from: from, to: to)
end

Given /^a trip exists$/ do
  FactoryGirl.create(:trip)
end

Given /^the user the trip from "([^"]*)" to "([^"]*)" is "([^"]*)"$/ do |from, to, username|
  trip = Trip.where(from: from, to: to).first
  user = trip.user
  user.username = username
  user.save!
end

Given /^the distance of the trip from "([^"]*)" to "([^"]*)" was (\d+) km$/ do |from, to, number|
  trip = Trip.where(from: from, to: to).first
  trip.distance = number.to_i * 1000
  trip.save!
end

Given /^he did the trip (\d+) days ago$/ do |number|
  @trip.departure = number.to_i.days.ago
  @trip.save!
end

Given /^it took him (\d+) hours$/ do |number|
  @trip.arrival = @trip.departure + number.to_i.hours
end

Given /^google maps says it takes 9 hours and 15 minutes$/ do
  @trip.gmaps_duration = (9.hours + 15.minutes).to_i
  @trip.save!
end

Given /^a German trip exists$/ do
  @german_trip = FactoryGirl.build(:trip, :from => 'Berlin', :to => 'Freiburg')
  @german_trip.country_distances <<  CountryDistance.new(:country => 'Germany', :distance => 123123)
  @german_trip.save!
end

Given /^an English trip exists$/ do
  @english_trip = FactoryGirl.build(:trip, :from => 'London', :to => 'Manchester')
  @english_trip.country_distances <<  CountryDistance.new(:country => 'United Kingodm', :distance => 123123)
  @english_trip.save!
end

When /^I search for German trips$/ do
  select  "Germany", :from => "country"
  click_button "Search"
end

Then /^I should see a German trip$/ do
  page.should have_content @german_trip.from
end

Then /^I should see an English trip$/ do
  page.should have_content @english_trip.from
end

Then /^I should not see an English trip$/ do
  page.should_not have_content @english_trip.from
end

Given /^a trip with a story$/ do
  @trip_with_story = FactoryGirl.build(:trip, hitchhikes: 0)
  @trip_with_story.rides << FactoryGirl.create(:ride,
                                               story: Faker::Lorem::paragraph(sentence_count = 10))
  @trip_with_story.save!
end

Given /^a trip without a story$/ do
  @trip_without_story = FactoryGirl.create(:trip)
end

Then /^I should see a trip with a story$/ do
  page.should have_content @trip_with_story.from
end

Then /^I should see a trip without a story$/ do
  page.should have_content @trip_without_story.from
end

When /^I search for trips with stories$/ do
  check "Story"
  click_button "Search"
end

Then /^I should see trips with stories$/ do
  page.find("#trip_#{@trip_with_story.id}").should have_content("#{@trip_with_story.rides.first.story[0..150]}")
end

Then /^I should not see trips without stories$/ do
  lambda { page.find("#trip_#{@trip_without_story.id}") }.should raise_error(Capybara::ElementNotFound)
end

Given /^each one of these 6 trips have a different experience$/ do
  experiences = ['extremely positive', 'positive', 'neutral', 'negative', 'extremely negative']
  trips = Trip.all
  6.times do |i|
    ride = trips[i].rides.first
    ride.experience = experiences[i]
    ride.save!
  end
end

When /^I search for trips with an "([^"]*)" experience$/ do |experience|
  select experience, :from => "experience"
  click_button "Search"
end

Then /^I should see a trip with an? "([^"]*)" experience$/ do |experience|
  page.should have_content("#{experience}.png")
end

Then /^I should not see a trip with an? "([^"]*)" experience$/ do |experience|
  page.should_not have_content("#{experience}.png")
end

Given /^a trip from "([^"]*)" to "([^"]*)" with a photo on ride$/ do |from, to|
  trip = FactoryGirl.create(:trip, from: from, to: to)
  ride = trip.rides.first
  ride.photo = File.open("#{Rails.root}/features/support/images/thumb.png")
  ride.save
end

Then /^I should see the trip from "([^"]*)" to "([^"]*)" in the hitchslide$/ do |from, to|
  page.find("#hitchslide").should have_content("from #{from} to #{to}")
end

When /^I click on the next button$/ do
  click_link("Next")
end

When /^I fill in the new trip form$/ do
  VCR.use_cassette 'berlin' do
    fill_in('trip_from', with: 'Berlin', exact: true)
    page.find(".pac-container .pac-item:first").click
  end

  VCR.use_cassette 'hamburg' do
    fill_in('To', with: 'Reeperbahn, Hamburg', exact: true)
    page.find('.pac-container .pac-item', text: 'Hamburg, Germany').click
  end

  fill_in('Departure', with: '07/12/2011 10:00')
  fill_in('Arrival', with: '07/12/2011 20:00')
  select('4', from: 'Number of rides')
  select('alone', from: 'Traveling with')
end

Then /^the from and to location should be geocoded$/ do
  # from geocoding:
  find('#trip_from_formatted_address', visible: false).value.should == 'Berlin, Germany'
  find('#trip_from_city', visible: false).value.should == 'Berlin'
  find('#trip_from_country', visible: false).value.should == 'Germany'
  find('#trip_from_country_code', visible: false).value.should == 'DE'
  find('#trip_to_lat', visible: false).value.to_i.should == 53
  find('#trip_to_lng', visible: false).value.to_i.should == 9

  # to geocoding:
  find('#trip_to_formatted_address', visible: false).value.should == 'Reeperbahn, 20359 Hamburg, Germany'
  find('#trip_to_city', visible: false).value.should == 'Hamburg'
  find('#trip_to_country', visible: false).value.should == 'Germany'
  find('#trip_to_country_code', visible: false).value.should == 'DE'
  find('#trip_to_lat', visible: false).value.to_i.should == 53
  find('#trip_to_lng', visible: false).value.to_i.should == 9
end


Then /^it should calculate the distance$/ do
  find('#trip_distance_display').should have_content('291 km')
  find('#trip_distance').value.to_i.should == 290749
end

Then /^it should route from origin to destination$/ do
  find('#trip_distance_display').should have_content('291 km')
end

Then /^I should see the details of the trip again$/ do
  find('#from').should have_content('Berlin, Germany')
  find('#to').should have_content('Reeperbahn, 20359 Hamburg, Germany')
  find('#distance').should have_content('291 km')
  find('#no_of_rides').should have_content('4')
  find('#departure').should have_content('07/12/2011 10:00')
  find('#arrival').should have_content('07/12/2011 20:00')
end

When /^I confirm that the data is correct$/ do
  click_button("Create Trip")
end

