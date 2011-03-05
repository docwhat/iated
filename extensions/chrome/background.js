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

/** Handles request from contentscript.js
 * @param msg      Object Data sent in the request.
 * @param sender   Object Origin of the request.
 * @param callback Function The method to call when the request completes.
 */
function onRequest(msg, sender, callback) {
    if ('edit' === msg.action) {
	edit(msg.text, msg.url, msg.id, callback);
    } else if ('update' == msg.action) {
	update(msg.token, msg.change_id, callback);
    } else {
	console.error("Unknown msg: ", msg);
    }
};

/** Handles an edit request.
 * @param text
 * @param url
 * @param id
 */
function edit(text, url, id, callback) {
    var data = { text : text };
    if (url) {
	data.url = url;
    }
    if (id) {
	data.id = id;
    }
    $.ajax({
	url: base_url + 'edit',
	type: 'POST',
	data: data,
	dataType: 'text',
	success: function (token, textStatus) {
	    callback({token: token});
	},
	error: function (jqXHR, textStatus, errorThrown) {
	    console.error("edit: failure: %o - %o - %o", jqXHR, textStatus, errorThrown);
	    callback({ error: "Unable to get update from IATed" });
	}
    });
}

/** Handles an update request.
 */
function update(token, change_id, callback) {
    var url = base_url + 'edit/' + token;
    if (change_id) {
	url = url + '/' + change_id;
    }
    console.log("NARF: %o", url);
    $.ajax({
	url: url,
	type: 'GET',
	dataType: 'json',
	success: function (resp, textStatus) {
	    console.log("update: success: %o - %o", resp, textStatus);
	    if (resp) {
		callback(resp);
	    } else {
		callback(null);
	    }
	},
	error: function (jqXHR, textStatus, errorThrown) {
	    console.error("update: failure: %o - %o - %o", jqXHR, textStatus, errorThrown);
	    console.log('narf4');
	    callback({ error: "Unable to get update from IATed" });
	}
    });
}

/* Main */
init();

/* EOF */