# Analysis Report 0004 #

## General ##
**Warning Type:** DEAD_STORAGE  
**Warning Explanation:** The value written to &ret (type int) is never used.   
```C
   
if (ret == 8) {
> 		ret = ntrig_version_string(&data[2], buf);
  		hid_info(hdev, "Firmware version: %s (%02x%02x %02x%02x)\n",

}
```
**File Location:** drivers/hid/hid-ntrig.c:162  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  

## Manuel Assesment ##
**Classification:** POSITIVE  
### Rationale ###
```C
static void ntrig_report_version(struct hid_device *hdev)
{
	int ret;
	char buf[20];
	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
	unsigned char *data = kmalloc(8, GFP_KERNEL);

	if (!data)
		goto err_free;

	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
			      USB_REQ_CLEAR_FEATURE,
			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
			      USB_DIR_IN,
			      0x30c, 1, data, 8,
			      USB_CTRL_SET_TIMEOUT);

	if (ret == 8) {
		ret = ntrig_version_string(&data[2], buf);

		hid_info(hdev, "Firmware version: %s (%02x%02x %02x%02x)\n",
			 buf, data[2], data[3], data[4], data[5]);
	}

err_free:
	kfree(data);
}
```
As infer stated, ```ret``` value is not used after ```ret = ntrig_version_string(&data[2], buf);```. No need to assign return value of ```ntrig_version_string``` function  to ```ret```.
