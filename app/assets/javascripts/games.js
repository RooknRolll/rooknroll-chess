$(document).ready(function(){
 
   $(".piece").draggable({
        grid:[59,59], 
        containment: '#chessboard',
        revert: "invalid",
        stop: function( event, ui ) {
          $('.space').droppable({
                      accept: function(){
                      return false;
                      }
                  });
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
            console.log(ui);
           $.ajax({
             method: 'PUT',
             url: url,
             data: moveData,
             dataType: 'json'
           }).done(function(piece){
              console.log(piece.valid_move);
             if(piece.valid_move){
                  $('.space').droppable({
                      accept: function(){
                        return true
                      }
                  });
             }
           });  
       }
   });
 
 });