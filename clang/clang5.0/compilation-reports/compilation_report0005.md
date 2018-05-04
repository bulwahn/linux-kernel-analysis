## Report 0005 #  
**Compilation Command:** make CC=clang-5.0 HOSTCC=clang-5.0 -j40  
**Kernel Configuration File:** [amd_dcn_10_not_set_config](../config-files/amd_dcn_10_not_set_config)  
**Head Commit:** f221829b62ba ("exofs: avoid VLA in structures")  
**Filename:** drivers/media/platform/qcom/camss-8x16/camss-csid.c, drivers/media/platform/qcom/camss-8x16/camss-csiphy.c, drivers/media/platform/qcom/camss-8x16/camss-ispif.c, drivers/media/platform/qcom/camss-8x16/camss-vfe.c  
**Error Message:** [error-0009](../error-files/error0009.md), [error-0010](../error-files/error0010.md), [error-0011](../error-files/error0011.md), [error-0012](../error-files/error0012.md)  
**Included due to:**  
```
CONFIG_VIDEO_QCOM_CAMSS=y  
```  
**Change in Kernel Configuration:**   
```
CONFIG_VIDEO_QCOM_CAMSS=n  
```  
**Fixed By:** Change in .configfile  
**New Kernel Configuration:** [final-config](../config-files/final-config)  
