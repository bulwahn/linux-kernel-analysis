## Report 0006 #  
**Compilation Command:**
```
git checkout v4.15
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
make clean
make allyesconfig
make menuconfig
Device Drivers -> Graphics Support -> Display Engine Configuration -> Disable DCN 1.0 Raven Family
Device Drivers -> Multimedia Support -> V4L Platform Devices -> Disable Qualcomm 8x16 V4L2 Camera Subsystem Driver
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Used Kernel Configuration File:** [amd_dcn_and_qcom8x16_off](../../../config-files/v4.15/dcn10_qcom8x16_off_config)  
**Compilation Result:** [rectification0006](../../../rectification-reports/rectification0006.md)  
