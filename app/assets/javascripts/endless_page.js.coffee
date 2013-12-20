jQuery ->
  onEndless = ->
    $(window).off 'scroll', onEndless
    url = $('.pagination .next a').attr('href')
    $('.pagination').hide()
    if url && $(window).scrollTop() > $(document).height() - $(window).height() - 300
      $.getScript url, ->
        $(window).on 'scroll', onEndless
    else
      $(window).on 'scroll', onEndless
  $(window).on 'scroll', onEndless  
  $(window).scroll()

  $(window).ready ->
    $(window).scroll()