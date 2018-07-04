# Analysis Report 0005 #

## General ##
**Warning Type:** UNINITIALIZED_VALUE  
**Warning Explanation:** The value read from k was never initialized.   
```C 
/* Drop the references to the signaled fences */
for (i = k; i < fobj->shared_max; ++i) {
	struct dma_fence *f;
}
```
**File Location:** drivers/dma-buf/reservation.c:207  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  

## Manuel Assesment ##
**Classification:** False - Positive  
### Rationale ###
```C
static void
reservation_object_add_shared_replace(struct reservation_object *obj,
				      struct reservation_object_list *old,
				      struct reservation_object_list *fobj,
				      struct dma_fence *fence)
{
	unsigned i, j, k;
...

	if (!old) {
		RCU_INIT_POINTER(fobj->shared[0], fence);
		fobj->shared_count = 1;
		goto done;
	}

	/*
	 * no need to bump fence refcounts, rcu_read access
	 * requires the use of kref_get_unless_zero, and the
	 * references from the old struct are carried over to
	 * the new.
	 */
	for (i = 0, j = 0, k = fobj->shared_max; i < old->shared_count; ++i) {
		struct dma_fence *check;

		check = rcu_dereference_protected(old->shared[i],
						reservation_object_held(obj));

		if (check->context == fence->context ||
		    dma_fence_is_signaled(check))
			RCU_INIT_POINTER(fobj->shared[--k], check);
		else
			RCU_INIT_POINTER(fobj->shared[j++], check);
	}
	fobj->shared_count = j;
	RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
	fobj->shared_count++;

done:
	preempt_disable();
	write_seqcount_begin(&obj->seq);
	/*
	 * RCU_INIT_POINTER can be used here,
	 * seqcount provides the necessary barriers
	 */
	RCU_INIT_POINTER(obj->fence, fobj);
	write_seqcount_end(&obj->seq);
	preempt_enable();

	if (!old)
		return;

	/* Drop the references to the signaled fences */
	for (i = k; i < fobj->shared_max; ++i) {
		struct dma_fence *f;

		f = rcu_dereference_protected(fobj->shared[i],
					      reservation_object_held(obj));
		dma_fence_put(f);
	}
	kfree_rcu(old, rcu);
}

```
In this function, there is no assignment made to k, if function follows ```goto done``` path. However in this case, after the second ```if (!old)``` check, ```reservation_object_add_shared_replace``` will return immediately, without entering loop. So I think its a false-positive warning.

