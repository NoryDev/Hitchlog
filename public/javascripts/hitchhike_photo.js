// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(
	function(){
		// Get DOM references.
		var jPhotoArea = $( "#hitchhike-photo" );
		var jPhoto = $( "#hitchhike-photo-photo" );
		var jPhotoDetails = $( "#hitchhike-photo-details" );
		var jHitchhikeDetails = $( "#hitchhike-details" );
		var jPhotoDescription = $( "#site-photo-details-description" );
		var jPhotoLink = $( "#site-photo-details-link" );
		var jPhotoContacts = $( "#site-photo-details-contacts" );
		var jPhotoLeft = $( "#hitchhike-photo-left" );
		var jPhotoRight = $( "#hitchhike-photo-right" );
		var jAjaxLoader = $( "#hitchhike-photo-loader" );
		
		// Keep track of properties of the photo details.
		var objBottomProperties = {
			Min: "-98px",
			Max: "0px"
			};
		
		// The timer for mouseing out of the site photo area.
		var objMouseOutTimeout = null;
		
		// Keep track of which direction we are animating in.
		var objIsAnimatingSitePhotoDetails = {
			Show: false,
			Hide: false
			};
			
		// Keep track of site photo XHR request.
		var objSitePhotoRequest = null;
		
		
		
    // GOOGLE MAPS:
    
    // I initiate the Map and associate it with the #map_canvas div
    // Because it is necessary to define a start location i just chose
    // my home locatino and set the zoom level to 1.
    var startlocation = new google.maps.LatLng(51.850033, 10.6500523);
    var myOptions = {
      zoom: 1,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: startlocation
    }
    
    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    // I get the DirectionServices from the Google Maps API V3.
    var directionsDisplay = new google.maps.DirectionsRenderer();
    var directionsService = new google.maps.DirectionsService();
    directionsDisplay.setMap(map);

    
    // I execute this function whenever the routes need to be set again
    function SetNewRoute(from, to) {
      var start = from;
      var end = to;
      var request = {
          origin: start, 
          destination: end,
          travelMode: google.maps.DirectionsTravelMode.DRIVING
      };
      directionsService.route(request, function(response, status) {
        if (status == google.maps.DirectionsStatus.OK) {
          directionsDisplay.setDirections(response);
        }
      });
    }
    
    $.getJSON("/hitchhikes.json", function(data){
      SetNewSitePhotoDetails(data)      
      SetNewRoute(data.from, data.to)      
    });
		
		// I show the site photo details (if necesssary).
		function ShowSitePhotoDetails(){
			// We only want to animate the Show if we are:
			// 1. Not currently showing the photo details.
			// 2. Currently hiding the photo details.
			if (
				!objIsAnimatingSitePhotoDetails.Show ||
				objIsAnimatingSitePhotoDetails.Hide
				){
				
				// Check to see if we need to stop any animation.
				if (objIsAnimatingSitePhotoDetails.Hide){
					jPhotoDetails.stop();
				}
				
				// Flag the animations.
				objIsAnimatingSitePhotoDetails.Show = true;
				objIsAnimatingSitePhotoDetails.Hide = false;
				
				// Stop any existing animation and show the details.
				jPhotoDetails.animate(
					{
						bottom: objBottomProperties.Max
					},
					{
						duration: 150,
						
						// When complete, flag all animations as being done.
						complete: function(){
							objIsAnimatingSitePhotoDetails.Show = false;
							objIsAnimatingSitePhotoDetails.Hide = false;
						}
					}
					);
			}
		}
		
		
		// I hide the site photo details.
		function HideSitePhotoDetails(){
			// When mousing down, set the animation flags.
			objIsAnimatingSitePhotoDetails.Show = false;
			objIsAnimatingSitePhotoDetails.Hide = true;
		
			// Slide details down.
			jPhotoDetails
				.animate(
					{
						bottom: objBottomProperties.Min
					},
					{
						duration: 100,
						
						// When complete, flag all animations as being done.
						complete: function(){
							objIsAnimatingSitePhotoDetails.Show = false;
							objIsAnimatingSitePhotoDetails.Hide = false;
						}
					}
					)
				.fadeTo( 1, 1 )
			;
		}
		
		
		// I show the prev/next links.
		function ShowPrevNextArrows(){
			jPhotoLeft.show();
			jPhotoRight.show();
		}
		
		
		// I hide the prev/next links.
		function HidePrevNextArrows(){
			jPhotoLeft.hide();
			jPhotoRight.hide();
		}
		
		
		// I handle the mouse over functionality for both the photo and 
		// the photo details as they are going to act in the same fashion.
		function SitePhotoMouseOverHandler(){
			// Clear any mouse out time out so that our details don't disaapear.
			clearTimeout( objMouseOutTimeout );
			
			// Show the photo details.
			ShowSitePhotoDetails();
			
			// Show prev / next arrows.
			ShowPrevNextArrows();
		}
		
		
		// I handle the mouse out functionality for both the photo and 
		// the photo details as they are going to act in the same fashion.
		function SitePhotoMouseOutHandler(){
			// Because of the way that events happen, set a timeout for this mouse
			// out action. This will give the mouse-over action a change to 
			// cancel the bubble.
			objMouseOutTimeout = setTimeout(
				function(){
					HideSitePhotoDetails();
					HidePrevNextArrows();
				},
				100
				);
		}
		
		
		// I get the next site photo.
		function GetNextSitePhoto(){
			// Get next photo.
			GetNewSitePhotoDetails( "getnext" );
		}
		
		
		// I get the previous site photo.
		function GetPreviousSitePhoto(){
			// Get next photo.
			GetNewSitePhotoDetails( "getprev" );
		}
		
		function GetDistance( distance ){
		  if (distance > 0){
        return distance / 1000 + " km</dd>" 
      } else {
        return "unknown distance" 
      }
		}
		
		// I get the new site photo (prev and next) base on given action.
		function GetNewSitePhotoDetails( strAction ){
			// Check to see if there is a current request. If so, then return out
			// as we don't want to do anything until the request returns.
			if (objSitePhotoRequest){
				return;
			}
			
			// Show ajax loader.
			jAjaxLoader.fadeIn( 100 );
      // Fade out Hitchhike details
      jHitchhikeDetails.fadeOut(100);
			
			// Get the new photo (be sure to store request).
			if (strAction == "getnext"){
			  next = jPhotoRight.attr( "rel" )
			} else if (strAction == "getprev"){
			  next = jPhotoLeft.attr( "rel" )
			}
      
      
			objSitePhotoRequest = $.ajax(
				{	method: "get",
					url: ("/hitchhikes.json"),
					data: {
					  id: next
					},
					dataType: "json",
					
					// Handle the response.
					success: function( objResponse ){
					  SetNewSitePhotoDetails( objResponse )
						// fade in details.
            jHitchhikeDetails.fadeIn();
            
            SetNewRoute( objResponse.from, objResponse.to )
					},
					// If the request errored, something went seriously wrong!
					error: function(){
						alert( "There was an error getting the photo!!!" );
					},
					complete: function(){
						// Clear the request no matter what.
						objSitePhotoRequest = null;
						
						// Hide ajax loader.
						jAjaxLoader.stop().fadeOut();
					}
				}
				);
		}

		function SetNewSitePhotoDetails( data ){
      // Set src of Photo
      jPhoto.attr({
    		src: data.photo.small,
    		alt: data.title,
    		rel: data.id
    	});
    	jPhotoLeft.attr("rel", data.prev)
      jPhotoRight.attr("rel", data.next)

      // Add Title to Photo
      jPhotoDescription.html( "From " + data.from + " To " + data.to)
      $("#site-photo-distance").html(GetDistance(data.distance))
      
      // Add Large Photo Link
      jPhotoLink.attr("href", data.photo.large)	

      // Adding People to Description:
    	// Update the hitchhike-description. In order to do that, we have to build up the elements.
    	// Start out by clearing what's there.
    	jHitchhikeDetails.empty();
      $('#hitchhike-story').empty()
      
      var arrParts = [];

      // Add start LI (with potential class).
      arrParts.push( "<dl>" );

          // // Add distance
          // if (data.distance){
          //   arrParts.push( "<dt>Distance</dt><dd>" + GetDistance(data.distance) + "</dd>" );
          // }

          // Add name if it exists
          if (data.person.name.length){
            arrParts.push( "<dt>Name</dt><dd>" + data.person.name + "</dd>" );
          }
          // Add Occupation if it exists.
          if (data.person.occupation.length){
            arrParts.push( "<dt>Occupation</dt><dd>" + data.person.occupation + "</dd>" );
          }
          
          // Add Mission if it exists.
          if (data.person.mission.length){
            arrParts.push( "<dt>Mission</dt><dd>" + data.person.mission + "</dd>" );
          }
          // Add Origin if it exists.
          if (data.person.origin.length){
            arrParts.push( "<dt>Origin</dt><dd> " + data.person.origin +"</dd>");
          }

           // Add Story if it exists.
           if (data.story != null){
             var converter = new Showdown.converter();
             var story = converter.makeHtml(data.story);
             
             $('#hitchhike-story').html( "<h1>" + data.title + "</h1>" +
                                         "<span id='hitchhike-subtitle'>By " + 
                                         "<a href='/users/"+data.username+"'>" +
                                         data.username + "</a> &nbsp;&nbsp;&nbsp;&nbsp;" +
                                         data.date + " &nbsp;&nbsp;&nbsp;&nbsp;" + GetDistance(data.distance) + "</span>" + 
                                         "<p>" + story + "</p>" );
           }
           
           // Add closing LI.
           arrParts.push( "</dl>" );
           // Add item to list.
           jHitchhikeDetails.append( arrParts.join( "" ) );
    }

		
		// Initialize the left photo arrow.
		jPhotoLeft
			.attr( "href", "javascript:void( 0 )" )
			.click(
				function(){
					GetPreviousSitePhoto();
					return( false );
				}
				)
		;
		
		// Initialize the right photo arrow.
		jPhotoRight
			.attr( "href", "javascript:void( 0 )" )
			.click(
				function(){
					GetNextSitePhoto();
					return( false );
				}
				)
		;
		
		// Initialized mouse over / out for left / right.
		$ ( [] ).add( jPhotoLeft ).add( jPhotoRight )
			.mouseover(
				function(){
					jPhotoDetails.fadeTo( "fast", .3 );
				}
				)
			.mouseout(
				function(){
					jPhotoDetails.fadeTo( "fast", 1 );
				}
				)
		;
		
		
		// I handle the mouse over of the photo area.
		$( [] ).add( jPhotoArea ).add( jPhotoDetails ).add( jPhotoLeft ).add( jPhotoRight ).mouseover(
			function(){
				SitePhotoMouseOverHandler();
				return( false );
			}
			);
		
		// I handle the mouse out of the photo area.
		$( [] ).add( jPhotoArea ).add( jPhotoDetails ).add( jPhotoLeft ).add( jPhotoRight ).mouseout(
			function(){
				SitePhotoMouseOutHandler();
				return( false );
			}
			);
	}
	);
