# Warning Analysis Report

### General

**_Warning Type:_** -Wunused-parameter<br/>
**_Warning Explanation:_**

> In file included from ./include/linux/compiler.h:246:<br/>
 ./include/linux/kasan-checks.h:9:58: warning: unused parameter 'p' [-Wunused-parameter]<br/>
 static inline void kasan_check_read(const volatile void *p, unsigned int size)<br/>
 ./include/linux/kasan-checks.h:9:74: warning: unused parameter 'size' [-Wunused-parameter]<br/>
 static inline void kasan_check_read(const volatile void *p, unsigned int size)<br/>
 ./include/linux/kasan-checks.h:11:59: warning: unused parameter 'p' [-Wunused-parameter]<br/>
 static inline void kasan_check_write(const volatile void *p, unsigned int size)<br/>
 ./include/linux/kasan-checks.h:11:75: warning: unused parameter 'size' [-Wunused-parameter]<br/>
 static inline void kasan_check_write(const volatile void *p, unsigned int size)<br/>

### History

**_Introduced in version:_** v4.7-rc1<br/>
**_Date:_** 2016-05-20<br/>
**_Author:_** Andrey Ryabinin<br/>
**_Patch:_**
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=64f8ebaf115bcddc4aaa902f981c57ba6506bc42

#### Recent Changes

**_Date:_** 2017-06-22<br/>
**_Author:_** Dmitry Vyukov<br/>
**_Patch:_** https://patchwork.kernel.org/patch/9768477/

### Warning Assessment

**_File Location:_** include/linux/kasan-checks.h

```
#ifdef CONFIG_KASAN
void kasan_check_read(const volatile void *p, unsigned int size);
void kasan_check_write(const volatile void *p, unsigned int size);
#else
static inline void kasan_check_read(const volatile void *p, unsigned int size)
{ }
static inline void kasan_check_write(const volatile void *p, unsigned int size)
{ }
#endif
```

### Conclusion

Warning is true but the functions kasan_check_{read, write} were
purposefully made empty. So, ignore this warning.

### Observations

I checked few other warnings of the same type. If the file is located in
include directory, then most of them needs to be ignored due to one of
the following reasons:

1. If some macro is not defined then empty function with parameter is used.<br/>
   The function is made purposefully empty as there are non empty functions<br/>
   used when the macro is defined.

Example Warnings:

> In file included from ./include/linux/kernel.h:14:<br/>
 ./include/linux/printk.h:519:53: warning: unused parameter 'prefix_str' [-Wunused-parameter]<br/>
 static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,<br/>
 ./include/linux/printk.h:519:69: warning: unused parameter 'prefix_type' [-Wunused-parameter]<br/>
 static inline void print_hex_dump_debug(const char *prefix_str, int prefix_type,<br/>
 ./include/linux/printk.h:520:10: warning: unused parameter 'rowsize' [-Wunused-parameter]<br/>
                                        int rowsize, int groupsize,<br/>
 ./include/linux/printk.h:520:23: warning: unused parameter 'groupsize' [-Wunused-parameter]<br/>
                                        int rowsize, int groupsize,<br/>
 ./include/linux/printk.h:521:18: warning: unused parameter 'buf' [-Wunused-parameter]<br/>
                                        const void *buf, size_t len, bool ascii)<br/>
 ./include/linux/printk.h:521:30: warning: unused parameter 'len' [-Wunused-parameter]<br/>
                                        const void *buf, size_t len, bool ascii)<br/>
 ./include/linux/printk.h:521:40: warning: unused parameter 'ascii' [-Wunused-parameter]<br/>
                                        const void *buf, size_t len, bool ascii)

Patch which introduced the above lines<br/>
https://github.com/torvalds/linux/commit/cdf17449af1d9b596742c260134edd6c1fac2792

> ./include/linux/kernel.h:230:49: warning: unused parameter 'file' [-Wunused-parameter]<br/>
  static inline void ___might_sleep(const char *file, int line,<br/>
 ./include/linux/kernel.h:230:59: warning: unused parameter 'line' [-Wunused-parameter]<br/>
  static inline void ___might_sleep(const char *file, int line,<br/>
./include/linux/kernel.h:231:12: warning: unused parameter 'preempt_offset' [-Wunused-parameter]<br/>
                                   int preempt_offset) { }<br/>
./include/linux/kernel.h:232:48: warning: unused parameter 'file' [-Wunused-parameter]<br/>
  static inline void __might_sleep(const char *file, int line,<br/>
 ./include/linux/kernel.h:232:58: warning: unused parameter 'line' [-Wunused-parameter]<br/>
  static inline void __might_sleep(const char *file, int line,<br/>
 ./include/linux/kernel.h:233:12: warning: unused parameter 'preempt_offset' [-Wunused-parameter]<br/>
                                   int preempt_offset) { }<br/>

> In file included from ./arch/x86/include/asm/string_64.h:6:<br/>
./include/linux/jump_label.h:233:50: warning: unused parameter 'start' [-Wunused-parameter]<br/>
static inline int jump_label_text_reserved(void *start, void *end)<br/>
./include/linux/jump_label.h:233:63: warning: unused parameter 'end' [-Wunused-parameter]<br/>
static inline int jump_label_text_reserved(void *start, void *end)<br/>

```
static inline int jump_label_text_reserved(void *start, void *end)
{
        return 0;
}
```

> In file included from ./arch/x86/include/asm/string_64.h:6:<br/>
./include/linux/jump_label.h:241:56: warning: unused parameter 'mod' [-Wunused-parameter]<br/>
static inline int jump_label_apply_nops(struct module *mod)

Patches which introduced the above lines<br/>
https://github.com/torvalds/linux/commit/d430d3d7e646eb1eac2bb4aa244a644312e67c76<br/>
https://github.com/torvalds/linux/commit/4c3ef6d79328c0e23ade60cbfc8d496123a6855c

2. Empty functions to annotate something. This too is purposefully added.

Example Warnings:

> In file included from ./include/linux/spinlock_types.h:18:<br/>
./include/linux/lockdep.h:475:49: warning: unused parameter 'force' [-Wunused-parameter]<br/>
static inline void lockdep_invariant_state(bool force) {}<br/>

Patch: https://github.com/torvalds/linux/commit/f52be5708076b75a045ac52c6fef3fffb8300525

> In file included from ./include/linux/spinlock_types.h:18:<br/>
./include/linux/lockdep.h:476:58: warning: unused parameter 'task' [-Wunused-parameter]<br/>
static inline void lockdep_init_task(struct task_struct *task) {}<br/>
>
> In file included from ./include/linux/spinlock_types.h:18:<br/>
./include/linux/lockdep.h:477:58: warning: unused parameter 'task' [-Wunused-parameter]<br/>
static inline void lockdep_free_task(struct task_struct *task) {}<br/>

Patch: https://github.com/torvalds/linux/commit/b09be676e0ff25bd6d2e7637e26d349f9109ad75

> In file included from ./include/linux/spinlock_types.h:18:<br/>
./include/linux/lockdep.h:622:36: warning: unused parameter 'file' [-Wunused-parameter]<br/>
lockdep_rcu_suspicious(const char *file, const int line, const char *s)<br/>
./include/linux/lockdep.h:622:52: warning: unused parameter 'line' [-Wunused-parameter]<br/>
lockdep_rcu_suspicious(const char *file, const int line, const char *s)<br/>
./include/linux/lockdep.h:622:70: warning: unused parameter 's' [-Wunused-parameter]<br/>
lockdep_rcu_suspicious(const char *file, const int line, const char *s)<br/>

Patch: https://github.com/torvalds/linux/commit/d24209bb689e2c7f7418faec9b4a948e922d24da
                                                        
3. Empty function will be updated in future.

Example Warning:

> In file included from ./arch/x86/include/asm/processor.h:19:<br/>
./arch/x86/include/asm/pgtable_types.h:361:43: warning: unused parameter 'p4d' [-Wunused-parameter]<br/>
static inline p4dval_t p4d_pfn_mask(p4d_t p4d)

References<br/>
https://lwn.net/Articles/708526/<br/>
https://github.com/torvalds/linux/commit/fe1e8c3e9634071ac608172e29bf997596d17c7c<br/>

There can be warnings of which are true and needs to be fixed but I did<br/>
not find any till now.<br/>

Also, there are warnings which are false positive, the parameters are<br/>
used but clang did not understand their usage.<br/>

Example Warning:

> In file included from ./include/linux/compiler.h:246:<br/>
./include/linux/kasan-checks.h:9:58: warning: unused parameter 'p' [-Wunused-parameter]<br/>
static inline void kasan_check_read(const volatile void *p, unsigned int size)<br/>

There is one more category of **legacy code**, the warning in this code needs to be<br/>
ignored.<br/>

Example Warning:
```
In file included from scripts/kconfig/conf.c:19:
scripts/kconfig/lkc.h:158:56: warning: unused parameter 'ch' [-Wunused-parameter]
static inline bool sym_set_choice_value(struct symbol *ch, struct symbol *chval)
                                                       ^
1 warning generated.
  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:79:
scripts/kconfig/lkc.h:158:56: warning: unused parameter 'ch' [-Wunused-parameter]
static inline bool sym_set_choice_value(struct symbol *ch, struct symbol *chval)
```

Patch: https://github.com/torvalds/linux/commit/1da177e4c3f41524e886b7f1b8a0c1fc7321cac2

```
In file included from scripts/kconfig/zconf.tab.c:2486:
scripts/kconfig/expr.c:1282:63: warning: unused parameter 'sym' [-Wunused-parameter]
static void expr_print_file_helper(void *data, struct symbol *sym, const char *str)
                                                              ^

scripts/kconfig/expr.c:1282:static void expr_print_file_helper(void *data, struct symbol *sym, const char *str)
scripts/kconfig/expr.c:1289:    expr_print(e, expr_print_file_helper, out, E_NONE);
```

Patch: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ab45d190fd4acf0b0e5d307294ce24a90a69cc23

Another category where knowingly the parameter is not used. 

Example Warning:

```
scripts/mod/file2alias.c:909:40: warning: unused parameter 'filename' [-Wunused-parameter]
static int do_virtio_entry(const char *filename, void *symval,
                                       ^
```

Patch: https://lists.linuxfoundation.org/pipermail/virtualization/2007-September/008955.html
