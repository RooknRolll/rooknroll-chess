// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
  $('.piece').draggable({grid:[59,59], containment: '#chessboard'});
  $('.space').droppable({
    drop: function(event, ui){
      // This line hides any pieces you capture. Before I added it, capture
      // attempts looked bad as one piece just sat on top of the other while
      // the database validated the move.
      $(this.children).hide();
      // 'this' refers to the space that you are moving to
      var row = $(this).data('row');
      var column = $(this).data('column');
      // Find the id of the dropped piece.
      var pieceId = ui.helper[0].dataset.pieceId;
      // Set the parameters to be sent to the controller.
      var moveData = {
        'x_coordinate': column,
        'y_coordinate': row
      },
      // Set the url to which the data is sent.
      url = '/pieces/' + pieceId;
      move(url, moveData);
    }
  });
  var move = function(url, moveObject){
    var put = $.ajax({
      method: 'PUT',
      url: url,
      data: moveObject,
      dataType: 'json'
    });
    // Once the ajax post is complete, refresh the page.
    // I would like to change this part to something better.
    put.done(function(){
      location.reload()
    });
  };
});
