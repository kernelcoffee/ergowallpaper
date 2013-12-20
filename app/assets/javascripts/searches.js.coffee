# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $(".search-options").multiselect
    buttonClass: "input-group-addon search"
    buttonWidth: "auto"
    buttonContainer: "<div class=\"btn-group\" />"
    maxHeight: false
    buttonText: (options) ->
      if options.length is 0
        "Options <b class=\"caret\"></b>"
      else if options.length > 3
         options.length + " selected <b class=\"caret\"></b>"
      else
        selected = ""
        options.each ->
          selected += $(this).text() + ", "

        selected.substr(0, selected.length - 2) + " <b class=\"caret\"></b>"

  $(".search-resolutions").multiselect
    buttonClass: "input-group-addon search"
    buttonWidth: "auto"
    buttonContainer: "<div class=\"btn-group\" />"
    maxHeight: 400
    buttonText: (options) ->
      if options.length is 0
        "Options <b class=\"caret\"></b>"
      else if options.length > 3
         options.length + " selected <b class=\"caret\"></b>"
      else
        selected = ""
        options.each ->
          selected += $(this).text() + ", "

        selected.substr(0, selected.length - 2) + " <b class=\"caret\"></b>"

  $('#search_color').minicolors();