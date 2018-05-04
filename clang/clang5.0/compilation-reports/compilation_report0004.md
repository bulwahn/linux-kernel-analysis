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
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Filename:** 
- drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c,  
- drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.c,  
- drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_auto.c,  
- drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c  

**Error Message:** [error-0005](../error-files/error0005.txt), [error-0006](../error-files/error0006.txt), [error-0007](../error-files/error0007.txt), [error-0008](../error-files/error0008.txt)  
**Included due to:**  
```
CONFIG_DRM_AMD_DC_DCN1_0=y  
```  
**Change in Kernel Configuration:** # CONFIG_DRM_AMD_DC_DCN1_0 is not set  
**Fixed By:** Change in .configfile  
**New Kernel Configuration:**  [amd_dcn_10_not_set_config](../config-files/amd_dcn_10_not_set_config)  

