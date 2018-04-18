**File Location:** linux/arch/x86/kernel  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**
```
/tmp/process-e0dd0a.s: Assembler messages:
/tmp/process-e0dd0a.s:3945: Error: bad memory operand `%edi'
Error: the following clang command did not run successfully:
  '/usr/bin/as' "--64" "-I" "./arch/x86/include" "-I" "./arch/x86/include/generated" "-I" "./include" "-I" "./arch/x86/include/uapi" "-I" "./arch/x86/include/generated/uapi" "-I" "./include/uapi" "-I" "./include/generated/uapi" "-o" "arch/x86/kernel/process.o" "/tmp/process-e0dd0a.s"

scripts/Makefile.build:316: recipe for target 'arch/x86/kernel/process.o' failed
make[2]: *** [arch/x86/kernel/process.o] Error 1
scripts/Makefile.build:575: recipe for target 'arch/x86/kernel' failed
make[1]: *** [arch/x86/kernel] Error 2
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
