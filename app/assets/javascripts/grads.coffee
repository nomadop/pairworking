# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $("#grad_photo").ready () ->
    $("#grad_photo").change () ->
      try
        console.log(this)
        filename = this.files[0].name
        dot_index = filename.indexOf('.')
        $("#grad_name")[0].value = filename.charAt(0).toUpperCase() + filename.slice(1, dot_index)
      catch e
        console.log(e)
	
