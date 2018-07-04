# Analysis Report 0001 #

## General ##
**Warning Type:** UNINITIALIZED_VALUE  
**Warning Explanation:** The value read from gd.interface was never initialized.   
```C
  	if (copy_from_user(&gd, arg, sizeof(gd)))
   		return -EFAULT;
 	intf = usb_ifnum_to_if(ps->dev, gd.interface);
	if (!intf || !intf->dev.driver)
   		
```
**File Location:** drivers/usb/core/devio.c:1291
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** FALSE-POSITIVE
### Rationale ###
```C
static int proc_getdriver(struct usb_dev_state *ps, void __user *arg)
{
	struct usbdevfs_getdriver gd;
	struct usb_interface *intf;
	int ret;

	if (copy_from_user(&gd, arg, sizeof(gd)))
		return -EFAULT;
	intf = usb_ifnum_to_if(ps->dev, gd.interface);
	if (!intf || !intf->dev.driver)
		ret = -ENODATA;
	else {
		strlcpy(gd.driver, intf->dev.driver->name,
				sizeof(gd.driver));
		ret = (copy_to_user(arg, &gd, sizeof(gd)) ? -EFAULT : 0);
	}
	return ret;
}
```
In this function, at ```if (copy_from_user(&gd, arg, sizeof(gd)))``` block, programmer tried to get data from user space.(see)[https://www.fsl.cs.sunysb.edu/kernel-api/re257.html], and returned an ```-EFAULT``` in copy failure case. Infer warns us about in ```intf = usb_ifnum_to_if(ps->dev, gd.interface);``` assignment, we may pass an uinit gd.interface value. So we must look at usbdevfs_getdriver struct to analyze this case better.  
```C
struct usbdevfs_getdriver {
	unsigned int interface;
	char driver[USBDEVFS_MAXDRIVERNAME + 1];
};
```
Since copy_from_user function returned without any error, and there isn't any warning in infer for ```include/linux/uaccess.h:copy_from_user``` function flow. I guess interface and driver values are set and they are not uninitialized. So in my opinion it is a false-positive warning.

