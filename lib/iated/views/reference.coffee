# Defaults for ajax requests.
jQuery.ajaxSetup cache: true

# Method to highlight a change.
jQuery.fn.highlight = ->
  this.effect('highlight', 3 * 1000)

hello = () ->
  jQuery.getJSON('/hello', (data) ->
    console.log("GET /hello: %o", data)
  )

secret = () ->
  data=
    secret: $('#secret').val()
  jQuery.post('/hello', data, (data, textStatus, jqXHR) ->
    console.log("POST /hello: %o %o %o", data, textStatus, jqXHR)
    $('#token').val(data.token)
    token=data.token
  )

edit = () ->
  tid = "#text"
  text = $(tid).val()
  url = window.location.toString()
  extension = '.txt'

  data=
    tid:       "#text"
    text:      $("#text").val()
    url:       url
    extension: $('#extension').val()
    token:     $("#token").val()

  jQuery.post('/edit', data, (data, textStatus, jqXHR) ->
    console.log("POST /edit: %o %o %o", data, textStatus, jqXHR)
    $('#sid').val(data.sid).highlight()
    $('#change-id').val( if data.change_id then data.change_id else 0).highlight()
  )

edit_prev = () ->
  tid = "#text"
  url = window.location.toString()
  extension = '.text'

  data=
    tid: "#text"
    url: url
    extension: $('#extension').val()
    token: $('#token').val()

  jQuery.post('/edit', data, (data, textStatus, jqXHR) ->
    console.log("POST /edit: %o %o %o", data, textStatus, jqXHR)
    $('#sid').val(data.sid).highlight()
    $('#change-id').val(if data.change_id then data.change_id else 0).highlight()
  )

update = () ->
  jQuery.getJSON('/edit/' + $('#sid').val() + "/" + $("#change-id").val(), (data) ->
    console.log("GET /edit/:sid/:change-id: %o", data)
    if data.change_id && data.change_id.toString() != $('#change-id').val()
      $('#text').val(data.text).highlight()
      $('#change-id').val(data.change_id).highlight()
  )

preferences = () ->
  event.preventDefault()
  event.stopPropagation()
  window.open('/preferences?token=' + encodeURIComponent($('#token').val()), "iat_prefs")
  return true

jQuery ->
  $("#hello-btn").click(hello);
  $("#secret-btn").click(secret);
  $("#edit-btn").click(edit);
  $("#edit-prev-btn").click(edit_prev);
  $("#update-btn").click(update);
  $("#preferences-btn").click(preferences);

