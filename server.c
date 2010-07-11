#include <sys/types.h>
#include <sys/time.h>
#include <sys/queue.h>
#include <stdlib.h>

#include <err.h>
#include <event.h>
#include <evhttp.h>

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
    evhttp_add_header(req->output_headers, "Content-Type", "text/plain; charset: ascii");
    evhttp_send_reply(req, HTTP_NOTFOUND, "NOT FOUND", buf);
}

void
cb_handler(struct evhttp_request *req, void *arg)
{
    struct evbuffer *buf;
    struct evkeyval *header;

    buf = evbuffer_new();

    if (buf == NULL) {
        err(1, "failed to create response buffer");
    }

    TAILQ_FOREACH(header, req->input_headers, next) {
        evbuffer_add_printf(buf, "HEADER %-30s: %s\n",
                           header->key,
                           header->value);
    }
    evbuffer_add_printf(buf,
                        "Method: %s\n",
                        method(req->type));
    evbuffer_add_printf(buf,
                        "Requested: %s\n",
                        evhttp_request_uri(req));
    evhttp_add_header(req->output_headers, "Content-Type", "text/plain; charset: ascii");
    evhttp_send_reply(req, HTTP_OK, "OK", buf);
}

void
serve()
{
    struct evhttp *httpd;

    event_init();
    httpd = evhttp_start("0.0.0.0", 9999);

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
