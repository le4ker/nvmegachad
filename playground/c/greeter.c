#include "greeter.h"
#include <stdio.h>

void greet(const char *name, char *out, size_t out_size) {
  snprintf(out, out_size, "Hello, %s!", name);
}
