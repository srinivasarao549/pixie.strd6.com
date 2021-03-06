window.clearErrorMessages = (errors) ->
  if $('.ui-pnotify').length
    $.pnotify_remove_all()

window.displayError = (error) ->
  $.pnotify
    pnotify_animation: 'none'
    pnotify_title: error.title || 'Compile Error'
    pnotify_text: '<div class="file error" data-id=' + error.fileId + '>In file: <b>' + error.file + '</b>\n' + error.message + '</div>'
    pnotify_type: 'error'
    pnotify_hide: false
    pnotify_history: false

window.displayRuntimeError = (message) ->
  $.pnotify
    pnotify_animation: 'none'
    pnotify_title: 'Runtime Error'
    pnotify_text: message
    pnotify_type: 'error'
    pnotify_hide: false
    pnotify_history: false
