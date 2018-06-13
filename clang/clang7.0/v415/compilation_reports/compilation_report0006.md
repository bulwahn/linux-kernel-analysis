## Report 0005 #  
**Compilation Command:**
```
git checkout v4.15
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
git cherry-pick 0e410e1
git cherry-pick 1a69e7c
git cherry-pick 342061e
git cherry-pick d321599
make clean
make allyesconfig
make menuconfig
Device Drivers -> Graphics Support -> Display Engine Configuration -> Disable DCN 1.0 Raven Family
make CC=clang-7 HOSTCC=clang-7
```  
**Used Kernel Configuration File:** [amd_dcn_and_qcom8x16_off](../../../config-files/v4.15/dcn10_qcom8x16_off_config)  
**Compilation Result:** No-Error Kernel v4.15 with [amd_dcn_and_qcom8x16_off](../../../config-files/v4.15/dcn10_qcom8x16_off_config) configfile, compiled successfully with using clang-7
```
Setup is 17276 bytes (padded to 17408 bytes).
System is 111735 kB
CRC 99573a8d
Kernel: arch/x86/boot/bzImage is ready  (#34)
```
