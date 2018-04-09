#include "infer_builtins.h"

#include <stdlib.h>

void* kmalloc(size_t size, unsigned flags) {
  if (size == 0)
    return NULL;
  void* res = malloc(size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void kfree(void* ptr) { free(ptr); }
