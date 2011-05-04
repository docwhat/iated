var is_focused = true;
var focus_queue = [];

/** jQuery plugin to assign unique ids.
 */
(function( $ ){
    var last_id = 0;
    $.fn.getId = function() {
        var el = this.first();
        if (!el.attr('id')) {
            el.attr('id', 'iat-' + (++last_id));
        }
        return el.attr('id');
    };
})( jQuery );

/** Scan the page for textareas and setup the buttons.
 */
function init() {
    console.debug('IAT is loading...');
    $('textarea').each(function () {
        var jel = $(this), tid = jel.getId(), button = $('<button class="iat">IAT</button>');
        ;
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
        is_focused = true;
        while (focus_queue.length > 0) {
            focus_queue.pop()();
        }
    }).blur(function () {
        is_focused = false;
    });
}

/** Called to edit a textarea.
 * @param jel  A single jQuery element.
 */
function edit(jel) {
    var callback = function (msg) {
        console.debug("IAT edit reply for ", jel, " with ", msg);
        if (msg && msg.error) {
            // Handle the error.
            handleError(msg);
            return;
        }
        monitor(jel, msg.token, null);
    }
    chrome.extension.sendRequest({ action : 'edit',
                                   text   : jel.val(),
                                   id     : jel.getId(),
                                   url    : window.location.href,
                                 },
                                 callback);
}

/** Start monitoring for changes.
 * @param jel  A single jQuery element.
 * @param token The token for this element.
 */
function monitor(jel, token, change_id) {
    var callback = function (msg) {
        new_change_id = (msg && msg.id) ? msg.id : change_id;
        console.debug("monitor callback - token:%o msg:%o el:%o",
                      token, msg, jel);
        if (msg && msg.error) {
            // Handle the error.
            handleError(msg);
            return;
        }
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

/** Handle errors.
 * @param msg A message object containing information on the error.
 */
function handleError(msg) {
    alert("ERROR: " + msg.error);
}

/** Main **/
init();

/* EOF */
