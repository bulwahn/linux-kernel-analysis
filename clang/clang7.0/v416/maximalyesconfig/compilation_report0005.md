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
make CC=clang-7 HOSTCC=clang-7
```  
No need to cherry-pick amd patches anymore, since we are using a different configfile  
**Used Kernel Configuration File:** [amd_dcn_10_not_set_config](../../../config-files/v4.16/amd_dcn_10_not_set_config)  
**Compilation Result:**  
No-Error, v4.16 compiled with Clang-7 Unstable successfully.  
```
Setup is 17276 bytes (padded to 17408 bytes).
System is 114562 kB
CRC 1b915f35
Kernel: arch/x86/boot/bzImage is ready  (#13)
```  
