## Report 0002 #  
**Compilation Command:** make CC=clang-5.0 HOSTCC=clang-5.0 -j40  
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Head Commit:** bae0398c91c0 ("amdgpu/dc/calcs: Support clang option for stack alignment")  
**Filename:** drivers/gpu/drm/amd/display/dc/dml/Makefile:27  
**Error Message:** [error-0004](../error-files/error0004.md)  
**Included due to:** drivers/gpu/drm:59  
```
obj-$(CONFIG_DRM_AMDGPU)+= amd/amdgpu/
```
**Change in Kernel Configuration:** Fixed by commit  
**Fixed By:** [amd-gpu-dc-dml-first](../fix-patches/amdgpu-dc-dml-first.patch), [amd-gpu-dc-dml-second](../fix-patches/amdgpu-dc-dml-second.patch), [amd-gpu-dc-dml-third](../fix-patches/amdgpu-dc-dml-third.patch)  
**New Kernel Configuration:**[allyesconfig](../config-files/allyesconfig)  s
