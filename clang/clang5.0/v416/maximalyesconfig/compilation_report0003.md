## Report 0003 #  
**Compilation Command:**  
```
git checkout v4.16  
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
git cherry-pick 37172013fa2e
git cherry-pick cc32ad8f559c
make clean
make allyesconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Used Kernel Configuration File:** [allyesconfig](../../../config-files/v4.16/allyesconfig)  
**Compilation Result:** [rectification0003](../../../rectification-reports/rectification0003.md)  

