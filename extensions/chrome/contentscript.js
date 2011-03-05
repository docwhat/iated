var is_focused = true;
var focus_queue = [];

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

    $(window).focus(function () {
	console.log("narf focus");
	is_focused = true;
	while (focus_queue.length > 0) {
	    focus_queue.pop()();
	}
    }).blur(function () {
	console.log("narf blur");
	is_focused = false;
    });
}

/** Called to edit a textarea.
 * @param jel  A single jQuery element.
 */
function edit(jel) {
    var callback = function (token) {
	console.debug("IAT edit succes for ", jel, " with ", token);
	monitor(jel, token, null);
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
	new_change_id = (msg && msg.id) ? msg.id : change_id;
	console.debug("monitor callback - token:%o msg:%o el:%o",
		      token, msg, jel);
	if (msg && msg.text && msg.text != jel.val()) {
	    jel.val(msg.text);
	    jel.effect("highlight", {}, 3 * 1000);
	}
	if (is_focused) {
	    setTimeout(function () {
		monitor(jel, token, new_change_id);
	    }, 3000);
	} else {
	    focus_queue.push(function () {
		monitor(jel, token, new_change_id);
	    });
	}
    }
    chrome.extension.sendRequest({action : 'update',
				  token  : token,
				  change_id : change_id},
				callback);
}

/** Main **/
init();

/* EOF */