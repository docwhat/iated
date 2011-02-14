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
	    success: function () {
		var data = { "text": "The New Text: " + request.text,
			     "id" : request.id };
		callback(data);
	    },
	    failure: function () {
		alert("Failure");
	    }
	});
    }
};
chrome.extension.onRequest.addListener(onRequest);

console.debug('IAT background loaded.');
