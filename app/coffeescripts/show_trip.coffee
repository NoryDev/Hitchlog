$(document).ready ->
  init_map({draggable: false})
  set_new_route($("#trip_route").val())
  $('#slider').nivoSlider
    # effect: 'fade', # Specify sets like: 'fold,fade,sliceDown'
    # pauseTime: 3000, # How long each slide will show
    # startSlide: 0, # Set starting Slide (0 index)
    # directionNav: true, # Next & Prev navigation
    # directionNavHide: true, # Only show on hover
    controlNav: false # 1,2,3... navigation
    # controlNavThumbs: false, # Use thumbnails for Control Nav
    # controlNavThumbsFromRel: false, # Use image rel for thumbs
    # controlNavThumbsSearch: '.jpg', # Replace this with...
    # controlNavThumbsReplace: '_thumb.jpg', # ...this in thumb Image src
    # keyboardNav: true, # Use left & right arrows
    # pauseOnHover: true, # Stop animation while hovering
    # manualAdvance: false, # Force manual transitions
    # captionOpacity: 0.8, # Universal caption opacity
    # prevText: 'Prev', # Prev directionNav text
    # nextText: 'Next', # Next directionNav text
    # randomStart: false, # Start on a random slide
    # beforeChange: function(){}, # Triggers before a slide transition
    # afterChange: function(){}, # Triggers after a slide transition
    # slideshowEnd: function(){}, # Triggers after all slides have been shown
    # lastSlide: function(){}, # Triggers when last slide is shown
    # afterLoad: -> # Triggers when slider has loaded
  if $("#slider img").size() == 1
    $('#slider').data('nivoslider').stop(); # Stop the Slider
    $(".nivo-directionNav").remove()
