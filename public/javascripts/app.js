$(document).ready(function() {
  var source = new EventSource('/world');

  source.addEventListener('open', function(e) {
    console.log('connection opened');
  }, false);

  source.onmessage = function(e) {
    $('#world').empty();

    worms = $.parseJSON(e.data);
    $.each(worms, function(i, worm) {
      draw_worm(worm);
    });
  };

  source.addEventListener('error', function(e) {
    if (e.eventPhase == EventSource.CLOSED) {
      console.log('connection closed');
    }
  }, false);
});

function draw_worm(points) {
  $.each(points, function(i, point) {
    //console.log(point);
    
    x = point[0];
    y = point[1];
    if (i == 0) {
      $('<div class="point head"></div>').css({top: y, left: x}).appendTo('#world');
    }
    else {
      $('<div class="point"></div>').css({top: y, left: x}).appendTo('#world');
    }
  });
}
