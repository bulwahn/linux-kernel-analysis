## Report 0005 #  
**Compilation Command:**
```
git checkout v4.16
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
make clean
make allyesconfig
make menuconfig
Device Drivers -> Graphics Support -> Display Engine Configuration -> Disable DCN 1.0 Raven Family
make CC=clang-5.0 HOSTCC=clang-5.0
```  
No need to cherry-pick amd patches anymore, since we are using a different configfile  
**Used Kernel Configuration File:** [amd_dcn_10_not_set_config](../../../config-files/v4.16/amd_dcn_10_not_set_config)  
**Compilation Result:** [rectification0005](../../../rectification-reports/rectification0005.md)
