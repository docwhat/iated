/* Defaults for ajax requests. */
$.ajaxSetup({
    cache: true
});

var token=null;

function hello() {
    $.getJSON('http://localhost:9090/hello', function (data) {
	    console.log("NARF: %o", data);
    })
}

function secret() {
    var data={secret: $('#secret').val()};
    $.post('http://localhost:9090/hello', data, function (data, textStatus, jqXHR) {
	    console.log("NARFtoken: %o %o %o", data, textStatus, jqXHR);
        $('#token').text(data.token);
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
        extension: '.txt',
        token: token,
    };
    console.log("NARF %o", data);

    $.post('http://localhost:9090/edit', data, function (data, textStatus, jqXHR) {
	    console.log("NARFedit: %o %o %o", data, textStatus, jqXHR);
    })
}

$(document).ready( function init() {
    $("#hello-btn").click(hello);
    $("#secret-btn").click(secret);
    $("#edit-btn").click(edit);
});


