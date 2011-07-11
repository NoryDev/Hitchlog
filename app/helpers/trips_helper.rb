module TripsHelper
  def log_trip_header(trip)
    if trip.new_record?
      "<h3>Log a new Hitchhiking Trip</h3>".html_safe
    else
      "<h3>Edit Hitchhiking Trip</h3>".html_safe
    end
  end

  def hitchhiked_with(number)
    unless number.nil?
      case number
      when 0
        I18n.t('helper.trip.alone')
      when 1
        I18n.t('helper.trip.with_1')
      when 2
        I18n.t('helper.trip.with_2')
      when 3
        I18n.t('helper.trip.with_3')
      when 4
        I18n.t('helper.trip.with_4')
      else
        I18n.t('helper.trip.with_more_than_4')
      end
    end
  end

  def country_images(trip)
    array = []
    
    trip.countries_with_distance.each do |hash|
      array << country_image(hash[:country], hash[:distance])
    end
    array.join(' ').html_safe
  end

  def country_image(country, country_distance)
    case country
      when "The Netherlands" then country = "Netherlands"
      # Add more exceptions...
    end

    unless I18nData.country_code(country).nil?
      image_tag "flags/png/#{I18nData.country_code(country).downcase}.png", :class => 'tooltip', :alt => "#{country} #{distance( country_distance )}"
    end
  end

  
  def link_to_trip(trip, options ={})
    array = []
    array << photo_image unless trip.rides.collect{|h| h.photo.file?}.delete_if{|x|!x}.compact.empty?
    array << story_image unless trip.rides.collect{|h| h.story}.compact.delete_if{|x| x==''}.empty?
    unless trip.rides.collect{|h| h.person.nil?}.compact.delete_if{|x|x==true}.empty?
      array << user_image.html_safe
    end
    string = "#{h(trip.from)} &rarr; #{h(trip.to_city)} (#{distance(trip.distance)}), #{pluralize(trip.rides.size, 'ride')}".html_safe
    if array.empty?
      string << ", no information"
    else
      string << ", with #{array.join(' ')}".html_safe 
    end
    
    string << ", #{link_to(add_image, trip_path(trip))}".html_safe if current_user == trip.user
    
    if array.empty?
      string.html_safe
    elsif options[:remote] == true
      link_to(string, trip_path(trip), {:class => 'trip', :rel => trip.id}).html_safe
    else
      link_to(string, trip_path(trip)).html_safe
    end
  end
  
  def trip_has_duration(trip)
    (!trip.duration.nil? and trip.duration > 0) or (trip.start.nil? and trip.end.nil?)
  end  

  def ride_box_attributes(i, trip)
    array=[]
    array << "ride"
    array << "last" if i == trip.rides.size
    array.join ' '
  end
end
