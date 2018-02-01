# Setting up the work environment

This document describes how to set up your system to use the `compile-kernel.sh`
script.

We assume that you have cloned the git repository and you are now at the
top-level directory of that git repository to follow through with these steps:

Build the needed docker containers with `build-docker.sh` script:

   ```
   ./scripts/build-docker.sh
   ```

Set directory where you place your kernel git repositories:

   ```
   export KERNEL_SRC_BASE=<Directory to place your kernel git repositories>
   ```

   For example, here is the setup to place git repositories in a subdirectory
   structure that matches the URLs of its origin:

   ```
   mkdir -p ~/repositories/kernel.org/pub/scm/linux/kernel/git
   export KERNEL_SRC_BASE=~/repositories/kernel.org/pub/scm/linux/kernel/git
   ```

Add this environment variable in your `.bash_profile` to make this
environment variable persistent:

```
echo "export KERNEL_SRC_BASE=$KERNEL_SRC_BASE" >> ~/.bash_profile
```

Clone the git repositories, torvalds, stable and next, from git.kernel.org
into the `KERNEL_SRC_BASE` directory:

```
pushd $KERNEL_SRC_BASE
export KERNEL_GIT_BASE_URL=https://git.kernel.org/pub/scm/linux/kernel/git/
git clone $KERNEL_GIT_BASE_URL/torvalds/linux.git torvalds/linux
git clone $KERNEL_GIT_BASE_URL/stable/linux-stable.git stable/linux-stable
git clone $KERNEL_GIT_BASE_URL/next/linux-next.git next/linux-next
popd
```

Now, everything is set up and you can use `./scripts/compile-kernel.sh`.
For more information, how to use `./scripts/compile-kernel.sh`, see
[Usage.md](Usage.md).
