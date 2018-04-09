1. Download the release of Infer packaged with pre-built binaries 
for clang and facebook-clang-plugins for Linux and MacOS.

    https://github.com/facebook/infer/releases/tag/v0.13.1

2. Install the dependencies for Linux or MacOS

    https://github.com/facebook/infer/blob/master/INSTALL.md#pre-compiled-versions

3. Install from the source

```
tar xf infer-<release>.tar.xz
cd infer-<release>/
./build-infer.sh
make install
```

> I met some dependency problems in opam during building infer. In my case, it's about the camlzip.1.07 and sqlite3.4.3.2. Use following commands to solve the problems.

```
opam depext sqlite3.4.3.2
opam depext camlzip.1.07
```

4. After run `make install`, you can use infer in you terminal,
the most frequently used command are like:

```
infer run -- make
infer run -- clang -c example.c
```

According to the Infer documentation, `infer run` combine two independent command,`infer capture` and `infer analyze`. So you can run those two commands separately. 

5. Add models in `infer/models/c/src/`. e.g. In `infer/models/c/src/kapis.c`, by adding

```c
#include "infer_builtins.h"
#include <stdlib.h>

void* kmalloc(size_t size, unsigned flags) {
  if (size == 0)
    return NULL;
  void* res = malloc(size);
  INFER_EXCLUDE_CONDITION(!res);
  return res;
}

void kfree(void* ptr) { free(ptr); }
```

To install the new model into your infer lib, you should recompile infer and reinstall again.

```
$ make clean
$ make
# make uninstall
# make install
```

6. To run infer on Linux kernel code, there are several dirctories needed to skip. Under the root directory of Linu kernel code, add a new file named `.inferconfig`. Add those dircotries for stable v4.15, "arch/x86", "arch", "mm", "drivers/acpi", "fs", "kernel/bpf", "net/mac80211". In my case, the file looks like:
 
```
{
    "skip-analysis-in-path": ["home/evan/Repository/linux/stable/linux-stable/arch/x86", "home/evan/Repository/linux/stable/linux-stable/arch", "home/evan/Repository/linux/stable/linux-stable/mm", "home/evan/Repository/linux/stable/linux-stable/drivers/acpi", "home/evan/Repository/linux/stable/linux-stable/fs", "home/evan/Repository/linux/stable/linux-stable/kernel/bpf", "home/evan/Repository/linux/stable/linux-stable/net/mac80211"]
}
```

Run `infer run -- make -jn` will let infer start to do the analysis.