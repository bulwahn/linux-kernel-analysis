## Report 0002 #  
**Compilation Command:** make CC=clang-5.0 HOSTCC=clang-5.0 -j40  
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Head Commit:** f221829b62ba ("exofs: avoid VLA in structures")  
**Filename:** drivers/gpu/drm/amd/display/dc/calcs/Makefile:27  
**Error Message:** [error-0003](../error-files/error0003.md)  
**Included due to:** drivers/gpu/drm:59  
```
obj-$(CONFIG_DRM_AMDGPU)+= amd/amdgpu/
```
**Change in Kernel Configuration:** Fixed by commit  
**Fixed By:** [amd-gpu-dc-cals-first](../fix-patches/amdgpu-dc-cals-first.patch), [amd-gpu-dc-cals-second](../fix-patches/amdgpu-dc-cals-second.patch)  
**New Kernel Configuration:**[allyesconfig](../config-files/allyesconfig)  

