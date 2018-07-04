# Analysis Report 0002 #

## General ##
**Warning Type:** NULL_DEREFERENCE  
**Warning Explanation:**  Pointer `buf` last assigned on line 229 could be null and is dereferenced at line 232, column 7.
```C
    	u64 config = 0;
     
    	if (!buf->snapshot)
   		config |= ARCH_PERFMON_EVENTSEL_INT;
	   	if (!event->attr.exclude_kernel)
```
**File Location:** arch/x86/events/intel/bts.c:232:
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** UNDECIDED
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
So that function is not a null-safe function. If ```bts->handle``` is pointing to an invalid memory address, then this function may fail.   
To find out that, if it is possible, then we should look at ```this_cpu_ptr(&bts_ctx);``` line. In here ```bts_ctx``` is an global variable.  
```this_cpu_ptr``` macro defined in  [include/linux/percpu-defs.h](https://elixir.bootlin.com/linux/v4.16/source/include/linux/percpu-defs.h) file, as three different instances, which selected according to kernel-configuration.  
```C
#define raw_cpu_ptr(ptr)						\
({									\
	__verify_pcpu_ptr(ptr);						\
	arch_raw_cpu_ptr(ptr);						\
})

#ifdef CONFIG_DEBUG_PREEMPT
#define this_cpu_ptr(ptr)						\
({									\
	__verify_pcpu_ptr(ptr);						\
	SHIFT_PERCPU_PTR(ptr, my_cpu_offset);				\
})
#else
#define this_cpu_ptr(ptr) raw_cpu_ptr(ptr)
#endif

#else	/* CONFIG_SMP */

#define VERIFY_PERCPU_PTR(__p)						\
({									\
	__verify_pcpu_ptr(__p);						\
	(typeof(*(__p)) __kernel __force *)(__p);			\
})

#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
#define raw_cpu_ptr(ptr)	per_cpu_ptr(ptr, 0)
#define this_cpu_ptr(ptr)	raw_cpu_ptr(ptr)
```
It is very hard to track this function since it has multiple definitions and also using a global variable, so I checked developers comment that written above ```__bts_event_start``` as:  
```C
/*
 * Ordering PMU callbacks wrt themselves and the PMI is done by means
 * of bts::state, which:
 *  - is set when bts::handle::event is valid, that is, between
 *    perf_aux_output_begin() and perf_aux_output_end();
 *  - is zero otherwise;
 *  - is ordered against bts::handle::event with a compiler barrier.
 */
```
According to comment, that function is safe, however I couldn't really decided if infer is right or not

