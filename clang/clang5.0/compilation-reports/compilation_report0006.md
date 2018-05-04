## Report 0006 #  
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
Device Drivers -> Multimedia Support -> V4L Platform Devices -> Disable Qualcomm 8x16 V4L2 Camera Subsystem Driver
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Kernel Configuration File:** [final-config](../config-files/final-config)  
**Filename:** No-Error  
**Error Message:** No-Error, Kernel Built with Clang-5.0 successfully.  
```
Setup is 17276 bytes (padded to 17408 bytes).
System is 114562 kB
CRC 1b915f35
Kernel: arch/x86/boot/bzImage is ready  (#13)
```  



