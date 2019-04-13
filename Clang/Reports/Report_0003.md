# Warning Analysis Report

### General

**Warning Type:** -Wsometimes-uninitialized

**Warning Explanation:**
```
drivers/gpu/drm/i915/intel_pm.c:4670:6: warning: variable 'trans_min' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        if (INTEL_GEN(dev_priv) >= 10)
            ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/i915_drv.h:2535:29: note: expanded from macro 'INTEL_GEN'
#define INTEL_GEN(dev_priv)     ((dev_priv)->info.gen)
                                ^
drivers/gpu/drm/i915/intel_pm.c:4673:19: note: uninitialized use occurs here
        trans_offset_b = trans_min + trans_amount;
                         ^~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c:4670:2: note: remove the 'if' if its condition is always true
        if (INTEL_GEN(dev_priv) >= 10)
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/i915/intel_pm.c:4655:20: note: initialize the variable 'trans_min' to silence this warning
        uint16_t trans_min, trans_y_tile_min;
                          ^
                           = 0
```
### History

**Introduced in version:** v4.15-rc1<br/>
**Date:** 2017-08-17<br/>
**Author:** Kumar, Mahesh<br/>
**Patch:** https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca47667f523e588318f89c735e127c256de6cb16

### Warning Assessment

**File Location:** drivers/gpu/drm/i915/intel_pm.c

The variable trans_min is declared in the function<br/>
skl_compute_transition_wm
```
        uint16_t trans_min, trans_y_tile_min;
```
This variable is initialized only if the following condition is true.
```
        if (INTEL_GEN(dev_priv) >= 10)
                trans_min = 4;
```
The variable is used in two places, one within the if condition and <br/>
other is outside the condition. The trans_offset_b can have garbage <br/>
value if the trans_min is not initialized during declaration. <br/>
```
        trans_offset_b = trans_min + trans_amount;
```
### Conclusion

Clang warning is true in this case.<br/>
The variable needs to be initialised to zero.<br/>

### Fixed By

**Author:** Chris Wilson<br/>
**Date:** 2017-11-15<br/>
**Patch:** https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/gpu/drm/i915/intel_pm.c?id=be3fa66857051e2943960a06f8046e8445cdfe6e
