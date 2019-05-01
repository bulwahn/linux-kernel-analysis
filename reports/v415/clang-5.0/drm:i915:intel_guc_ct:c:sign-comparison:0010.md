# Analysis Report 0010 #  
#### Clang Compiler Warning ####  
Sign Comparision  
#### Warning Explanation ####  
drivers/gpu/drm/i915/intel_guc_ct.c:162:16: warning: comparison of integers of different signs: 'int' and 'unsigned long' [-Wsign-compare]
        for (i = 0; i < ARRAY_SIZE(ctch->ctbs); i++) {  
#### Introduced By: f8a58d639dd9 ("drm/i915/guc: Introduce buffer based cmd transport")  ####
#### Reported Since : 60d7a21aedad ("Merge tag 'nios2-v4.16-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/lftan/nios2")  ####
#### File Location: drivers/gpu/drm/i915/intel_guc_ct.c ####
#### Solution Commit: -- ####

#### Manuel Assesment: ####
Clang creates a warning about:
```C
static int ctch_init(struct intel_guc *guc,
		     struct intel_guc_ct_channel *ctch)
{
  //...
	int i;

	/* store pointers to desc and cmds */
	for (i = 0; i < ARRAY_SIZE(ctch->ctbs); i++) {
		GEM_BUG_ON((i != CTB_SEND) && (i != CTB_RECV));
		ctch->ctbs[i].desc = blob + PAGE_SIZE/4 * i;
		ctch->ctbs[i].cmds = blob + PAGE_SIZE/4 * i + PAGE_SIZE/2;
	}
	//...
}
```
```struct intel_guc_ct_channel``` defined in drm/i915/intel_guc_ct.h as;
```C
/** Represents pair of command transport buffers.
 *
 * Buffers go in pairs to allow bi-directional communication.
 * To simplify the code we place both of them in the same vma.
 * Buffers from the same pair must share unique owner id.
 *
 * @vma: pointer to the vma with pair of CT buffers
 * @ctbs: buffers for sending(0) and receiving(1) commands
 * @owner: unique identifier
 * @next_fence: fence to be used with next send command
 */
struct intel_guc_ct_channel {
	struct i915_vma *vma;
	struct intel_guc_ct_buffer ctbs[2];
	u32 owner;
	u32 next_fence;
};
```
In there we observe that programmers defined ctbs array with a static length, but clang couldn't find-out that value is static and raised a warning about this line. This line won't cause any problem during runtime.
