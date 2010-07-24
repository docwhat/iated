#include <stdio.h>
#include "server.h"

#define PORT 9292

int
main(int argc, char **argv)
{
    printf("Starting on port %d...\n", PORT);
    serve(PORT);

    return 0;
}
