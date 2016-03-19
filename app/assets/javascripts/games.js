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
      var row = $(this).data('row');
      var column = $(this).data('column');
      var pieceId = ui.helper[0].dataset.pieceId;
      var moveData = {
        'row': row,
        'column': column,
        'piece_id': pieceId
      }
      console.log(moveData);
    }
  });

});
