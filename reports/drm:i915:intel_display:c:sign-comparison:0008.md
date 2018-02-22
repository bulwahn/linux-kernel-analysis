# Analysis Report 0008 #
## General ##
**Warning Type:** Wsign-Compare    
**Warning Explanation:** ```drivers/gpu/drm/i915/intel_display.c:13463:14: warning: comparison of integers of different signs: 'enum pipe' and 'unsigned long' [-Wsign-compare]
        BUG_ON(pipe >= ARRAY_SIZE(dev_priv->plane_to_crtc_mapping) ||```    
**File Location:** rivers/gpu/drm/i915/intel_display.c  
## History ##
**Introduced By:** 22fd0fab3b51 ("drm/i915: pageflip fixes")  
**Reported Since:** TODO  
**Resolved By:** --  
## Manuel Assesment ##
**Classification:** [Tool can detect during compile time](WarningTypeClassifications.md)
### Rationale ###
Clang compiler creates a warning for part of ```intel_crtc_init``` function;
```C
static int intel_crtc_init(struct drm_i915_private *dev_priv, enum pipe pipe)
{
//...
	BUG_ON(pipe >= ARRAY_SIZE(dev_priv->plane_to_crtc_mapping) ||
	       dev_priv->plane_to_crtc_mapping[primary->i9xx_plane] != NULL);
//...
}
```

```struct drm_i915_private``` is defined in **drivers/gpu/drm/i915/i915_drv.h** file as following:
```C
struct drm_i915_private {
//...
  struct intel_crtc *plane_to_crtc_mapping[I915_MAX_PIPES];
	struct intel_crtc *pipe_to_crtc_mapping[I915_MAX_PIPES];
//...
}
```
Also ```enum pipe``` and ```I915_MAX_PIPES``` are defined in **drivers/gpu/drm/i915/intel_display.h**;
```C
enum pipe {
	INVALID_PIPE = -1,

	PIPE_A = 0,
	PIPE_B,
	PIPE_C,
	_PIPE_EDP,

	I915_MAX_PIPES = _PIPE_EDP
};
```
```I915_MAX_PIPES``` is a constant value , and always equal to ```_PIPE_EDP``` value. In C , enum values are unsigned, so when pipe value equals to ```INVALID_PIPE``` it also evaluates ```true ``` in this comparison. As long as I915_MAX_PIPES equal to \_PIPE_EDP there won't be any problem. If it changes, a smart-tool can detect there may be a problem, during compile time.
