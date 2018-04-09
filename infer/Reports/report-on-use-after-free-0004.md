## Summary
This USE_AFTER_FREE error only exists version 1.1 infer analysis.

##  Error Location
```c
// In file kernel/kthread.c
197 static int kthread(void *_create)
198 {
199     /* Copy data: it's on kthread's stack */
200     struct kthread_create_info *create = _create;
201     int (*threadfn)(void *data) = create->threadfn;
202     void *data = create->data;
203     struct completion *done;
204     struct kthread *self;
205     int ret;
206 
207     self = kzalloc(sizeof(*self), GFP_KERNEL);
208     set_kthread_struct(self);
209 

kernel/kthread.c:218: error: USE_AFTER_FREE
  pointer `create` last assigned on line 200 was freed by call to `kfree()` at line 213, 
  column 3 and is dereferenced or freed at line 218, column 3.
 
210     /* If user was SIGKILLed, I release the structure. */
211     done = xchg(&create->done, NULL);
212     if (!done) {
213 >       kfree(create);
214         do_exit(-EINTR);
215     }
216 
217     if (!self) {
218         create->result = ERR_PTR(-ENOMEM);
219         complete(done);
220         do_exit(-ENOMEM);
221     }
222 
223     self->data = data;
224     init_completion(&self->exited);
225     init_completion(&self->parked);
226     current->vfork_done = &self->exited;
227 

```


## Analysis
In line 211, if variable `done` is NULL, it will free create and exit. Otherwise, the code run to line 217 to test variable `!self` where variable `create` is still valid. So there is no USE_AFTER_FREE error.
To solve this false alert, we can simply model `do_exit()` as `exit()`.

## Conclusion
Kernel code, False Positive, Shoule add new model for `do_exit()`.

## Reference
https://lwn.net/Articles/65178/

https://stackoverflow.com/questions/10177641/proper-way-of-handling-threads-in-kernel
