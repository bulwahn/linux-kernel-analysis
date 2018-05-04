## Report 0001 ##
**Compilation Command:**   
```
git checkout v4.16
make clean
make allyesconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Head Commit:** 0adb32858b0b ("Linux 4.16")  
**Filename:** fs/exofs/ore.c, fs/exofs/ore_raid.c   
**Error Messages:** [error0001](../error-files/error0001.txt), [error0002](../error-files/error0002.txt)  
**Included due to:** fs/Kconfig:250  
```
source "fs/exofs/Kconfig"
```  
**Change in Kernel Configuration:** Fixed by commit.  
**Fixed By:** [exofs-solution-patch](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/fs/exofs/ore.c?id=60cd4969c1975d800d731785e3ca19e047a1950b)  
**New Kernel Configuration:** [allyesconfig](../config-files/allyesconfig)  
