## Report 0001 ##
**Compilation Command:** make allyesconfig && make -j40 CC=clang-5.0 HOSTCC=clang-5.0  
**Head Commit:** d8a5b80568a9 ("Linux 4.15")  
**Filename:** fs/exofs/ore.c, fs/exofs/ore_raid.c,   
**Error-Message:** [error0001](../error-files/error0001.md), [error0002](../error-files/error0002.md)  
**Included due to:** fs/Kconfig:250  
```
source "fs/exofs/Kconfig"
```  
**Change in Kernel Configuration:**   # CONFIG_EXOFS_FS is not set  
**New Kernel Configuration:** [config0002](../config-files/config0002)  
