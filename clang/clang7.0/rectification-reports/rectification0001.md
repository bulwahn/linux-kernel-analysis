## Rectification 0001 ##
**Error Location:** arch/x86/hyperv/mmu.c  
**Included Due To:** arch/x86/include/asm/mshyperv.h  
```
 #if IS_ENABLED(CONFIG_HYPERV)
```
**Error Message:** [error0001](../error-files/error0001.txt)  
**Fixed By:** Change in Kernel Configuration  
```
 #
 # Microsoft Hyper-V guest support
 #
 # CONFIG_HYPERV is not set
 # CONFIG_HYPERV_TSCPAGE is not set
```


