## Summary
This USE_AFTER_FREE error only exists version 1.1 infer analysis.

##  Error Location
```c
// In file drivers/iommu/dmar.c
776 int __init dmar_dev_scope_init(void)
777 {   
778     struct pci_dev *dev = NULL; 
779     struct dmar_pci_notify_info *info;
780     
781     if (dmar_dev_scope_status != 1)
782         return dmar_dev_scope_status;
783     
784     if (list_empty(&dmar_drhd_units)) {
785         dmar_dev_scope_status = -ENODEV;
786     } else {
787         dmar_dev_scope_status = 0;
788 
789         dmar_acpi_dev_scope_init();
790 
791         for_each_pci_dev(dev) {
792             if (dev->is_virtfn)
793                 continue;
794 

drivers/iommu/dmar.c:801: error: USE_AFTER_FREE
  pointer `info` last assigned on line 795 was freed by call to `dmar_free_pci_notify_info()` at line 801, column 5 and is dereferenced 
  or freed at line 801, column 5.

795             info = dmar_alloc_pci_notify_info(dev,
796                     BUS_NOTIFY_ADD_DEVICE);
797             if (!info) {
798                 return dmar_dev_scope_status;
799             } else {
800                 dmar_pci_bus_add_dev(info);
801 >               dmar_free_pci_notify_info(info);
802             }
803         }
804     }
805     
806     return dmar_dev_scope_status;
807 }
```


## Analysis
In this function, the variable info is assigned value by function `dmar_alloc_pci_notify_info()`, and then it would be judegd whether it was valid or null value.

The error message was also self-contradictory, it says info was freed by call to `dmar_free_pci_notify_info()` at line 801, column 5 and it was freed at same line 801, column 5.

```c
static inline void dmar_free_pci_notify_info(struct dmar_pci_notify_info *info)
{
	if ((void *)info != dmar_pci_notify_info_buf)
		kfree(info);
}
``` 

## Conclusion
Kernel code, False Positive.
