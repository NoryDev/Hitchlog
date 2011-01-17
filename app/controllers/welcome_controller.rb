class WelcomeController < ApplicationController
  def home
    @hitchhike = Hitchhike.random_item
    hitchhikes = Hitchhike.all
    @hitchhike_size = hitchhikes.size
    @story_size = hitchhikes.collect{|hh| hh.story}.flatten.compact.size
    @hitchhiked_km = Trip.all.collect{|t| t.distance}.flatten.compact.sum / 1000
  end
  
  def about
    @flov = User.find_by_username('flov')
    @hitchhikers_with_trips = User.all.collect{|user| user unless user.trips.nil? }.compact
  end
end
