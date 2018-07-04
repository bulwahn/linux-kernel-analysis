# Analysis Report 0003 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
 `pl->next` is not reachable after line 256, column 3.
  254.   			kc->nr_free_pages--;
  255.   		}
  256. > 		pl->next = *pages;
  257.   		*pages = pl;
  258.   	} while (--nr);
```  
```
  `next->next` is not reachable after line 297, column 3.
  295.   			return -ENOMEM;
  296.   		}
  297. > 		next->next = pl;
  298.   		pl = next;
  299.   	}
```
**File Location:** drivers/md/dm-kcopyd.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** First one makes too much function calls, look more carefully, I think second one is false-positive.
### Rationale ###
#### First Part ####
```C
static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
			    unsigned int nr, struct page_list **pages)
{
	struct page_list *pl;

	*pages = NULL;

	do {
		pl = alloc_pl(__GFP_NOWARN | __GFP_NORETRY | __GFP_KSWAPD_RECLAIM);
		if (unlikely(!pl)) {
			/* Use reserved pages */
			pl = kc->pages;
			if (unlikely(!pl))
				goto out_of_memory;
			kc->pages = pl->next;
			kc->nr_free_pages--;
		}
		pl->next = *pages;
		*pages = pl;
	} while (--nr);
 .....
}
```
To understand both of these two problems better, first we must look at dm_kcopyd_client and page_list structs.
```C
struct dm_kcopyd_client {
	struct page_list *pages;
	unsigned nr_reserved_pages;
	unsigned nr_free_pages;
......
};
```
```C
struct page_list {
	struct page_list *next;
	struct page *page;
};
```
Now make a summary of investigation and write it here

#### Second Part ####
```C
for (i = 0; i < nr_pages; i++) {
		next = alloc_pl(GFP_KERNEL);
		if (!next) {
			if (pl)
				drop_pages(pl);
			return -ENOMEM;
		}
		next->next = pl;
		pl = next;
	}
```
Again infer is suspicious about a memory leak in here. According to my observation, it analyzes as:
during ``` next = alloc_pl(GFP_KERNEL); ``` if there is a data linked to next->next, then we cannot access it anymore using structs. However if we look at ```alloc_pl``` function,
```C
static struct page_list *alloc_pl(gfp_t gfp)
{
	struct page_list *pl;

	pl = kmalloc(sizeof(*pl), gfp);
	if (!pl)
		return NULL;

	pl->page = alloc_page(gfp);
	if (!pl->page) {
		kfree(pl);
		return NULL;
	}

	return pl;
}
```
It doesn't change anything on next->next pointer. It only changes next->page, but it is irrelevant to our warning case.
So in my opinion second warning is False-Positive

