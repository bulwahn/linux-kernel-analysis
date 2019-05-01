# Analysis Report 0007 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
  'chip' is not reachable after line 2154, column 3.
  2152.   
  2153.   	if (data)
  2154.  		err = chip->irq_get_irqchip_state(data, which, state);
  2155.   
  2156.   	irq_put_desc_busunlock(desc, flags);
```
```
  `chip` is not reachable after line 2200, column 3.
  2198.   
  2199.   	if (data)
  2200. > 		err = chip->irq_set_irqchip_state(data, which, val);
  2201.   
  2202.   	irq_put_desc_busunlock(desc, flags);
```
**File Location:** kernel/irq/manage.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** False-Positive  
### Rationale ###
#### First Error - Line 2154 #### 
If we look at full content of related block of code
```C
int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
			  bool val)
{
	struct irq_desc *desc;
	struct irq_data *data;
	struct irq_chip *chip;
	unsigned long flags;
	int err = -EINVAL;

	desc = irq_get_desc_buslock(irq, &flags, 0);
	if (!desc) 
		return err;

	data = irq_desc_get_irq_data(desc);

	do {
		chip = irq_data_get_irq_chip(data);
		if (chip->irq_set_irqchip_state)
			break;
#ifdef CONFIG_IRQ_DOMAIN_HIERARCHY
		data = data->parent_data;
#else
		data = NULL;
#endif
	} while (data);

	if (data)
		err = chip->irq_set_irqchip_state(data, which, val);

	irq_put_desc_busunlock(desc, flags);
	return err;
}
```
If desc doesn't have allocated space, this function will return at ```if(!desc)``` check.
and since we have a do {} while loop, It is guaranteed that, this loop will be executed at least once.
I think it is a good idea to call ```free(chip);``` before ```return err;```

