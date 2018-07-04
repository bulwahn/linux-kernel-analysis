## Rectification 0006 ##
**Error Location:** arch/x86, fs/, security/, crypto/, lib/, drivers/, sound/core/, net/  
**Included due to:** .configfile  
```
CONFIG_KASAN=y  
```  
**Error Message:**  
- [error-0013](../error-files/error0013.txt)  
- [error-0014](../error-files/error0014.txt)  
- [error-0015](../error-files/error0015.txt)  
- [error-0016](../error-files/error0016.txt)  
- [error-0017](../error-files/error0017.txt)  
- [error-0018](../error-files/error0018.txt)  
- [error-0019](../error-files/error0019.txt)  
- [error-0020](../error-files/error0020.txt)  
  
**Fixed By:**
- [don't emin built-in calls](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch/?id=0e410e158e5baa1300bdf678cea4f4e0cf9d8b94)
- [support LLVM style asan params](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch?id=1a69e7ce8391a8bc808baf04e06d88ab4024ca47)
- [support alloca poisoning](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch?id=342061ee4ef3d80001d1ae494378f3979c861dba)
- [add functions for](https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/patch?id=d321599cf6b861beefe92327476b617435c7fc4a)

