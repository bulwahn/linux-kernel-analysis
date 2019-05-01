#include "infer_builtins.h"

#include <stdlib.h>

typedef unsigned gfp_t;

#define SIZE_MAX	(~(size_t)0)

void* kmalloc(size_t size, gfp_t flags) {
  if (size == 0)
    return NULL;
  void* res = malloc(size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void kfree(void* ptr) { free(ptr); }

void do_exit(long error_code) { exit(0); }

void* kcalloc(size_t n, size_t size, gfp_t flags) {
  if (size != 0 && n > SIZE_MAX / size) 
    return NULL;
  
  void* res = malloc(n * size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void *kzalloc(size_t size, gfp_t flags) {
  if (size == 0)
    return NULL;
  void* res = malloc(size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void* vmalloc(unsigned long size) {
  if (size == 0)
    return NULL;
  void* res = malloc(size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void vfree(void *ptr) { free(ptr); }

//similar to strlen model
size_t ksize(const void* obj) {
  int size;
  __require_allocated_array(obj);
  size = __get_array_length(obj);
  return size - 1;
}