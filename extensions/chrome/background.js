/** The base URL for requests.
 */
var base_url = 'http://127.0.0.1:9090/';

/** Initialize the background handlers.
 */
function init() {
    console.debug('IAT background loading...');

    /* Defaults for ajax requests. */
    $.ajaxSetup({
	cache: false
    });

    /* Set up the listener. */
    chrome.extension.onRequest.addListener(onRequest);

    console.debug('IAT background loaded.');
}

/** Handles an edit request.
 */
function edit(text, callback) {
    $.ajax({
	url: base_url + 'edit',
	type: 'POST',
	data: { text : text },
	dataType: 'text',
	success: function (token, textStatus) {
	    callback(token);
	},
	error: function (jqXHR, textStatus, errorThrown) {
	    console.error("edit: failure: %o - %o - %o", jqXHR, textStatus, errorThrown);
	}
    });
}

/** Handles an update request.
 */
function update(token, change_id, callback) {
    $.ajax({
	url: base_url + 'edit/' + token,
	data: { change_id : change_id },
	type: 'HEAD',
	dataType: 'json',
	success: function (resp, textStatus) {
	    console.log("update: success: %o - %o", resp, textStatus);
	    if ("notmodified" !== textStatus) {
		callback(resp.text, resp.change_id);
	    }
	},
	error: function (jqXHR, textStatus, errorThrown) {
	    console.error("update: failure: %o - %o - %o", jqXHR, textStatus, errorThrown);
	}
    });
}

/** Handles request from contentscript.js
 * @param msg      Object Data sent in the request.
 * @param sender   Object Origin of the request.
 * @param callback Function The method to call when the request completes.
 */
function onRequest(msg, sender, callback) {
    if ('edit' === msg.action) {
	edit(msg.text, callback);
    } else if ('update' == msg.action) {
	update(msg.token, msg.change_id, callback);
    } else {
	console.error("Unknown msg: ", msg);
    }
};

/* Main */
init();

/* EOF */