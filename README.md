# Default Build(cpu=k8)

To build this example you use:

```
$ bazel build //main:hello-world
```


# Cross Build(cpu=armv7, arm-himix100-linux-gcc)

- step1: config your toolchain path: `toolchain/cc_toolchain_config.bzl`
- step2: build

```
$ bazel build --config=compiler_config //main:hello-world
```
