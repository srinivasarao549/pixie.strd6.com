(($) ->
  $.fn.vectorPicker = ->
    input = this.eq(0)

    SIZE = 126
    RADIUS = 5

    mouseHeld = false

    setVector = (x, y) ->
      [xTranslate, yTranslate] = [x, y].map (value) ->
        ((value - SIZE / 2) / 5).round()

      input.val(JSON.stringify({ x: xTranslate, y: yTranslate }))
      $('.unit_circle').css
        backgroundPosition: "#{x - RADIUS}px #{y - RADIUS}px"

    showDialog = ->
      dialog = $ '<div />',
        class: "vector_picker"

      $('<div class="unit_circle" />').bind(
        mousedown: (e) ->
          setVector(e.offsetX, e.offsetY)
          mouseHeld = true
        mousemove: (e) ->
          if mouseHeld
            setVector(e.offsetX, e.offsetY)
        mouseup: ->
          $(input).focus()
          mouseHeld = false
      ).appendTo(dialog)

      offset = input.offset()
      height = input.get(0).offsetHeight

      dialog.css
        left: offset.left
        top: offset.top + height

      $('body').append(dialog)

    input.bind
      blur: ->
        $('.vector_picker').remove() unless mouseHeld
      focus: ->
        showDialog() unless $('.vector_picker').length

        try
          obj = JSON.parse(input.val())
        catch e
          obj = null
        $('.unit_circle').css
          backgroundPosition: "#{5*obj.x + (SIZE / 2) - RADIUS}px #{5*obj.y + (SIZE / 2) - RADIUS}px" if obj
)(jQuery)
