$(function() {
  var source = new EventSource('/world');
  var canvas = document.getElementById('world');
  var context = canvas.getContext('2d');

  $.timeago.settings.strings.suffixAgo = 'since the world began';
  $('.timeago').timeago();

  source.onopen = function() { console.log('connection opened'); };
  source.onclose = function() { console.log('connection opened'); };

  source.onmessage = function(e) {
    var worms = $.parseJSON(e.data);

    canvas.width = canvas.width;
    $('#stats #worms .counter').text(worms.length);

    worms.forEach(function(worm) {
      moveHeadToLastPosition(worm.points);

      worm.points.forEach(function(point) {
        drawPoint(context, point, worm.fertile, worm.alive);
      });
    });
  };
});

function drawPoint(context, point, isFertile, isAlive) {
  var opacity = '1';
  var rgbRange = '200, 86, 86';

  if(point.head) {
    rgbRange = '38, 5, 6';
  } else if(isFertile) {
    rgbRange = '186, 4, 4';
  }

  if(!isAlive) {
    opacity = '0.5';
  }

  context.fillStyle = 'rgba(' + rgbRange + ', ' + opacity + ')';
  context.fillRect(point.x, point.y, 2, 2);
}

function moveHeadToLastPosition(points) {
  var head = points.shift();
  points.push(head);
}
