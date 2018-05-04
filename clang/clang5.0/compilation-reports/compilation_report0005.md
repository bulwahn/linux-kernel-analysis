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
**Kernel Configuration File:** [amd_dcn_10_not_set_config](../config-files/amd_dcn_10_not_set_config)  
**Filename:** 
- drivers/media/platform/qcom/camss-8x16/camss-csid.c  
- drivers/media/platform/qcom/camss-8x16/camss-csiphy.c  
- drivers/media/platform/qcom/camss-8x16/camss-ispif.c  
-  drivers/media/platform/qcom/camss-8x16/camss-vfe.c  

**Error Message:** [error-0009](../error-files/error0009.txt), [error-0010](../error-files/error0010.txt), [error-0011](../error-files/error0011.txt), [error-0012](../error-files/error0012.txt)  
**Included due to:**  
```
CONFIG_VIDEO_QCOM_CAMSS=y  
```  
**Change in Kernel Configuration:**  
```
CONFIG_VIDEO_QCOM_CAMSS is not set
```
**Fixed By:** Change in .configfile  
**New Kernel Configuration:** [final-config](../config-files/final-config)  
