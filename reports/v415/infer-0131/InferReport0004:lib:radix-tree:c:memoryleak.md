# Analysis Report 0004 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
  `node->parent` is not reachable after line 488, column 4.
  486.   		rtp = this_cpu_ptr(&radix_tree_preloads);
  487.   		if (rtp->nr < nr) {
  488. > 			node->parent = rtp->nodes;
  489.   			rtp->nodes = node;
  490.   			rtp->nr++;
```  
**File Location:** lib/radix-tree.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** Highly Possible, but try to reproduce it with smaller code examples.
### Rationale ###
Here Infer warns about that, after this struct's pointer links changed, there will be a piece of data which is still in memory, but cannot be reachable through any of this structs.
So let's look at that.
```C
static __must_check int __radix_tree_preload(gfp_t gfp_mask, unsigned nr)
{
	struct radix_tree_preload *rtp;
	struct radix_tree_node *node;
....
	while (rtp->nr < nr) {
		preempt_enable();
		node = kmem_cache_alloc(radix_tree_node_cachep, gfp_mask);
		if (node == NULL)
			goto out;
		preempt_disable();
		rtp = this_cpu_ptr(&radix_tree_preloads);
		if (rtp->nr < nr) {
			node->parent = rtp->nodes;
			rtp->nodes = node;
			rtp->nr++;
		} else {
  ....
  ```
rtp is a type of ```radix_tree_preload``` struct whereas node is a ```radix_tree_node``` struct.
```C
struct radix_tree_node {
  unsigned char	shift;		/* Bits remaining in each slot */
	unsigned char	offset;		/* Slot offset in parent */
	unsigned char	count;		/* Total entry count */
	unsigned char	exceptional;	/* Exceptional entry count */
	struct radix_tree_node *parent;		/* Used when ascending tree */
	struct radix_tree_root *root;		/* The tree we belong to */
};
```
```C
struct radix_tree_preload {
	unsigned nr;
	/* nodes->parent points to next preallocated node */
	struct radix_tree_node *nodes;
};
```
As we can observer, radix_tree_node struct doesn not only has links to its parent and root, but also encapsulates different information too.
According to infer tricky part of the code is: if ```node``` points to a memory block which has shift, offset and count data. However
``` node->parent = rtp-> nodes;
    rtp->nodes = node;
```
If before this two line, lets say node->parent = Y , and rtp -> nodes = X
after this two lines executed, node->parent = X and rtp -> nodes = node,
we couldn't reach to Y using this structs anymore. So Infer suggests we must free(Y) before starting this operations.





  
  
  
