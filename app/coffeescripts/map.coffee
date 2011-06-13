tripDateStart = $("input#trip_start").datetimepicker({maxDate: new Date(), dateFormat: 'dd/mm/yy'});


window.map = null
window.geocoder = null
window.marker = null
window.infowindow = null

window.init_address_map = ->
  if google?
    options = {
      zoom: 1,
      center: new google.maps.LatLng(52.5234051, 13.411399899999992),
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    window.map = new google.maps.Map($('#map')[0], options)
    
  return

set_field = (type, value) ->
  $("input#trip_from_#{type}").val value
  return

window.get_location = (location, suggest_field) ->
  if google?
    if !geocoder?
      geocoder = new google.maps.Geocoder()

    geocoderRequest = { address: location }
    geocoder.geocode geocoderRequest, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        if results.length > 1
          console.log results
          max_results = 10
          if max_results >= results.length
            max_results = results.length
            $(suggest_field).html 'Suggestions:<br/>'
            for x in [0..max_results]
              if results[x]
                full_address = results[x].formatted_address
                link_to = "<a href='#' data-full-address='#{full_address}' class='set_map_search'>#{full_address}</a><br />"
                $("#suggest").append link_to
            $("#suggest").show()
        else
          $("#suggest").hide()
          location = results[0].geometry.location
          window.map.setCenter location
          $("input#trip_from_lat").val location.lat()
          $("input#trip_from_lng").val location.lng()
          address_components = results[0].address_components
          if address_components.length > 0
            for x in [0..address_components.length-1]
              type = address_components[x].types[0]
              value = address_components[x].long_name
              switch type
                when 'locality'
                  set_field 'city', value
                when 'country'
                  set_field 'country', value
                  set_field 'country_code_iso', address_components[x].short_name
                when 'postal_code'
                  set_field 'zip', value
                when 'route'
                  set_field 'street', value
                when 'street_number'
                  set_field 'street_no', value

            if !window.marker?
              window.marker = new google.maps.Marker { map: window.map }

            window.map.setZoom 12
            window.marker.setPosition location
            window.marker.setVisible true
            $('#address_selection').show()
  return

