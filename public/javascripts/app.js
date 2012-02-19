$(document).ready(function() {
  var source = new EventSource('/world');

  source.addEventListener('open', function(e) {
    console.log('connection opened');
  }, false);

  source.onmessage = function(e) {
    //console.log(e.data);
    x = $.parseJSON(e.data)[1];
    y = $.parseJSON(e.data)[0];
    size = $.parseJSON(e.data)[2];
    width = parseInt($('.worm').css('width'));
    $('.worm').css('top', x);
    $('.worm').css('left', y);
    $('.worm').css('width', size);
    $('.worm').show();
  };

  source.addEventListener('error', function(e) {
    if (e.eventPhase == EventSource.CLOSED) {
      console.log('connection closed');
    }
  }, false);
});
