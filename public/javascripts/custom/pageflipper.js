$(function(){
  $("#pageflip_right").hover(function() { //On hover...
    $("#pageflip_right img , #pageflip_right .msg_block").stop()
      .animate({ //Animate and expand the image and the msg_block (Width + height)
        width: '307px',
        height: '319px'
      }, 500);
    } , function() {
    $("#pageflip_right img").stop() //On hover out, go back to original size 50x52
      .animate({
        width: '50px',
        height: '52px'
      }, 220);
    $("#pageflip_right .msg_block").stop() //On hover out, go back to original size 50x50
      .animate({
        width: '50px',
        height: '50px'
      }, 200); //Note this one retracts a bit faster (to prevent glitching in IE)
  });
  $("#pageflip_left").hover(function() { //On hover...
    $("#pageflip_left img , #pageflip_left .msg_block").stop()
      .animate({ //Animate and expand the image and the msg_block (Width + height)
        width: '307px',
        height: '319px'
      }, 500);
    } , function() {
    $("#pageflip_left img").stop() //On hover out, go back to original size 50x52
      .animate({
        width: '50px',
        height: '52px'
      }, 220);
    $("#pageflip_left .msg_block").stop() //On hover out, go back to original size 50x50
      .animate({
        width: '50px',
        height: '50px'
      }, 200); //Note this one retracts a bit faster (to prevent glitching in IE)
  });
});
