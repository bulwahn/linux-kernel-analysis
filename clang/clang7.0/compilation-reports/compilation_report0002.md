## Report 0002 ##
**Compilation Command:**   
```
git checkout v4.16
make clean
make allyesconfig
make menuconfig
Device Drivers -> Microsoft Hyper-V Guest Support -> Turn off Microsoft Hyper-V Client Drivers
make CC=clang-7 HOSTCC=clang-7
```
**Used Kernel Configuration File:** [allyesconfig-no-hyperv](../config-files/no-hyperv)   
**Result:**  [rectification0002](../rectification-reports/rectification0002.md)  
