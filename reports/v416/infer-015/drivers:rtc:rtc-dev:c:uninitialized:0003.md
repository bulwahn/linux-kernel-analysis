# Analysis Report 0003 #

## General ##
**Warning Type:** UNINITIALIZED_VALUE  
**Warning Explanation:** The value read from ret was never initialized.   
```C
	sizeof(unsigned long);
	}
return ret;
}
```
**File Location:** drivers/rtc/rtc-dev.c:194  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  
**Similar-Case:** [FalsePositive-Uninitialized-loop-problem](https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation/infer/MockCodes/infer-uninitialized-with-loop)  
## Manuel Assesment ##
**Classification:** FALSE-POSITIVE  
### Rationale ###
```C
...
	ssize_t ret;

	if (count != sizeof(unsigned int) && count < sizeof(unsigned long))
		return -EINVAL;

	add_wait_queue(&rtc->irq_queue, &wait);
	do {
		__set_current_state(TASK_INTERRUPTIBLE);

		spin_lock_irq(&rtc->irq_lock);
		data = rtc->irq_data;
		rtc->irq_data = 0;
		spin_unlock_irq(&rtc->irq_lock);

		if (data != 0) {
			ret = 0;
			break;
		}
		if (file->f_flags & O_NONBLOCK) {
			ret = -EAGAIN;
			break;
		}
		if (signal_pending(current)) {
			ret = -ERESTARTSYS;
			break;
		}
		schedule();
	} while (1);
	set_current_state(TASK_RUNNING);
	remove_wait_queue(&rtc->irq_queue, &wait);

	if (ret == 0) {
		/* Check for any data updates */
		if (rtc->ops->read_callback)
			data = rtc->ops->read_callback(rtc->dev.parent,
						       data);

		if (sizeof(int) != sizeof(long) &&
		    count == sizeof(unsigned int))
			ret = put_user(data, (unsigned int __user *)buf) ?:
				sizeof(unsigned int);
		else
			ret = put_user(data, (unsigned long __user *)buf) ?:
				sizeof(unsigned long);
	}
	return ret;
}
```
In the function above, there is an infinite loop, and without assigning a value to ```ret``` value , it cannot be broken.  
In my opinion ```ret``` cannot have an uninitialized before return.
