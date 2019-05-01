# Analysis Report 0005 #

## General ##
**Warning Type:** Wsign-compare  
**Warning Explanation:** ```drivers/gpu/drm/i915/intel_pm.c:9266:8: warning: comparison of integers of different signs: 'unsigned long long' and 'int' [-Wsign-compare]  
        ret = wait_for_atomic(COND, 50);  ```  
**File Location:** drivers/gpu/drm/i915/intel_pm.c

## History ##
**Introduced By:** a0b8a1fe3443 ("drm/i915/gen9: Fix PCODE polling during CDCLK change notification")  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:**  [Tool can detect during compile time](WarningTypeClassifications.md)  
### Rationale  ###
Clang compiler creates a warning about code part:
```C
int skl_pcode_request(struct drm_i915_private *dev_priv, u32 mbox, u32 request,
		      u32 reply_mask, u32 reply, int timeout_base_ms)
{
//...
preempt_disable();
ret = wait_for_atomic(COND, 50);
preempt_enable();
//...
}
```
Clang states there may be a sign comparision problem in a macro ```_wait_for_atomic```, which called from ```wait_for_atomic``` macro.
```wait_for_atomic``` macro defined in **drivers/gpu/drm/i915/intel_drv.h** as following:
```C
#define wait_for_atomic(COND, MS) wait_for_atomic_us((COND), (MS) * 1000)
``` 
Basically ``` wait_for_atomic``` just calls another macro ```wait_for_atomic_us``` and in our case parameters as COND and 50000.  
So lets look at  ```wait_for_atomic_us``` macro which is defined in **drivers/gpu/drm/i915/intel_drv.h** as:
```C
#define wait_for_atomic_us(COND, US) \
({ \
	BUILD_BUG_ON(!__builtin_constant_p(US)); \
	BUILD_BUG_ON((US) > 50000); \
	_wait_for_atomic((COND), (US), 1); \
})
```
Just like before, it calls another macro ```_wait_for_atomic(COND, 50000, 1)```, and as final step we must look at ```_wait_for_atomic``` macro defination which is defined in **drivers/gpu/drm/i915/intel_drv.h** like others:
```C
#define _wait_for_atomic(COND, US, ATOMIC) \
({ \
	int cpu, ret, timeout = (US) * 1000; \
	u64 base; \
	_WAIT_FOR_ATOMIC_CHECK(ATOMIC); \
	if (!(ATOMIC)) { \
		preempt_disable(); \
		cpu = smp_processor_id(); \
	} \
	base = local_clock(); \
	for (;;) { \
		u64 now = local_clock(); \
		if (!(ATOMIC)) \
			preempt_enable(); \
		if (COND) { \
			ret = 0; \
			break; \
		} \
		if (now - base >= timeout) { \
			ret = -ETIMEDOUT; \
			break; \
		} \
		cpu_relax(); \
		if (!(ATOMIC)) { \
			preempt_disable(); \
			if (unlikely(cpu != smp_processor_id())) { \
				timeout -= now - base; \
				cpu = smp_processor_id(); \
				base = local_clock(); \
			} \
		} \
	} \
	ret; \
})
```  
In this case, ```now - base``` substraction won't cause any problem during runtime.
