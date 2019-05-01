# Analysis Report 0002 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
  `tty->pgrp` is not reachable after line 105, column 2.
  103.   	put_pid(tty->session);
  104.   	put_pid(tty->pgrp);
  105. > 	tty->pgrp = get_pid(task_pgrp(current));
  106.   	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
  107.   	tty->session = get_pid(task_session(current));
```  
**File Location:** drivers/tty/tty_jobctrl.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** Looks like false-positive but not make sure right now.
### Rationale ###
Even though infer claims that, we won't use tty->pgrp after line 105, if we analyze this function more detailed:
```C
static void __proc_set_tty(struct tty_struct *tty)
{
	unsigned long flags;

	spin_lock_irqsave(&tty->ctrl_lock, flags);
	/*
	 * The session and fg pgrp references will be non-NULL if
	 * tiocsctty() is stealing the controlling tty
	 */
	put_pid(tty->session);
	put_pid(tty->pgrp);
	tty->pgrp = get_pid(task_pgrp(current));
	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
	tty->session = get_pid(task_session(current));
	if (current->signal->tty) {
		tty_debug(tty, "current tty %s not NULL!!\n",
			  current->signal->tty->name);
		tty_kref_put(current->signal->tty);
	}
	put_pid(current->signal->tty_old_pgrp);
	current->signal->tty = tty_kref_get(tty);
	current->signal->tty_old_pgrp = NULL;
}
```
Actually we refer this new tty->pgrp by line ```current->signal->tty = tty_kref_get(tty)``` and after this function completes, Linux will start use this tty->pgrp in ```current``` which is defined in ```include/linux/sched.h``` as:
```C
struct task_struct {
....
	/* Signal handlers: */
	struct signal_struct		*signal;
	struct sighand_struct		*sighand;
.....

};
```
and in addition to that in arch directory every subdirectory has its own current.h file, for example in x86 subdirectory:
```
/* SPDX-License-Identifier: GPL-2.0 */
#ifndef _ASM_X86_CURRENT_H
#define _ASM_X86_CURRENT_H

#include <linux/compiler.h>
#include <asm/percpu.h>

#ifndef __ASSEMBLY__
struct task_struct;

DECLARE_PER_CPU(struct task_struct *, current_task);

static __always_inline struct task_struct *get_current(void)
{
	return this_cpu_read_stable(current_task);
}

#define current get_current()

#endif /* __ASSEMBLY__ */

#endif /* _ASM_X86_CURRENT_H */
```
So in my opinion change in a data , which is using by task_struct current, is cannot be classified as not-reachable.



