$(function() {
  var world = $('#world');
  var source = new EventSource('/world');

  $.timeago.settings.strings.suffixAgo = 'since the world began';
  $('.timeago').timeago();

  source.onopen = function() { console.log('connection opened'); };
  source.onclose = function() { console.log('connection opened'); };
  source.onmessage = function(e) {
    var worms = $.parseJSON(e.data);
    var wormElements = [];

    $('#stats #worms .counter').text(worms.length);
    $.each(worms, function(i, worm) {
      $.each(worm.points, function(index, point) {
        var pointElement = generatePointElement(point, index, worm.fertile, worm.alive);
        wormElements.push(pointElement[0]);
      });
    });

    world.html(wormElements);
  };
});

function generatePointElement(point, index, isFertile, isAlive) {
  var pointElement = $('<div class="point"></div>');
  var x = point[0];
  var y = point[1];

  if(index == 0) {
    pointElement.addClass('head');
  } else if(isFertile) {
    pointElement.addClass('fertile');
  }

  if(!isAlive) {
    pointElement.addClass('dead');
  }

  return pointElement.css({top: y, left: x});
}
