# Warning Analysis Report

### General

**Warning Type:** Wparentheses-equality<br/>
**Warning Explanation:**
```
drivers/crypto/cavium/zip/zip_regs.h:820:15: warning: equality comparison with
      extraneous parentheses [-Wparentheses-equality]
        if (((param1 == 0)))
              ~~~~~~~^~~~
drivers/crypto/cavium/zip/zip_regs.h:820:15: note: remove extraneous parentheses
      around the comparison to silence this warning
        if (((param1 == 0)))
            ~        ^    ~
drivers/crypto/cavium/zip/zip_regs.h:820:15: note: use '=' to turn this equality
      comparison into an assignment
        if (((param1 == 0)))
```
### History

**Date:** 2017-02-15<br/>
**Version:** v4.12-rc1<br/>
**Author:** Mahipal Challa<br/>
Patch: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=640035a2dc5534b49cd64580e41874b71f131a1c

### Warning Assessment

**File Location:** drivers/crypto/cavium/zip/zip_regs.h
```
static inline u64 ZIP_MSIX_PBAX(u64 param1)
{
 if (((param1 == 0)))
 return 0x0000838000FF0000ull;
 pr_err("ZIP_MSIX_PBAX: %llu\n", param1);
 return 0;
}
```
The warning is true. There are few other places in the same file, where
extra parentheses is used. One of them is in ZIP_MSIX_VECX_ADDR
function.
```
static inline u64 ZIP_MSIX_VECX_ADDR(u64 param1)
{
 if (((param1 <= 17)))
 return 0x0000838000F00000ull + (param1 & 31) * 0x10ull;
 pr_err("ZIP_MSIX_VECX_ADDR: %llu\n", param1);
 return 0;
}
```
### Solution

Use the following Coccinelle script to remove extra parentheses.
```
@@
identifier i;
constant c;
@@
(
-((i == c))
+i == c
|
-((i <= c))
+i <= c
)
```
