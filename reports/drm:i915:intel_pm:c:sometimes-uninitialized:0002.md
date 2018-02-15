# Analysis Report 0002 #
#### Clang Compiler Warning Type ####
Sometimes Uninitialized
#### Warning Explanation  ####
drivers/gpu/drm/i915/intel_pm.c:4670:6: warning: variable 'trans_min' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]  
        if (INTEL_GEN(dev_priv) >= 10)
#### Introduced By: ca47667f523e ("drm/i915/gen10: Calculate and enable transition WM")  ####
#### Reported Since : 60d7a21aedad ("Merge tag 'nios2-v4.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2")  ####
#### File Location: drivers/gpu/drm/i915/intel_pm.c  ####
#### Resolved By: -- ####

#### Manuel Assesment  ####
Clang creates a warning about code part:  
```C
	/* Transition WM are not recommended by HW team for GEN9 */
	if (INTEL_GEN(dev_priv) <= 9)
		goto exit;

	/* Transition WM don't make any sense if ipc is disabled */
	if (!dev_priv->ipc_enabled)
		goto exit;

	if (INTEL_GEN(dev_priv) >= 10)
		trans_min = 4;

	trans_offset_b = trans_min + trans_amount;

	//...

exit:
	trans_wm->plane_en = false;
```

1 - ``` INTEL_GEN ``` is a macro defined in drm/i915/i915_drv.h:2939 as following:
```C 
#define INTEL_GEN(dev_priv)	((dev_priv)->info.gen)
```
So basically it is just a getter function that returns ``` drm_i915_private->info->gen ```  
2- ``` struct drm_i915_private ```  defined in drm/i915/i915_drv.h:2233 as:  
```C
struct drm_i915_private {
//...
const struct intel_device_info info;
//... 
}
```
3- As a third step, we must check ``` intel_device_info.gen ```'s type
4- ``` struct intel_device_info ``` defined in drm/i915/i915_drv.h:853 as:  
```C
struct intel_device_info {
//...
u8 gen;
//...
};
```
5-As a result of this observations since ```intel_device_info.gen``` is a u8 type, it always be initialized in this code structure. It won't create any problems theoretically
