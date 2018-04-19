**File Location:** linux/kernel/bpf  
**Kernel Version:**  commit: d8a5b80568a9("Linux 4.15")  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Message During Infer Capture:**  
```
kernel/bpf/core.o: In function `bpf_prog_select_runtime':
kernel/bpf/core.c:(.text+0x4601): undefined reference to `bpf_prog_offload_compile'
kernel/bpf/core.o: In function `bpf_prog_free_deferred':
kernel/bpf/core.c:(.text+0x5147): undefined reference to `bpf_prog_offload_destroy'
Makefile:1000: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
```

