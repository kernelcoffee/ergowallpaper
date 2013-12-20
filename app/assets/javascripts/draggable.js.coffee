jQuery ->
  $thumbs = $(".thumbnail")
  $albums = $(".album_menu")

  $thumbs.draggable
    opacity: 0.20
    helper: "clone"
    cursor: 'move'
    revert: 'invalid'
   
  $albums.droppable
    hoverClass: "drag"
    tolerance: 'pointer',
    drop: (event, ui) ->
      $currentId = $(ui.draggable).attr('id')
      $.post($(this).data('add-url'), {id: $(this).data('id') ,wallpaper_id: $currentId})
