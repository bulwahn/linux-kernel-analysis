# Analysis Report 0003 #
## General ##
**Warning Type:** Wsign-compare  
**Warning Explanation:** ```drivers/gpu/drm/i915/intel_dpll_mgr.c:1239:18: warning: comparison of integers of different signs: 'unsigned int' and 'const int' [-Wsign-compare]
for (i = 0; i < dividers[d].n_dividers; i++) {```  
**File Location:** drivers/gpu/drm/i915/intel_dpll_mgr.c
## History ##
**Introduced By:** dc2538139277 ("drm/i915/skl: Replace the HDMI DPLL divider computation algorithm")  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** [Mathematically Impossible](WarningTypeClassifications.md)  
### Rationale ###
Clang creates a warning about
```C
	static const int even_dividers[] = {  4,  6,  8, 10, 12, 14, 16, 18, 20,
					     24, 28, 30, 32, 36, 40, 42, 44,
					     48, 52, 54, 56, 60, 64, 66, 68,
					     70, 72, 76, 78, 80, 84, 88, 90,
					     92, 96, 98 };
	static const int odd_dividers[] = { 3, 5, 7, 9, 15, 21, 35 };
	static const struct {
		const int *list;
		int n_dividers;
	} dividers[] = {
		{ even_dividers, ARRAY_SIZE(even_dividers) },
		{ odd_dividers, ARRAY_SIZE(odd_dividers) },
	};
	struct skl_wrpll_context ctx;
	unsigned int dco, d, i;
	unsigned int p0, p1, p2;

	skl_wrpll_context_init(&ctx);

	for (d = 0; d < ARRAY_SIZE(dividers); d++) {
		for (dco = 0; dco < ARRAY_SIZE(dco_central_freq); dco++) {
			for (i = 0; i < dividers[d].n_dividers; i++) {
				unsigned int p = dividers[d].list[i];
				uint64_t dco_freq = p * afe_clock;

				skl_wrpll_try_divider(&ctx,
						      dco_central_freq[dco],
						      dco_freq,
						      p);
				/*
				 * Skip the remaining dividers if we're sure to
				 * have found the definitive divider, we can't
				 * improve a 0 deviation.
				 */
				if (ctx.min_deviation == 0)
					goto skip_remaining_dividers;
			}
		}
	}
```
In this case , clang points out that ``` d ``` is an ``` unsigned int ```, however ```C dividers[d].n_dividers``` is an ```C int```.  
Even though this case seems suspicious and actually problematic in theory. In practice, it won't cause any problems.   Because the only risk is in here if ``` static const int even_dividers[] ``` or ``` static const int odd_dividers``` size is bigger than ```INT_SIZE``` ( > 2^31), then ``` int n_dividers``` will start get a negative value[integer overflow]. However in practice we cannot store a number which has more than 2^31 even or odd dividers in an ``` unsigned int```.
It is a **mathematically impossible** warning.
