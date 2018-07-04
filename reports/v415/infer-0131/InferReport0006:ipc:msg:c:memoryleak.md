# Analysis Report 0006 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
  `msg` is not reachable after line 750, column 2.
  748.   		return -EINVAL;
  749.   
  750. > 	msg = load_msg(mtext, msgsz);
  751.   	if (IS_ERR(msg))
  752.   		return PTR_ERR(msg);
```  
**File Location:** ipc/msg.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** FALSE-POSITIVE
### Rationale ##
We must look at the function from beginning of it, to understand that warning better.
```C
static long do_msgsnd(int msqid, long mtype, void __user *mtext,
		size_t msgsz, int msgflg)
{
	struct msg_queue *msq;
	struct msg_msg *msg;
	int err;
	struct ipc_namespace *ns;
	DEFINE_WAKE_Q(wake_q);

	ns = current->nsproxy->ipc_ns;

	if (msgsz > ns->msg_ctlmax || (long) msgsz < 0 || msqid < 0)
		return -EINVAL;
	if (mtype < 1)
		return -EINVAL;

	msg = load_msg(mtext, msgsz);
	if (IS_ERR(msg))
		return PTR_ERR(msg);
	...
```
In this case, Infer warns us about we allocate space to msg_msg *msg via ```load_msg``` function. However if there will be a memory leak, if we return directly without free the space that allocated to *msg.
Lets look at ```load_msg``` part
```C
struct msg_msg *load_msg(const void __user *src, size_t len)
{
	struct msg_msg *msg;
	struct msg_msgseg *seg;
	int err = -EFAULT;
	size_t alen;

	msg = alloc_msg(len);
	if (msg == NULL)
		return ERR_PTR(-ENOMEM);

	alen = min(len, DATALEN_MSG);
	if (copy_from_user(msg + 1, src, alen))
		goto out_err;

	for (seg = msg->next; seg != NULL; seg = seg->next) {
		len -= alen;
		src = (char __user *)src + alen;
		alen = min(len, DATALEN_SEG);
		if (copy_from_user(seg + 1, src, alen))
			goto out_err;
	}

	err = security_msg_msg_alloc(msg);
	if (err)
		goto out_err;

	return msg;

out_err:
	free_msg(msg);
	return ERR_PTR(err);
}
```
As you can see here, if msg is not null, then programmer first free msg and then return. Only in ```msg == null``` programmer returned directly, and if msg equals to null that means we couldn't allocated space. So in my opinion there won't be a memory leak during execution of this function.


http://home.netcom.com/%7Etjensen/ptr/pointers.htm
