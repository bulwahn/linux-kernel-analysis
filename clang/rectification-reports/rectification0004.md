## Rectification 0004 ##
**Error Location:** drivers/gpu/drm/amd/display/dc/calcs, drivers/gpu/drm/amd/display/dc/dml  
**Included due to:** .configfile  
```
CONFIG_DRM_AMD_DC_DCN1_0=y  
```
**Error Message:**  
- [error-0005](../error-files/error0005.txt)  
- [error-0006](../error-files/error0006.txt)  
- [error-0007](../error-files/error0007.txt)  
- [error-0008](../error-files/error0008.txt)  
    
**Fixed By:** Change in Kernel Configuration  
```
  # CONFIG_DRM_AMD_DC_DCN1_0 is not set  
```
