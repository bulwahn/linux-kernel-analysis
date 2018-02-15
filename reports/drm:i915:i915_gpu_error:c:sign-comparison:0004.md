# Analysis Report 0004 #
#### Clang Compiler Warning  ####
Sign Comparison  
#### Warning Explanation ####
drivers/gpu/drm/i915/i915_gpu_error.c:488:16: warning: comparison of integers of different signs: 'int' and 'const unsigned int' [-Wsign-compare]  
        for (n = 0; n < ee->num_ports; n++) {  
#### Introduced By: 76e70087d360 ("drm/i915: Make execlist port count variable") ####  
#### Reported Since : 60d7a21aedad ("Merge tag 'nios2-v4.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2")  ####
#### File Location: drivers/gpu/drm/i915/i915_gpu_error.c  ####
#### Resolved By: -- ####

#### Manuel Assesment: ####
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
```struct drm_i915_error_engine``` is defined in i915_drv.h:502: file as following:
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
As we observed above ```num_ports``` is an ```unsigned int``` which can have a value between(0, 2^32), where as ```n``` is an integer that can get maximum (2^31).  
In this case there may be an integer overflow, if ```drm_i915``` has more than 2^31 ports, and when it happens, it will definitely creates a problem during runtime , because inside for loop, programmer used ```int n``` as an index.  After 2^31 , ```n``` will get a negative value(integer overflow) and that will lead an index-out-of bounds problem. While it is theoritacally possible, important questions is, can ```num_port``` get a value that bigger than 2^32.  
According to detailed commit message ("As we emulate execlists on top of the GuC workqueue, it is not restricted to just 2 ports and we can increase that number arbitrarily to trade-off queue depth (i.e. scheduling latency) against pipeline bubbles.") and changed lines, programmers just wanted to make this variable dynamic, but they are not planning to assign a value that bigger than 2^31. So while it is theoratically may create a problem, In my opinion, practically won't create any errors.
