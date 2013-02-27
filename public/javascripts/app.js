$(function() {
  var source = new EventSource('/world');

  source.onopen = function() { console.log('connection opened'); };
  source.onclose = function() { console.log('connection opened'); };

  source.onmessage = function(e) {
    $('#world').empty();

    var worms = $.parseJSON(e.data);
    $.each(worms, function(i, worm) {
      draw_worm(worm);
    });
  };
});

function draw_worm(points) {
  $.each(points, function(i, point) {
    var element;
    var x = point[0];
    var y = point[1];

    if (i == 0) {
      element = $('<div class="point head"></div>');
    }
    else {
      element = $('<div class="point"></div>');
    }

    element.css({top: y, left: x}).appendTo('#world');
  });
}
