# Analysis Report 0001 #
#### Clang Compiler Warning Type  ####
Enum-Conversion
#### Warning Explanation: ####  
Implicit conversion from enumeration type 'enum port' to different enumeration type 'enum intel\_dpll\_id' [-Wenum-conversion]     
enum intel\_dpll\_id pll\_id = port;   
#### Introduced By: 2952cd6fb4cc \("drm/i915: Let's use more enum intel\_dpll_id pll\_id."\)  ####  
#### Version: 4.15 Stable Version  ####  
#### File Location: drm/i915/intel\_ddi.c  ####  
#### Resolved By: bb911536f07e ("drm/i915: Eliminate pll->state usage from bxt\_calc\_pll_link()")  ####   

#### Manuel Assesment ####  
```C
static void bxt_ddi_clock_get(struct intel_encoder *encoder,  
                                struct intel_crtc_state *pipe_config)  
{  
	struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);  
	enum port port = intel_ddi_get_encoder_port(encoder);  
	enum intel_dpll_id pll_id = port; //This line creates warning  
	pipe_config->port_clock = bxt_calc_pll_link(dev_priv, pll_id);   
	ddi_dotclock_get(pipe_config);  
}  
```
There is an implicit conversion problem between enum intel\_dpll\_id and enum port. To clearly understand this problem, we must look definitions of enum port and enum intel\_dpll\_id:

#### enum intel\_dpll\_id ####  
File location: /drm/i915/intel\_dpll\_mgr.h:48  
```C
enum intel_dpll_id {  
	/**  
	  * @DPLL_ID_PRIVATE: non-shared dpll in use   
	 */ 
	DPLL_ID_PRIVATE = -1,  
	/**  
	 * @DPLL_ID_PCH_PLL_A: DPLL A in ILK, SNB and IVB  
	 */  
	DPLL_ID_PCH_PLL_A = 0,  
	/**  
	 * @DPLL_ID_PCH_PLL_B: DPLL B in ILK, SNB and IVB  
	 */  
	DPLL_ID_PCH_PLL_B = 1,   
	/**   
	 * @DPLL_ID_WRPLL1: HSW and BDW WRPLL1   
	 */   
	DPLL_ID_WRPLL1 = 0,   
	/**   
	 * @DPLL_ID_WRPLL2: HSW and BDW WRPLL2   
	 */     
	DPLL_ID_WRPLL2 = 1,   
	/**   
	 * @DPLL_ID_SPLL: HSW and BDW SPLL   
	 */   
	DPLL_ID_SPLL = 2,   
	/**  
	 * @DPLL_ID_LCPLL_810: HSW and BDW 0.81 GHz LCPLL  
	 */  
	DPLL_ID_LCPLL_810 = 3,  
	/**    
	 * @DPLL_ID_LCPLL_1350: HSW and BDW 1.35 GHz LCPLL  
	 */  
	DPLL_ID_LCPLL_1350 = 4,  
	/**  
	 * @DPLL_ID_LCPLL_2700: HSW and BDW 2.7 GHz LCPLL  
	 */  
	DPLL_ID_LCPLL_2700 = 5,  
	/**  
	 * @DPLL_ID_SKL_DPLL0: SKL and later DPLL0  
	 */  
	DPLL_ID_SKL_DPLL0 = 0,  
	/**  
	 * @DPLL_ID_SKL_DPLL1: SKL and later DPLL1  
	 */  
	DPLL_ID_SKL_DPLL1 = 1,  
	/**  
	 * @DPLL_ID_SKL_DPLL2: SKL and later DPLL2  
	 */  
	DPLL_ID_SKL_DPLL2 = 2,  
	/**  
	 * @DPLL_ID_SKL_DPLL3: SKL and later DPLL3  
	 */  
	DPLL_ID_SKL_DPLL3 = 3,  
};  
```
#### enum port ####   
File location: /drm/i915/i915v\_drv.h:342   
```C
enum port {  
	PORT_NONE = -1,  
	PORT_A = 0,  
	PORT_B,  
	PORT_C,  
	PORT_D,  
	PORT_E,  
	I915_MAX_PORTS  
};  
```

#### Investigation of solution commit:
Commit bb911536f07e modified the part of bxt\_ddi\_clock\_get function , which was creating warning:  
```diff
-       struct drm_i915_private *dev_priv = to_i915(encoder->base.dev);  
-       enum port port = encoder->port;  
-       enum intel_dpll_id pll_id = port;  
-       pipe_config->port_clock = bxt_calc_pll_link(dev_priv, pll_id);  
+       pipe_config->port_clock = bxt_calc_pll_link(pipe_config);  
```

So, as a result o this commit, there isn't any conversion between port and intel\_dpll_id , and the enum-conversion warning is  disappeared.

