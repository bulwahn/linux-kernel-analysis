## Report 0004 #  
**Compilation Command:** make CC=clang-5.0 HOSTCC=clang-5.0 -j40  
**Kernel Configuration File:** [allyesconfig](../config-files/allyesconfig)  
**Head Commit:** d3412c7ad6ef ("amdgpu/dc/dml: Support clang option for stack alignment")  
**Filename:** drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c,  drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_math.c,  drivers/gpu/drm/amd/display/dc/calcs/dcn_calc_auto.c,  drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c, drivers/media/platform/qcom/camss-8x16/camss-csid.c, drivers/media/platform/qcom/camss-8x16/camss-csiphy.c, drivers/media/platform/qcom/camss-8x16/camss-ispif.c, drivers/media/platform/qcom/camss-8x16/camss-vfe.c  
**Error Message:** [error-0005](../error-files/error0005.md), [error-0006](../error-files/error0006.md), [error-0007](../error-files/error0007.md), [error-0008](../error-files/error0008.md), [error-0009](../error-files/error0009.md), [error-0010](../error-files/error0010.md), [error-0011](../error-files/error0011.md), [error-0012](../error-files/error0012.md)  
**Included due to:**
For drivers/gpu/drm/amd/display errors:  
```
CONFIG_DRM_AMD_DC_DCN1_0=y  
```  
**Change in Kernel Configuration:** # CONFIG_DRM_AMD_DC_DCN1_0 is not set  
**Fixed By:** Change in .configfile  
**New Kernel Configuration:**  [amd_dcn_10_not_set_config](../config-files/amd_dcn_10_not_set_config)  

