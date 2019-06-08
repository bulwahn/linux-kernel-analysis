## Report 0002 #  
**Compilation Command:** 
```
git checkout v4.15  
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch  
make clean  
make allyesconfig  
make CC=clang-5.0 HOSTCC=clang-5.0  
```
**Used Kernel Configuration File:** [allyesconfig](../../../config-files/v4.15/allyesconfig)  
**Compilation Result:** [rectification0002](../../../rectification-reports/rectification0002.md)  

