# Usage

## Using `compile-kernel.sh`

The `compile-kernel.sh` script is a shortcut to compile different branches of
the kernel with a given standard kernel configuration and compiler.

The script takes these three arguments:
`./scripts/compile-kernel.sh <repository> <config> <compiler>`

For example, to build the current main-line kernel with the default kernel
configuration and clang-5.0 compiler, run:

```
./scripts/compile-kernel.sh torvalds defconfig clang-5.0
```

For other help, use `./scripts/compile-kernel.sh --help`.
