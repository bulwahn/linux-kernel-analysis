## Report 0002 #  
**Compilation Command:** 
```
git checkout v4.16  
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch  
make clean  
make allyesconfig  
make CC=clang-5.0 HOSTCC=clang-5.0  
```
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Filename:** drivers/gpu/drm/amd/display/dc/calcs/Makefile:27  
**Error Message:** [error-0003](../error-files/error0003.txt)  
**Included due to:** drivers/gpu/drm:59  
```
obj-$(CONFIG_DRM_AMDGPU)+= amd/amdgpu/
```
**Change in Kernel Configuration:** Fixed by commits  
**Fixed By:** [amd-gpu-dc-cals-first](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=37172013fa2e527735ec9eda51a11cfea3af0ff1), [amd-gpu-dc-cals-second](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=cc32ad8f559c36ca2433d282aff690a6842a3a27)  
**New Kernel Configuration:**[allyesconfig](../config-files/allyesconfig)  

