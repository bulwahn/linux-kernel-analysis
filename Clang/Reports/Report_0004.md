# Warning Analysis Report

### General

**Warning Type:** -Wsometimes-uninitialized

**Warning Explanation:**
```
drivers/gpu/drm/i915/intel_crt.c:815:11: warning: variable 'status' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
        else if (ret < 0)
                 ^~~~~~~
drivers/gpu/drm/i915/intel_crt.c:820:9: note: uninitialized use occurs here
        return status;
               ^~~~~~
drivers/gpu/drm/i915/intel_crt.c:815:7: note: remove the 'if' if its condition is always true
        else if (ret < 0)
             ^~~~~~~~~~~~
drivers/gpu/drm/i915/intel_crt.c:755:12: note: initialize the variable 'status' to silence this warning
        int status, ret;
                  ^
                   = 0
```
### History

**Introduced in version:** v4.12-rc1<br/>
**Date:** 2017-04-06<br/>
**Author:** Maarten Lankhorst<br/>
**Patch:** https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6c5ed5ae353cdf156f9ac4db17e15db56b4de880

### Warning Assessment

**File Location:** drivers/gpu/drm/i915/intel_pm.c

In the function static int intel_crt_detect,<br/>
The variable is declared as<br/>
```
int status, ret;
```
Here the variable status is used within if blocks only. Variable status<br/>
is always initialized to some value. The else if bock for condition<br/>
ret < 0 needs to be changed to else block.<br/>
```
        ret = intel_get_load_detect_pipe(connector, NULL, &tmp, ctx);
        if (ret > 0) {
                if (intel_crt_detect_ddc(connector))
                        status = connector_status_connected;
                else if (INTEL_GEN(dev_priv) < 4)
                        status = intel_crt_load_detect(crt,
                                to_intel_crtc(connector->state->crtc)->pipe);
                else if (i915_modparams.load_detect_test)
                        status = connector_status_disconnected;
                else
                        status = connector_status_unknown;
                intel_release_load_detect_pipe(connector, &tmp, ctx);
        } else if (ret == 0)
                status = connector_status_unknown;
        else if (ret < 0)
                status = ret;
```
### Conclusion

The Clang warning is true in this case too. It suggests two solutions<br/>
1) remove the 'if' if its condition is always true<br/>
2) initialize the variable 'status' to silence this warning<br/>

I would prefer solution 1 here, as status is always initialized to some integer value.

### Fixed By

**Author:** Chris Wilson<br/>
**Date:** 2018-02-08<br/>
**Patch:** https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/gpu/drm/i915/intel_crt.c?id=2927e4211f76893249cfa8e7ac5fe1c73ae791c1
