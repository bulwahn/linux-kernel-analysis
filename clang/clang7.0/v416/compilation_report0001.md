## Report 0001 ##
**Compilation Command:**   
```
git checkout v4.16
make clean
make allyesconfig
make CC=clang-7 HOSTCC=clang-7
```  
You should get clang-7 from ```http://apt.llvm.org/unstable/ llvm-toolchain main``` branch instead of debian bistro repo. Otherwise you may get different errors.
You can look at [docker-file](https://github.com/bulwahn/linux-kernel-analysis/blob/support-multiple-clang-versions/docker/kernel-clang-7-llvm-snapshot/Dockerfile) to understand, how to get clang-7 from llvm unstable branch.
**Used Kernel Configuration File:** [allyesconfig](../../../config-files/v4.16/allyesconfig)   
**Result:**  [rectification0001](../../../rectification-reports/rectification0001.md)  

