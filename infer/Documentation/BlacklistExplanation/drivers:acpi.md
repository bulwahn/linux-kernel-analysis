**File Location:** linux/drivers/acpi  
**Kernel Version:**  commit: d8a5b80568a9("Linux 4.15")  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Message During Infer Capture:**  
```
drivers/acpi/processor_idle.o: warning: objtool: acpi_processor_get_lpi_info()+0x2fe: return with modified stack frame
  CC      drivers/acpi/processor_throttling.o
/tmp/processor_throttling-b25fcd.s: Assembler messages:
/tmp/processor_throttling-b25fcd.s:2947: Error: bad memory operand `%edi'
Error: the following clang command did not run successfully:
  '/usr/bin/as' "--64" "-I" "./arch/x86/include" "-I" "./arch/x86/include/generated" "-I" "./include" "-I" "./arch/x86/include/uapi" "-I" "./arch/x86/include/generated/uapi" "-I" "./include/uapi" "-I" "./include/generated/uapi" "-o" "drivers/acpi/processor_throttling.o" "/tmp/processor_throttling-b25fcd.s"

scripts/Makefile.build:316: recipe for target 'drivers/acpi/processor_throttling.o' failed
make[2]: *** [drivers/acpi/processor_throttling.o] Error 1
scripts/Makefile.build:575: recipe for target 'drivers/acpi' failed
make[1]: *** [drivers/acpi] Error 2
Makefile:1019: recipe for target 'drivers' failed
make: *** [drivers] Error 2
```
