class TripsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :find_trip_and_redirect_if_not_owner, :only => [:edit]

  def new
    @trip = Trip.new
  end

  def show
    @trip = Trip.find(params[:id])
    @user = @trip.user
    @rides_with_photos = @trip.rides.select{|ride| ride.photo.file?}
    @rides = @user.trips.map{|trip| trip.rides}.flatten
  end

  def create
    @trip = Trip.new(params[:trip])
    @trip.user = current_user
    if @trip.save
      redirect_to edit_trip_path(@trip)
    else
      render :new
    end
  end

  def index
    @trips = Trip
    @trips = build_search_trips(@trips)
    @trips = @trips.order("trips.id DESC").paginate(:page => params[:page])
  end

  def edit
    @user = @trip.user
    @rides_with_photos = @trip.rides.select{|ride| ride.photo.file?}
    @rides = @user.trips.map{|trip| trip.rides}.flatten
    @trip.rides.each do |ride|
      if ride.person.nil?
        ride.build_person
      end
    end
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      respond_to do |wants|
        wants.html { redirect_to edit_trip_path(@trip) }
        wants.js {}
      end
    else
      render :action => 'edit'
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
    redirect_to trips_url
  end

  private

  def find_trip_and_redirect_if_not_owner
    @trip = Trip.find(params[:id])
    if @trip.user != current_user
      flash[:error] = "This is not your trip."
      redirect_to trips_path
    end
  end
end
