# Analysis Report 0007 #

## General ##
**Warning Type:** Wsign-compare  
**Warning Explanation:**```drivers/gpu/drm/i915/i915_debugfs.c:4740:16: warning: comparison of integers of different signs: 'int' and 'unsigned long' [-Wsign-compare]
        for (i = 0; i < ARRAY_SIZE(i915_debugfs_files); i++) {```  
**File Location:** drivers/gpu/drm/i915/i915_debugfs.c
## History ##
**Introduced By:** 34b9674c786c ("drm/i915: convert debugfs creation/destruction to table")  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** [Tool can detect during runtime](WarningTypeClassifications.md)
### Rationale ###
If we look at ```i915_debugfs_files``` array more carefully, we see that it is a static array, and at most it's size is 20.
So in this case ```ARRAY_SIZE(i915_debugfs_files)``` macro can't return value which is bigger than ```INT_MAX```
```C
static const struct i915_debugfs_files {
	const char *name;
	const struct file_operations *fops;
} i915_debugfs_files[] = {
	{"i915_wedged", &i915_wedged_fops},
	{"i915_max_freq", &i915_max_freq_fops},
	{"i915_min_freq", &i915_min_freq_fops},
	{"i915_cache_sharing", &i915_cache_sharing_fops},
	{"i915_ring_missed_irq", &i915_ring_missed_irq_fops},
	{"i915_ring_test_irq", &i915_ring_test_irq_fops},
	{"i915_gem_drop_caches", &i915_drop_caches_fops},
#if IS_ENABLED(CONFIG_DRM_I915_CAPTURE_ERROR)
	{"i915_error_state", &i915_error_state_fops},
	{"i915_gpu_info", &i915_gpu_info_fops},
#endif
	{"i915_next_seqno", &i915_next_seqno_fops},
	{"i915_display_crc_ctl", &i915_display_crc_ctl_fops},
	{"i915_pri_wm_latency", &i915_pri_wm_latency_fops},
	{"i915_spr_wm_latency", &i915_spr_wm_latency_fops},
	{"i915_cur_wm_latency", &i915_cur_wm_latency_fops},
	{"i915_fbc_false_color", &i915_fbc_false_color_fops},
	{"i915_dp_test_data", &i915_displayport_test_data_fops},
	{"i915_dp_test_type", &i915_displayport_test_type_fops},
	{"i915_dp_test_active", &i915_displayport_test_active_fops},
	{"i915_guc_log_control", &i915_guc_log_control_fops},
	{"i915_hpd_storm_ctl", &i915_hpd_storm_ctl_fops},
	{"i915_ipc_status", &i915_ipc_status_fops},
	{"i915_drrs_ctl", &i915_drrs_ctl_fops}
};

int i915_debugfs_register(struct drm_i915_private *dev_priv)
{
  //...
  int ret, i;
	//...
	for (i = 0; i < ARRAY_SIZE(i915_debugfs_files); i++) {
		ent = debugfs_create_file(i915_debugfs_files[i].name,
					  S_IRUGO | S_IWUSR,
					  minor->debugfs_root,
					  to_i915(minor->dev),
					  i915_debugfs_files[i].fops);
		if (!ent)
			return -ENOMEM;
	}
  //...
}
```
Clang couldn't evaulates this array size is not bigger than ```INT_MAX``` and creates a warning about it. Even if developer adds many elements to this list with another commit and list size become larger than ```INT_MAX```, a smart-tool can detect it during compile time.
