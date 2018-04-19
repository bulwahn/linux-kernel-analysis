**File Location:** linux/arch/x86/boot  
**Kernel Version:**  commit: d8a5b80568a9("Linux 4.15")  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Message During Infer Capture:**  
**First Error:**  
```
arch/x86/boot/compressed/kaslr.o: In function `smp_send_stop':
arch/x86/boot/compressed/kaslr.c:(.text+0x26): undefined reference to `smp_ops'
arch/x86/boot/compressed/kaslr.o: In function `smp_send_reschedule':
arch/x86/boot/compressed/kaslr.c:(.text+0x34): undefined reference to `smp_ops'
arch/x86/boot/compressed/kaslr.o: In function `smp_prepare_cpus':
arch/x86/boot/compressed/kaslr.c:(.text+0x54): undefined reference to `smp_ops'
arch/x86/boot/compressed/kaslr.o: In function `__cpu_up':
arch/x86/boot/compressed/kaslr.c:(.text+0x77): undefined reference to `smp_ops'
arch/x86/boot/compressed/kaslr.o: In function `smp_cpus_done':
arch/x86/boot/compressed/kaslr.c:(.text+0xa4): undefined reference to `smp_ops'
arch/x86/boot/compressed/kaslr.o:arch/x86/boot/compressed/kaslr.c:(.text+0xc4): more undefined references to `smp_ops' follow
arch/x86/boot/compressed/Makefile:110: recipe for target 'arch/x86/boot/compressed/vmlinux' failed
make[2]: *** [arch/x86/boot/compressed/vmlinux] Error 1
arch/x86/boot/Makefile:112: recipe for target 'arch/x86/boot/compressed/vmlinux' failed
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
arch/x86/Makefile:299: recipe for target 'bzImage' failed
make: *** [bzImage] Error 2

Error backtrace:
Raised at file "base/Die.ml" (inlined), line 25, characters 6-36
Called from file "base/Logging.ml", line 281, characters 58-80
Called from file "backend/infer.ml", line 23, characters 2-36
Called from file "backend/infer.ml", line 112, characters 6-52
External Error: *** capture command failed:
```
**Second Error:**  
```
ld: Setup too big!
arch/x86/boot/Makefile:105: recipe for target 'arch/x86/boot/setup.elf' failed
make[1]: *** [arch/x86/boot/setup.elf] Error 1
arch/x86/Makefile:299: recipe for target 'bzImage' failed
make: *** [bzImage] Error 2

Error backtrace:
Raised at file "base/Die.ml" (inlined), line 25, characters 6-36
Called from file "base/Logging.ml", line 281, characters 58-80
Called from file "backend/infer.ml", line 23, characters 2-36
Called from file "backend/infer.ml", line 112, characters 6-52
External Error: *** capture command failed:
*** make -j40
*** exited with code 2
```
