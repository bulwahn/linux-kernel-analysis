## Report 0005 #  
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
make menuconfig
Device Drivers -> Graphics Support -> Display Engine Configuration -> Disable DCN 1.0 Raven Family
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Used Kernel Configuration File:** [amd_dcn_10_not_set_config](../config-files/amd_dcn_10_not_set_config)  
**Compilation Result:** [rectification0009](../rectification-reports/rectification0009.md), [rectification0010](../rectification-reports/rectification0010.md), [rectification0011](../rectification-reports/rectification0011.md), [rectification0012](../rectification-reports/rectification0012.md)  
