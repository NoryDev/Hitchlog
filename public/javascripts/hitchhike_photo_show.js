$(
	function(){
    // GOOGLE MAPS:
    // I initiate the Map and associate it with the #map_canvas div
    // Because it is necessary to define a start location i just chose
    // my home location and set the zoom level to 1.
    
    var directionsDisplay = new google.maps.DirectionsRenderer()
    var directionsService = new google.maps.DirectionsService()
    var map;
    
    var startlocation = new google.maps.LatLng(33.431441,61.523438)
    var myOptions = {
      zoom: 1,
      mapTypeId: google.maps.MapTypeId.HYBRID,
      center: startlocation
    }

    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions)
    directionsDisplay.setMap(map)

    // I execute this function whenever the routes need to be set again
    function SetNewRoute(from, to) {
      var start = from
      var end = to
      var request = {
          origin: start, 
          destination: end,
          travelMode: google.maps.DirectionsTravelMode.DRIVING
      }
      directionsService.route(request, function(response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(response)
        }
      })
    }
    
    url = window.location.pathname.split("/").pop()
    $.getJSON(url + ".json", function(data){
      SetNewSitePhotoDetails(data)
      SetNewRoute(data.from, data.to)
    })
		
		// Keep track of properties of the photo details.
		var objBottomProperties = { Min: "-52px", Max: "0px" }		
		// The timer for mouseing out of the site photo area.
		var objMouseOutTimeout = null
		// Keep track of which direction we are animating in.
		var objIsAnimatingSitePhotoDetails = { Show: false, Hide: false }
		// Keep track of site photo XHR request.
		var objSitePhotoRequest = null
		
		// I show the site photo details (if necesssary).
		function ShowSitePhotoDetails(){
			// We only want to animate the Show if we are:
			// 1. Not currently showing the photo details.
			// 2. Currently hiding the photo details.
			if (!objIsAnimatingSitePhotoDetails.Show ||	objIsAnimatingSitePhotoDetails.Hide	)	{
				// Check to see if we need to stop any animation.
				if (objIsAnimatingSitePhotoDetails.Hide){ $( "#hitchhike-photo-details" ).stop()	}
				
				// Flag the animations.
				objIsAnimatingSitePhotoDetails.Show = true
				objIsAnimatingSitePhotoDetails.Hide = false
				
				// Stop any existing animation and show the details.
				$( "#hitchhike-photo-details" ).animate({	bottom: objBottomProperties.Max	},
					{
						duration: 150,
						
						// When complete, flag all animations as being done.
						complete: function(){
							objIsAnimatingSitePhotoDetails.Show = false
							objIsAnimatingSitePhotoDetails.Hide = false
						}
					}
					)
			}
		}
		
		
		// I hide the site photo details.
		function HideSitePhotoDetails(){
			// When mousing down, set the animation flags.
			objIsAnimatingSitePhotoDetails.Show = false
			objIsAnimatingSitePhotoDetails.Hide = true
		
			// Slide details down.
			$( "#hitchhike-photo-details" ).animate(
			  { bottom: objBottomProperties.Min	},
				{
					duration: 100,
					// When complete, flag all animations as being done.
					complete: function(){
						objIsAnimatingSitePhotoDetails.Show = false
						objIsAnimatingSitePhotoDetails.Hide = false
					}
				}).fadeTo( 1, 1 )
		}
		
		// I handle the mouse over functionality for both the photo and 
		// the photo details as they are going to act in the same fashion.
		function SitePhotoMouseOverHandler(){
			// Clear any mouse out time out so that our details don't disaapear.
			clearTimeout( objMouseOutTimeout )
			
			// Show the photo details.
			ShowSitePhotoDetails()
			
		}
		
		
		// I handle the mouse out functionality for both the photo and 
		// the photo details as they are going to act in the same fashion.
		function SitePhotoMouseOutHandler(){
			// Because of the way that events happen, set a timeout for this mouse
			// out action. This will give the mouse-over action a change to 
			// cancel the bubble.
			objMouseOutTimeout = setTimeout(
				function(){
					HideSitePhotoDetails()
				},
				100
				)
		}
		
		
		function GetDistance( distance ){
		  if (distance > 0){
        return distance / 1000 + " km</dd>" 
      } else {
        return "unknown distance" 
      }
		}

		function SetNewSitePhotoDetails( data ){
      // Set src of Photo
      $( "#hitchhike-photo-photo" ).attr({
    		src: data.photo.small,
    		alt: data.title,
    		rel: data.id
    	})

      // Add Title to Photo
      $( "#site-photo-details-description" ).html( "From " + data.from + " to " + data.to + " with " + data.rides + " rides")
      $("#site-photo-distance").html(GetDistance(data.distance) + " by <a href='/hitchhikers/"+data.username+"'>" +
                                    data.username + "</a>")
      
      // Add Large Photo Link
      $( "#site-photo-details-link" ).attr("href", data.photo.large)	

      // Adding People to Description:
    	// Update the hitchhike-description. In order to do that, we have to build up the elements.
    	// Start out by clearing what's there.
      $('#hitchhike-story').empty()
      
      var arrParts = []

      // Add start LI (with potential class).
      arrParts.push( "<dl>" )

        if (data.person != null) {
          // Add name if it exists
          if (data.person.name != null && data.person.name.length){
            arrParts.push( "<dt>Name</dt><dd>" + data.person.name + "</dd>" )
          }
          // Add Occupation if it exists.
          if (data.person.occupation != null && data.person.occupation.length){
            arrParts.push( "<dt>Occupation</dt><dd>" + data.person.occupation + "</dd>" )
          }
          
          // Add Mission if it exists.
          if (data.person.mission != null && data.person.mission.length){
            arrParts.push( "<dt>Mission</dt><dd>" + data.person.mission + "</dd>" )
          }
          // Add Origin if it exists.
          if (data.person.origin != null && data.person.origin.length){
            arrParts.push( "<dt>Origin</dt><dd> " + data.person.origin +"</dd>")
          }
        }

           // Add Story if it exists.
           if (data.story != null){
             var converter = new Showdown.converter()
             var story = converter.makeHtml(data.story)
             
             $('#hitchhike-story').html( "<h1>" + data.title + "</h1>" +
                                         "<span id='hitchhike-subtitle'>By " + 
                                         "<a href='/hitchhikers/"+data.username+"'>" +
                                         data.username + "</a> &nbsp;&nbsp;&nbsp;&nbsp;" +
                                         data.date + " &nbsp;&nbsp;&nbsp;&nbsp;" + GetDistance(data.distance) + "</span>" + 
                                         "<p>" + story + "</p>" )
           }
           
           // Add closing LI.
           arrParts.push( "</dl>" )
    }

    
		// I handle the mouse over of the photo area.
		$( [] ).add( $( "#hitchhike-photo" ) ).add( $( "#hitchhike-photo-details" ) ).mouseover(
			function(){
				SitePhotoMouseOverHandler()
				return( false )
			})
		
		// I handle the mouse out of the photo area.
		$( [] ).add( $( "#hitchhike-photo" ) ).add( $( "#hitchhike-photo-details" ) ).mouseout(
			function(){
				SitePhotoMouseOutHandler()
				return( false )
			})
	})
