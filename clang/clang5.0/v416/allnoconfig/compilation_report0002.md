## Report 0002 #  
**Compilation Command:**
```
git checkout v4.16
git am percpu-fix.patch
make allnoconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```
percpu-fix.patch location is : [percpu-fix.patch](../../../fix-patches/allnoconfig-percpu-fix.patch)  
**Used Kernel Configuration File:** [allnoconfig](../../../config-files/v4.16/allnoconfig)   
**Compilation Result:**  
No-Error, v4.16 compiled with clang-5.0 successfully.  
```
Setup is 15468 bytes (padded to 15872 bytes).
System is 607 kB
CRC 308a0953
Kernel: arch/x86/boot/bzImage is ready  (#1)
```  
