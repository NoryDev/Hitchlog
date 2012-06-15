json.id        @ride.id
json.trip_path trip_path(@ride.trip)
json.images_for_ride images_for_ride(@ride)
json.route     @ride.trip.route
json.from      @ride.trip.from
json.to        @ride.trip.to
json.caption   render 'rides/hitchslider/caption', ride: @ride
json.photo_url @ride.photo.url(:cropped)
json.title     "<h2>#{link_to @ride.title, trip_path(@ride.trip)}</h2>"
json.story     @ride.markdown_story
json.next_link random_photo_path(next: true, id: @ride.id)
json.prev_link random_photo_path(prev: true, id: @ride.id)
