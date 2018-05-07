## Report 0004 #  
**Compilation Command:**  
```
git checkout v4.16
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
git cherry-pick 37172013fa2e
git cherry-pick cc32ad8f559c
git cherry-pick a27267e01ffa
git cherry-pick 4007e92bebeb
git cherry-pick 4769278e5c7f
make clean
make allyesconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Used Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Compilation Result:** [rectification0005](../rectification-reports/rectification0005.md), [rectification0006](../rectification-reports/rectification0006.md), [rectification0007](../rectification-reports/rectification0007.md), [rectification0008](../rectification-reports/rectification0008.md)  


