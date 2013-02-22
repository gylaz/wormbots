$(function() {
  var socketUrl = 'ws://' + window.location.host + '/world';
  var socket = new WebSocket(socketUrl);

  socket.onopen = function() { console.log('connection opened'); };
  socket.onclose = function() { console.log('connection opened'); };

  socket.onmessage = function(e) {
    $('#world').empty();

    worms = $.parseJSON(e.data);
    $.each(worms, function(i, worm) {
      draw_worm(worm);
    });
  };
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
