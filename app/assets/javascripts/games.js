// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function(){
  var posStack = [];
  var coordinates = function(element) {
      element = $(element);
      var top = element.position().top;
      var left = element.position().left;
      $('#results').text('X: ' + left + ' ' + '   Y: ' + top);
      posStack.push({x:left,y:top});
  }
  $('.piece').draggable({grid:[60, 60], containment: '#chessboard'});
  $('.space').droppable({
    drop: function(event, ui){
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
    // Empty messages.
    $('#messages').empty();
    put.done(function(data){
      // Remove any captured_piece from the DOM
      $('#piece-' + data.captured_piece).detach();
      $.each(data.moved_pieces, function(i, val){
        // This moves any moved pieces to the correct place.
        $('#square-'+val.x_coordinate+'-'+val.y_coordinate).append($('#piece-'+val.id))
        // This removes the styling added by the draggable feature, so that a failed move
        // is returned to it's original square.
        $('.piece').css({'left': 0, 'top': 0});
      });
      $.each(data.check_status, function(i, val){
        addCheckMessages(i, val);
      });

      if(data.pawn_promotion) {
        pawnPromotionDialog(data.moved_pieces[0].id);
      }
    });
  }

  var addCheckMessages = function(i, val){
    // If a check or checkmate is found.
    if (val) {
      // Capitalize the first letter.
      str = i.charAt(0).toUpperCase() + i.slice(1);
      // Print message to screen.
      $('#messages').append('<h3>'+str+' player is in '+val+'</h3>')
    }
  }

  var pawnPromotionDialog = function(id) {
    $('#pawn-promotion').dialog({
      text: "OK",
      modal: true,
      closeOnEscape: false,
      draggable: false,
      width: 'auto',
      buttons: [
        {
          text: 'Queen',
          value: 'Queen',
          click: function(button){
            type = button.currentTarget.value;
            promoteModalButtonClick(type, id);
          }
        },
        {
          text: 'Rook',
          value: 'Rook',
          click: function(button){
            type = button.currentTarget.value;
            promoteModalButtonClick(type, id);
          }
        },
        {
          text: 'Bishop',
          value: 'Bishop',
          click: function(button){
            type = button.currentTarget.value;
            promoteModalButtonClick(type, id);
          }
        },
        {
          text: 'Knight',
          value: 'Knight',
          click: function(button){
            type = button.currentTarget.value;
            promoteModalButtonClick(type, id);
          }
        }
      ]
    });
  }

  var promoteModalButtonClick = function(val, id) {
    var url = '/pieces/' + id + '/promote';

    var promotion = $.ajax({
      method: 'PUT',
      url: url,
      data: {type: val},
      dataType: 'json'
    });
    $('#pawn-promotion').dialog('close');

    promotion.done(function(data){
      var promoteType = data.piece.type;
      promoteType = promoteType.charAt(0).toLowerCase() + type.slice(1);
      if(promoteType === 'rook') {
        promoteType = 'tower';
      }
      if(data.success){
        $('#piece-' + data.piece.id).removeClass('glyphicon-pawn').addClass('glyphicon-' + promoteType);
        $('#messages').empty();
        $.each(data.check_status, function(i, val){
          addCheckMessages(i, val);
        });
      }
    });
  }
});
