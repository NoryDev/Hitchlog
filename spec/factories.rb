require 'factory_girl'
require 'faker'

FactoryGirl.define do
  sequence :email do |n|
    "testuser#{n}@example.com"
  end

  factory :comment do
    body "Great Example Comment"
    association :user
    association :trip
  end

  factory :sign_in_address do
  end

  factory :user do
    email                 { generate(:email) }
    username              { |u| u.email.split("@").first }
    password              "password"
    password_confirmation "password"
    cs_user               Faker::Name.first_name
    last_sign_in_at       Time.zone.now
    sign_in_lat           0.0          # if tested offline
    sign_in_lng           0.0          # it must not be null for tests
    association           :sign_in_address
    gender                'male'
  end

  factory :munich_user, :parent => :user do
    current_sign_in_ip "195.71.11.67"
  end

  factory :berlin_user, :parent => :user do
    current_sign_in_ip "88.73.54.0"
  end

  factory :ride do
    waiting_time 15
    duration 2
    association(:person)
  end

  factory :person do
    occupation   'Groupie'
    mission      'Tour around with the Beatles'
    origin       'USA'
  end
end

Factory.define :trip do |trip|
  trip.from 'Tehran'
  trip.to 'Shiraz'
  trip.start "07/12/2011 10:00"
  trip.end   "07/12/2011 20:00"
  trip.travelling_with 0
  trip.gmaps_duration   9.hours.to_i
  trip.distance 1_646_989
  trip.association(:user)
  trip.hitchhikes 1
end
