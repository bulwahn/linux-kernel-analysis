## Report 0001 ##
**Compilation Command:** make allyesconfig && make -j40 CC=clang-5.0 HOSTCC=clang-5.0  
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Head Commit:** 0adb32858b0b ("Linux 4.16")  
**Filename:** fs/exofs/ore.c, fs/exofs/ore_raid.c   
**Error-Message:** [error0001](../error-files/error0001.md), [error0002](../error-files/error0002.md)  
**Included due to:** fs/Kconfig:250  
```
source "fs/exofs/Kconfig"
```  
**Change in Kernel Configuration:** Fixed by commit.  
**Fixed By:** [exofs-solution-patch](../fix-patches/exofs-solution.patch)  
**New Kernel Configuration:** [allyesconfig](../config-files/allyesconfig)  
