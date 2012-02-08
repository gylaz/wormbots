$(document).ready(function(){
  var source = new EventSource('/world');

  // new connection opened callback
  source.addEventListener('open', function(e) {
    console.log('connection opened');
  }, false);

  // subscribe to unnamed messages
  source.onmessage = function(e) {
    console.log(e);
    document.getElementById('world').innerHTML = e.data;
  };

  // listen for signup events
  source.addEventListener('signup', function(e) {
    console.log(e);
    document.body.innerHTML += e.data + '<br />';
  }, false);

  // connection closed callback
  source.addEventListener('error', function(e) {
    if (e.eventPhase == EventSource.CLOSED) {
      console.log('connection closed');
    }
  }, false);
});