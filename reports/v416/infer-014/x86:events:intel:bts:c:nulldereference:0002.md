# Analysis Report 0002 #

## General ##
**Warning Type:** NULL_DEREFERENCE  
**Warning Explanation:**  Pointer `buf` last assigned on line 229 could be null and is dereferenced at line 232, column 7.
```C
    	u64 config = 0;
     
    	if (!buf->snapshot)
   		config |= ARCH_PERFMON_EVENTSEL_INT;
	   	if (!event->attr.exclude_kernel)
```C
**File Location:** arch/x86/events/intel/bts.c:232:
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** 
### Rationale ###
In here, *buf pointer points to a memory address that returned from perf_get_aux(&bts->handle) function.  
```C
static void __bts_event_start(struct perf_event *event)
{
	struct bts_ctx *bts = this_cpu_ptr(&bts_ctx);
	struct bts_buffer *buf = perf_get_aux(&bts->handle);
	u64 config = 0;

	if (!buf->snapshot)
		config |= ARCH_PERFMON_EVENTSEL_INT;
```
```C
struct bts_ctx {
	struct perf_output_handle	handle;
	struct debug_store		ds_back;
	int				state;
};
```
So lets look at perf_get_aux(struct perf_output_handle*) function definition:  
It defined in kernel/events/ring_buffer.c file as:  

```C
void *perf_get_aux(struct perf_output_handle *handle)
{
	/* this is only valid between perf_aux_output_begin and *_end */
	if (!handle->event)
		return NULL;

	return handle->rb->aux_priv;
}
```
So that function is not a null-safe function. If ```bts->handle``` is pointing to an invalid memory address, then this function may fail
