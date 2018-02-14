# Analysis Report 0009 #
#### Clang Compiler Warning Type ####  
Sign Comparison  
#### Warning Explanation ####  
drivers/gpu/drm/i915/i915_gem_timeline.c:124:17: warning: comparison of integers of different signs: 'int' and 'unsigned long' [-Wsign-compare]
                for (i = 0; i < ARRAY_SIZE(timeline->engine); i++) {
        
#### Introduced By: d51dafaf07bf ("drm/i915: Assert all timeline requests are gone before fini") ####
#### Version: Linux-Next ####
#### File Location: drm/i915/i915_gem_timeline.c ####
#### Resolved By: -- ####

#### Manuel Assesment ####
Clang creates a warning about:
```C
void i915_gem_timeline_fini(struct i915_gem_timeline *timeline)
{
	int i;

	lockdep_assert_held(&timeline->i915->drm.struct_mutex);

	for (i = 0; i < ARRAY_SIZE(timeline->engine); i++)
		__intel_timeline_fini(&timeline->engine[i]);

	list_del(&timeline->link);
	kfree(timeline->name);
}
```
```struct i915_gem_timeline``` is defined in drivers/gpu/drm/i915/i915_gem_timeline.h as;
```C
struct i915_gem_timeline {
	struct list_head link;

	struct drm_i915_private *i915;
	const char *name;

	struct intel_timeline engine[I915_NUM_ENGINES];
};
```
and value of ```I915_NUM_ENGINES``` defined in drivers/gpu/drm/i915/i915_gem.h;  
```C  
#define I915_NUM_ENGINES 5 
```
So there isn't any risk in this case theoretically. Clang couldn't find-out ```engine[I915_NUM_ENGINES]``` array length is static and equal to 5

