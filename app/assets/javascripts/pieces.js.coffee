# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready -> 
	$(".piece").draggable({grid:[59,59], containment: "#chessboard"})
	$(".square").droppable()

	$ -> 
	  $(".square").on 'drop', (e) ->
	  	$.post '/pieces/', () ->
  		$('.result').html data
  		return

	return
	