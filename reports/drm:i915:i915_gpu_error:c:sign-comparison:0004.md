# Analysis Report 0004 #
## General ##
**Warning Type:** Wsign-compare  
**Warning Explanation:** ``drivers/gpu/drm/i915/i915_gpu_error.c:488:16: warning: comparison of integers of different signs: 'int' and 'const unsigned int' [-Wsign-compare]
for (n = 0; n < ee->num_ports; n++) {```  
**File Location:** drivers/gpu/drm/i915/i915_gpu_error.c

## History ##
**Introduced By:** 76e70087d360 ("drm/i915: Make execlist port count variable")  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** [Tool can detect during compile time.](WarningTypeClassifications.md)
### Rationale ### 
```C
//...
int n;
//...
	for (n = 0; n < ee->num_ports; n++) {
		err_printf(m, "  ELSP[%d]:", n);
		error_print_request(m, " ", &ee->execlist[n]);
	}
```

Clang Compiler states that there is a problem inside for loop, about comparing ```int``` and ```unsigned int```.   
```struct drm_i915_error_engine``` is defined in **drivers/gpu/drm/i915/i915_drv.h:502:** file as following:
```C
struct drm_i915_error_engine {
//...
		struct drm_i915_error_request {
			long jiffies;
			pid_t pid;
			u32 context;
			int priority;
			int ban_score;
			u32 seqno;
			u32 head;
			u32 tail;
		} *requests, execlist[EXECLIST_MAX_PORTS];
		unsigned int num_ports;
//..
```
Lastly ```EXECLIST_MAX_PORTS``` defined inside ***drivers/gpu/drm/i915/intel_ringbuffer.h***:
```C
#define EXECLIST_MAX_PORTS 2
```
As a summary, programmers defined EXECLIST_MAX_PORTS value by 2. Currently it is safe, and even if this value will be increased by a huge amount by a programmer in future, a smart-tool can detect it during compilation.

