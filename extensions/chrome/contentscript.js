console.debug('IAT is loading...');

var id_incr = 1;

/* Mini-plugin to fetch/set element ids */
// (function ( $ ) {
//     $.fn.id = function () {
// 	this.each(function (i, el) {
// 	    el = $(el);
// 	    console.log('narfy ', el, el.attr('id'));
// 	    if (!el.attr('id')) {
// 		el.attr('id', 'iat-' + id_incr++);
// 		console.log('narfy ! ', el.attr('id'));
// 	    }
// 	    return el.attr('id');
// 	});
//     };
// })( jQuery );

/* Store the relationship between button.id (key) and textarea elements (value) */
var table = {};

function edit_callback(data) {
    console.log('edit_callback(', data, ');');
    table[data.id].val(data.text);
}

function edit (ev) {
    var id = $(ev.target).attr('id');
    console.log('edit(', ev, ');', id);
    if (table[id]) {
	var text = table[id].val();
	chrome.extension.sendRequest({'action' : 'edit',
				      'text' : text,
				      'id' : id},
				     edit_callback);
    } else {
	console.error("Unable to find entry in table for", id);
    }
    console.log('...end edit');
}

$('textarea').each(function (i, el) {
    var id="iat-" + id_incr++, button = $('<button class="iat" id="'+id+'">IAT</button>');
    el = $(el);
    el.after(button);

    /* Create a lookup for the button for the future. */
    table[id] = el;
    console.log('narf added to table: ', id, el, table);

    button
	.hide()
	.css('position', 'absolute')
	.click(edit);
    $(el, button).hover(function () {
	button.stop(true, true).fadeIn(400);
    }, function () {
	button.stop(true).fadeOut(4 * 1000);
    });
});


console.debug('IAT is loaded.');
