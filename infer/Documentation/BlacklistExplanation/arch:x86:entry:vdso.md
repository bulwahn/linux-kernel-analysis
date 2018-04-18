**File Location:** linux/arch/x86/entry/vdso  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**  
```
arch/x86/entry/vdso/vclock_gettime.o: In function `__vdso_time':
arch/x86/entry/vdso/vclock_gettime.c:(.text+0x666): undefined reference to `memcpy'
arch/x86/entry/vdso/vclock_gettime.o: In function `gtod_read_begin':
arch/x86/entry/vdso/vclock_gettime.c:(.text+0x733): undefined reference to `memcpy'
Error: the following clang command did not run successfully:
  '/usr/bin/ld' "--hash-style=both" "--eh-frame-hdr" "-m" "elf_x86_64" "-shared" "-o" "arch/x86/entry/vdso/vdso64.so.dbg" "-L/usr/lib/gcc/x86_64-linux-gnu/6.3.0" "-L/usr/lib/gcc/x86_64-linux-gnu/6.3.0/../../../x86_64-linux-gnu" "-L/lib/x86_64-linux-gnu" "-L/lib/../lib64" "-L/usr/lib/x86_64-linux-gnu" "-L/usr/lib/gcc/x86_64-linux-gnu/6.3.0/../../.." "-L/opt/infer-linux64-v0.13.1/facebook-clang-plugins/clang/install/bin/../lib" "-L/lib" "-L/usr/lib" "--hash-style=both" "--build-id" "-Bsymbolic" "-soname=linux-vdso.so.1" "--no-undefined" "-z" "max-page-size=4096" "-z" "common-page-size=4096" "-T" "arch/x86/entry/vdso/vdso.lds" "arch/x86/entry/vdso/vdso-note.o" "arch/x86/entry/vdso/vclock_gettime.o" "arch/x86/entry/vdso/vgetcpu.o"

  HOSTCC  arch/x86/entry/vdso/vdso2c
  OBJCOPY arch/x86/entry/vdso/vdso64.so
objcopy: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
arch/x86/entry/vdso/Makefile:125: recipe for target 'arch/x86/entry/vdso/vdso64.so' failed
make[3]: *** [arch/x86/entry/vdso/vdso64.so] Error 1
scripts/Makefile.build:575: recipe for target 'arch/x86/entry/vdso' failed
make[2]: *** [arch/x86/entry/vdso] Error 2
scripts/Makefile.build:575: recipe for target 'arch/x86/entry' failed
make[1]: *** [arch/x86/entry] Error 2
Makefile:1019: recipe for target 'arch/x86' failed
make: *** [arch/x86] Error 2

Error backtrace:
Raised at file "base/Die.ml" (inlined), line 25, characters 6-36
Called from file "base/Logging.ml", line 281, characters 58-80
Called from file "backend/infer.ml", line 23, characters 2-36
Called from file "backend/infer.ml", line 112, characters 6-52
External Error: *** capture command failed:
*** make
*** exited with code 2
```
