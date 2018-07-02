## Infer DEAD_STORE false-posive problem ##
**Infer Version:** : Infer version v0.15.0  
**Kernel-Version:** : Linux-4.16  
**Original Warning:** : [kernel/sched/fair.c](https://github.com/OzanAlpay/linux-kernel-analysis/blob/clang-warning-reports/reports/v416/infer-015/kernel:sched:fair:c:deadstorage:0007.md)  
### Testing ###
**Case 1:**  
```
cd infer-false-positive-dead-store-with-macro
infer capture -- make
infer analyze
```
**Output:**  
```
Found 1 issue

lib.h:10: error: DEAD_STORE
  The value written to &var (type unsigned long) is never used.
  8.   
  9.   int dummy_func() {
  10. > 	unsigned long var = 5;
  11.   	srand(time(NULL));
  12.   	d_struct rnd;

```
**Expected Output:**  
```
No issues found.
```  
**Case 2:**
```
cd infer-no-dead-store-without-macro
infer capture -- make
infer analyze
```
**Output:**
```
No issues found
```
**Expected Output:**
```
No issues found
```

**Summary:**
Only difference between this two examples is:  
In [infer-false-positive-dead-store-with-macro/macros.h](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation/infer/MockCodes/infer-dead-store-macro/infer-false-positive-dead-store-with-macro/macros.h), Inside ```time_after``` macro, we check types with using ```typecheck``` macro, and then compare.
```C
#define typecheck(type,x) \
({      type __dummy; \
        typeof(x) __dummy2; \
        (void)(&__dummy == &__dummy2); \
        1; \
})
#define time_after(a,b)         \
        (typecheck(unsigned long, a) && \
         typecheck(unsigned long, b) && \
         ((long)((b) - (a)) < 0))
#define time_before(a,b)        time_after(b,a)
```  
However [infer-no-dead-store-without-macro/macros.h](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation/infer/MockCodes/infer-dead-store-macro/infer-no-dead-store-without-macro/macros.h), we directly compare these two values and then return result.  
```C
#define time_after(a,b)         \
        (((long)((b) - (a)) < 0))
#define time_before(a,b)        time_after(b,a)

```
These two files infer output should be equal to ```No issues found```. Because in both cases, we assign a value to just compare two different unsigned integers, and return the result of comparision.
In addition to that, In Linux Kernel-v4.16, ```include/linux/typecheck.h``` file, typecheck macro defined as following:
```
/*
 * Check at compile time that something is of a particular type.
 * Always evaluates to 1 so you may use it easily in comparisons.
 */
#define typecheck(type,x) \
({	type __dummy; \
	typeof(x) __dummy2; \
	(void)(&__dummy == &__dummy2); \
	1; \
})
```
As developer stated in comment, these macro is just a check for compile-time and don't have any effect for run-time. Infer is wrong to create a warning for this macro.
**Further Results:**
Also I completed an ```infer-0.15.0``` run on Linux Kernel-v4.16 with using defconfig after applying:
```
diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
index 20d3103..5638505 100644
--- a/include/linux/typecheck.h
+++ b/include/linux/typecheck.h
@@ -6,12 +6,7 @@
  * Check at compile time that something is of a particular type.
  * Always evaluates to 1 so you may use it easily in comparisons.
  */
-#define typecheck(type,x) \
-({     type __dummy; \
-       typeof(x) __dummy2; \
-       (void)(&__dummy == &__dummy2); \
-       1; \
-})
+#define typecheck(type,x) 1
 
 /*
  * Check at compile time that 'function' is a certain type, or is a pointer
```
You can find results according to this run in : [Link-to-File](), and without patch : [Link-to-File]().
As you can observe that, there is diff_number of difference about result_type.

