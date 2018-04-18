**File Location:** linux/arch/x86/mm  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**  
```
arch/x86/mm/init.o: warning: objtool: clear_page()+0x24: undefined stack state
arch/x86/mm/init.o: warning: objtool: zone_sizes_init()+0xe0: return with modified stack frame
arch/x86/mm/init.o: warning: objtool: init_memory_mapping()+0x181: return with modified stack frame
  CC      arch/x86/mm/init_64.o
/tmp/init_64-fb26c3.s: Assembler messages:
/tmp/init_64-fb26c3.s:3726: Error: bad memory operand `%edi'
Error: the following clang command did not run successfully:
  '/usr/bin/as' "--64" "-I" "./arch/x86/include" "-I" "./arch/x86/include/generated" "-I" "./include" "-I" "./arch/x86/include/uapi" "-I" "./arch/x86/include/generated/uapi" "-I" "./include/uapi" "-I" "./include/generated/uapi" "-o" "arch/x86/mm/init_64.o" "/tmp/init_64-fb26c3.s"

scripts/Makefile.build:316: recipe for target 'arch/x86/mm/init_64.o' failed
make[2]: *** [arch/x86/mm/init_64.o] Error 1
scripts/Makefile.build:575: recipe for target 'arch/x86/mm' failed
make[1]: *** [arch/x86/mm] Error 2
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
