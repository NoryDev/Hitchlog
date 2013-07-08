autocomplete_options = { types: ['geocode'] }
autocomplete = new google.maps.places.Autocomplete($("#user_location")[0], autocomplete_options)

google.maps.event.addListener(autocomplete, 'place_changed', ->
  place = autocomplete.getPlace()

  if (!place.geometry)
    # Inform the user that the place was not found and return.
    $(".user_location .controls").append('<span class="help-inline">Could not find location, please try again</span>')
    $(".user_location").addClass('error')
    return

  else
    $("input#user_lat").val place.geometry.location.lat()
    $("input#user_lng").val place.geometry.location.lng()

    if place.address_components.length > 0
      $(".user_location").addClass('success')

      for x in [0..place.address_components.length-1]
        type = place.address_components[x].types[0]
        value = place.address_components[x].long_name
        switch type
          when 'locality'
            $("input#user_city").val value
            city = value
          when 'country'
            country = value
            country_code = place.address_components[x].short_name.toLowerCase()
            $("input#user_country").val country
            $("input#user_country_code").val country_code

      if country_code and country and city
        # display country and city:
        # remove old if it exists
        $('.user_location .controls .help-block').html('')
        $(".user_location .controls").append(
          "<span class='help-block'>
             <img class='tip' src='/assets/flags/png/#{country_code}.png' title='#{country}' data-original-title='#{country}'>
             #{city}
           </span>"
        )
)
