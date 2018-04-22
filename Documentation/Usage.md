# Usage

## Using `compile-kernel.sh`

The `compile-kernel.sh` script is a shortcut to compile different branches of
the kernel with a given standard kernel configuration and compiler.

The script takes these three arguments (at least):
`./scripts/compile-kernel.sh <repository> <config> <compiler> <checker>`

The 4th argument `<checker>` is optional.

For example, to build the current main-line kernel with the default kernel
configuration and clang compiler, run:

```
./scripts/compile-kernel.sh torvalds defconfig clang
```

For other help, use `./scripts/compile-kernel.sh --help`.
