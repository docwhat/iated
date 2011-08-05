/* Defaults for ajax requests. */
$.ajaxSetup({
    cache: true
});

function hello() {
    $.getJSON('http://localhost:9090/hello', function (data) {
	    console.log("GET /hello: %o", data);
    })
}

function secret() {
    var data={secret: $('#secret').val()};
    $.post('http://localhost:9090/hello', data, function (data, textStatus, jqXHR) {
	    console.log("POST /hello: %o %o %o", data, textStatus, jqXHR);
        $('#token').val(data.token);
        token=data.token;
    })
}

function edit() {
    var text, tid, url, extension;
    tid = "#text";
    text = $(tid).val();
    url = window.location;
    extension = '.txt';

    var data={
        tid:       "#text",
        text:      $("#text").val(),
        url:       window.location.toString(),
        extension: $('#extension').val(),
        token: $("#token").val(),
    };

    $.post('http://localhost:9090/edit', data, function (data, textStatus, jqXHR) {
	console.log("POST /edit: %o %o %o", data, textStatus, jqXHR);
	$('#sid').val(data.sid);
	$('#change-id').val(data.change_id ? data.change_id : 0);
    })
}

function update() {
    $.getJSON('http://localhost:9090/edit/' + $('#sid').val() + "/" + $("#change-id").val(), function (data) {
	console.log("GET /edit/:sid/:change-id: %o", data);
	if (data.change_id && data.change_id.toString() !== $('#change-id').val()) {
	    $('#text').val(data.text);
	    $('#change-id').val(data.change_id);
	}
    });
}

$(document).ready( function init() {
    $("#hello-btn").click(hello);
    $("#secret-btn").click(secret);
    $("#edit-btn").click(edit);
    $("#update-btn").click(update);
});


