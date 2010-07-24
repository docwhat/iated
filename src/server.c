#include <sys/types.h>
#include <sys/time.h>
#include <sys/queue.h>
#include <stdlib.h>

#include <err.h>
#include <event.h>
#include <evhttp.h>

/**
 * Determine the method in text form.
 */
const char *
method(enum evhttp_cmd_type type)
{
    const char *method;

    switch (type) {
    case EVHTTP_REQ_GET:
        method = "GET";
        break;
    case EVHTTP_REQ_POST:
        method = "POST";
        break;
    case EVHTTP_REQ_HEAD:
        method = "HEAD";
        break;
    default:
        method = NULL;
        break;
    }

    return (method);
}

/**
 * Respond to a request with a 404.
 */
void
handle404(struct evhttp_request *req, void *arg)
{
    struct evbuffer *buf;
    buf = evbuffer_new();

    if (buf == NULL)
        err(1, "failed to create response buffer");

    evbuffer_add_printf(buf,
                        "Not Found\n\nNo such page: %s\n",
                        evhttp_request_uri(req));
    //    evhttp_add_header(req->output_headers, "Content-Type", "text/plain; charset: ascii");
    evhttp_send_reply(req, HTTP_NOTFOUND, "NOT FOUND", buf);
}

/**
 * Generic redirector.
 */
void
cb_handler(struct evhttp_request *req, void *arg)
{
    struct evbuffer *buf;
    struct evkeyval *header;

    buf = evbuffer_new();

    if (buf == NULL) {
        err(1, "failed to create response buffer");
    }

    evhttp_add_header(req->output_headers, "Content-Type", "text/plain; charset: UTF-8");

    if (EVHTTP_REQ_GET == req->type && strcmp(evhttp_request_uri(req), "/ping") == 0 ) {
        evbuffer_add_printf(buf,
                            "pong\n");
        evhttp_send_reply(req, HTTP_OK, "OK", buf);
        return;
    }

    handle404(req, arg);

//    TAILQ_FOREACH(header, req->input_headers, next) {
//        evbuffer_add_printf(buf, "HEADER %-30s: %s\n",
//                           header->key,
//                           header->value);
//    }
//    evbuffer_add_printf(buf,
//                        "Method: %s\n",
//                        method(req->type));
//    evbuffer_add_printf(buf,
//                        "Requested: %s\n",
//                        evhttp_request_uri(req));
//    evhttp_add_header(req->output_headers, "Content-Type", "text/plain; charset: ascii");
//    evhttp_send_reply(req, HTTP_OK, "OK", buf);
}

void
serve(int port)
{
    struct evhttp *httpd;

    event_init();
    httpd = evhttp_start("0.0.0.0", port);

    /* Set a callback for requests to "/specific". */
    /* evhttp_set_cb(httpd, "/specific", another_handler, NULL); */

    /* Set a callback for all other requests. */
    //evhttp_set_gencb(httpd, handle404, NULL);
    evhttp_set_gencb(httpd, cb_handler, NULL);

    event_dispatch();

    /* Not reached in this code as it is now. */
    evhttp_free(httpd);
}


/*EOF*/
