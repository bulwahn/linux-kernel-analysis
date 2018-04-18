**File Location:** linux/kernel/bpf  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**  
```
kernel/bpf/core.o: In function `bpf_prog_select_runtime':
kernel/bpf/core.c:(.text+0x4601): undefined reference to `bpf_prog_offload_compile'
kernel/bpf/core.o: In function `bpf_prog_free_deferred':
kernel/bpf/core.c:(.text+0x5147): undefined reference to `bpf_prog_offload_destroy'
Makefile:1000: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
```

