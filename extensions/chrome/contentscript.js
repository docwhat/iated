/** Scan the page for textareas and setup the buttons.
 */
function init() {
    console.debug('IAT is loading...');
    $('textarea').each(function () {
	var button = $('<button class="iat">IAT</button>'), jel = $(this);
	jel.after(button);

	button
	    .css('position', 'absolute')
	    .click(function (event) {
		edit(jel);
		return false;
	    });
    });
    console.debug('IAT is loaded.');
}

/** Called to edit a textarea.
 * @param jel  A single jQuery element.
 */
function edit(jel) {
    var callback = function (token) {
	console.debug("IAT edit succes for ", jel, " with ", token);
	monitor(jel, token, 0);
    }
    chrome.extension.sendRequest({ action : 'edit',
				   text   : jel.val()},
				 callback);
}

/** Start monitoring for changes.
 * @param jel  A single jQuery element.
 * @param token The token for this element.
 */
function monitor(jel, token, change_id) {
    // TODO This should pause when tab is not the active tab.
    var callback = function (msg) {
	console.log("monitor callback: %o - %o - %o ", msg, token, jel);
	jel.val(msg);
	setTimeout(function () {
	    monitor(jel, token);
	}, 3000);
    }
    chrome.extension.sendRequest({action : 'update',
				  token  : token,
				  change_id : change_id},
				callback);
}

/** Main **/
init();

/* EOF */