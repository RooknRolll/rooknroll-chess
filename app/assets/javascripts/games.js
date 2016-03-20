// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/
// $(document).ready ->
// 	$(".piece").draggable({grid:[59,59], containment: "#chessboard"})
// 	$(".square").droppable()
//
//
// 	$(".square").on 'drop', (e, ui) ->
//     console.log(ui)
//     console.log("Drop!")
// 	  	# $.post '/pieces/', () ->
//   		# $('.result').html data
//   	return
//
// return

$(document).ready(function(){
  $('.piece').draggable({grid:[59,59], containment: '#chessboard'});
  $('.space').droppable({
    drop: function(event, ui){
      $(this.children).hide();
      var row = $(this).data('row');
      var column = $(this).data('column');
      var pieceId = ui.helper[0].dataset.pieceId;
      var moveData = {
        'x_coordinate': column,
        'y_coordinate': row
      },
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

    put.done(function(){
      location.reload()
    });  
  };
});
