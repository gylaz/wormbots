$(document).ready(function() {
  var source = new EventSource('/world');

  source.addEventListener('open', function(e) {
    console.log('connection opened');
  }, false);

  source.onmessage = function(e) {
    //console.log(e.data);
    $('#world').empty();

    points = $.parseJSON(e.data);
    $.each(points, function(i, point) {
      x = point[0]*2;
      y = point[1]*2;
      $('<div class="point"></div>').css({top: y, left: x}).appendTo('#world');
    });
  };

  source.addEventListener('error', function(e) {
    if (e.eventPhase == EventSource.CLOSED) {
      console.log('connection closed');
    }
  }, false);
});
