# Default Build(cpu=k8)

To build this example you use:

```
$ bazel build //main:hello-world
```


# Cross Build

- step1: config your toolchain path: `toolchain/BUILD`
- step2: build

```bash
# default cpu : armv7
$ bazel build --config=compiler_config //main:hello-world
$ bazel build --config=compiler_config --cpu=x86-64 //main:hello-world
```
