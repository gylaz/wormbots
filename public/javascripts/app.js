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

    $('#stats #worms .counter').text(worms.length);
    canvas.width = canvas.width;

    $.each(worms, function(i, worm) {
      $.each(worm.points, function(index, point) {
        drawPoint(context, point, index, worm.fertile, worm.alive);
      });
    });
  };
});

function drawPoint(context, point, index, isFertile, isAlive) {
  var x = point[0];
  var y = point[1];
  var opacity = 1;
  var rgbRange = '201, 96, 100';

  if(isHead(index)) {
    rgbRange = '38, 5, 6';
  } else if(isFertile) {
    rgbRange = '223, 58, 1';
  }

  if(!isAlive) {
    opacity = '0.5';
  }

  context.fillStyle = 'rgba(' + rgbRange + ', ' + opacity + ')';
  console.log('rgba(' + rgbRange + ', ' + opacity + ')');
  context.fillRect(x, y, 1, 1);
}

function isHead(index) { return index == 0; }
