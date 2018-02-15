# Analysis Report 0006 #
#### Clang Compiler Warning Type ####
Sign Comparison
#### Warning Explanation ####
drivers/gpu/drm/i915/i915_drv.c:2234:16: warning: comparison of integers of different signs: 'int' and 'unsigned long' [-Wsign-compare]  
        for (i = 0; i < ARRAY_SIZE(s->lra_limits); i++)  
#### Introduced By: ddeea5b0c36f ("drm/i915: vlv: add runtime PM support") ####
#### Reported Since : 60d7a21aedad ("Merge tag 'nios2-v4.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2")  ####
#### File Location: drivers/gpu/drm/i915/i915_drv.c ####
#### Resolved By: -- ####
#### Manuel Assesment ####
Clang compiler creates a warning about:  
```C
static void vlv_save_gunit_s0ix_state(struct drm_i915_private *dev_priv)
{
	struct vlv_s0ix_state *s = &dev_priv->vlv_s0ix_state;
	int i;
//...
  for (i = 0; i < ARRAY_SIZE(s->lra_limits); i++)
//...
};
```
In the for loop, there is a comparision between Array size of ```s->lra_limits``` and ```int i``` and Clang compiler finds it suspicious.

To understand this ,we must look at ```struct vlv_s0ix_state``` which defined inside drm/i915/i915_drv.h:  
```C
struct vlv_s0ix_state {
	/* GAM */
	u32 wr_watermark;
	u32 gfx_prio_ctrl;
	u32 arb_mode;
	u32 gfx_pend_tlb0;
	u32 gfx_pend_tlb1;
	u32 lra_limits[GEN7_LRA_LIMITS_REG_NUM];
}; 
```
Programmer defined lra_limits size as ```GEN_7_LRA_LIMITS_REG_NUM``` which is a static constant defined in drm/i915/i915_reg.h as following:
```C
#define GEN7_LRA_LIMITS_REG_NUM	13
```
```GEN7_LRA_LIMITS_REG_NUM``` value is static and between ```int``` limits, there won't be any problem theoratically.
        
