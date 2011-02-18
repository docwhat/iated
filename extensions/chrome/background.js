console.debug('IAT background loading...');
var base_url = 'http://127.0.0.1:9090/';

$.ajaxSetup({
    type: 'POST',
    cache: false
});

/**
 * @param request  Object Data sent in the request.
 * @param sender   Object Origin of the request.
 * @param callback Function The method to call when the request completes.
 */
function onRequest(request, sender, callback) {
    if (request.action == 'edit') {
	$.ajax({
	    url: base_url + 'edit',
	    data: { 'text' : request.text },
	    dataType: 'text',
	    success: function (data, textStatus) {
		monitor(data, request.id, callback);
	    },
	    failure: function () {
		alert("Failure");
	    }
	});
    }
};
chrome.extension.onRequest.addListener(onRequest);

/**
 * Checks to see if anything has changed.
 *
 * @param token    String The token of this edit session.
 * @param callback Function The method to call when something changes.
 */
function monitor(token, id, callback) {
    jQuery.Updater(base_url + 'edit/' + token, {
        data: {token: token},
        type: 'text',
        interval: '3000'
    }, function (data, textStatus) {
	var data = { text: data,
		     id: id,
		     status: textStatus };
	callback(data);
    });
}

console.debug('IAT background loaded.');
