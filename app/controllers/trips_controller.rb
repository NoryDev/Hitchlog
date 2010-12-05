class TripsController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @trip = Trip.new
  end
  
  def create
    @trip = Trip.new(params[:trip])
    @trip.user = current_user
    if @trip.save
      flash[:notice] = "Successfully created trip."
      redirect_to trips_path
    else
      render :new
    end
  end
  
  def index
    @trips = Trip.all
  end
  
  def edit
    @trip  = Trip.find(params[:id])
    unless @trip.user == current_user
      flash[:error] = "This is not your trip."
      redirect_to trips_path
    end
  end
  
  def update
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      flash[:notice] = "Successfully updated trip."
      redirect_to trips_path
    else
      render :action => 'edit'
    end
  end
end
