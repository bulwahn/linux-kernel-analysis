## Report 0001 ##
**Compilation Command:**   
```
git checkout v4.16
make clean
make allnoconfig
make CC=clang-5.0 HOSTCC=clang-5.0
```  
You should get clang-7 from ```http://apt.llvm.org/unstable/ llvm-toolchain main``` branch instead of debian bistro repo. Otherwise you may get different errors.
You can look at [docker-file](https://github.com/bulwahn/linux-kernel-analysis/blob/support-multiple-clang-versions/docker/kernel-clang-7-llvm-snapshot/Dockerfile) to understand, how to get clang-7 from llvm unstable branch.  
**Used Kernel Configuration File:** [allnoconfig](../../../config-files/v4.16/allnoconfig)   
**Result:**  [rectification0007](../../../rectification-reports/rectification0007.md)  

