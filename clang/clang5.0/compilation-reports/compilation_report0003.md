## Report 0002 #  
**Compilation Command:**  
```
git checkout v4.16  
wget https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=b0e55b731abcfd19265e3e80b1d4c0fec337fb7b -O exofs.patch  
git am exofs.patch
git cherry-pick 37172013fa2e
git cherry-pick cc32ad8f559c
make clean
make allyesconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Filename:** drivers/gpu/drm/amd/display/dc/dml/Makefile:27  
**Error Message:** [error-0004](../error-files/error0004.txt)  
**Included due to:** drivers/gpu/drm:59  
```
obj-$(CONFIG_DRM_AMDGPU)+= amd/amdgpu/
```
**Change in Kernel Configuration:** Fixed by commit  
**Fixed By:** [amd-gpu-dc-dml-first](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=a27267e01ffa377e854645548b0bb11a5051c36c), [amd-gpu-dc-dml-second](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=4007e92bebebb65b8a1798e6bc9e21def9a1eab9), [amd-gpu-dc-dml-third](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch?id=4769278e5c7fd2be445e4a34f834d40475fcb0ce)  
**New Kernel Configuration:**[allyesconfig](../config-files/allyesconfig)  
