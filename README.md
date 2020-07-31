# Environment

- WSL,Ubuntu18.04
- Build label: 3.3.1

```bash
$ sudo apt-get install gcc
$ sudo apt-get install g++
$ sudo apt-get install gcc-arm-linux-gnueabihf
$ sudo apt-get install g++-arm-linux-gnueabihf
```

# Default Build(cpu=k8)

To build this example you can use:

```
$ bazel build //main:hello-world
```

> This compilation will only use the default compiler of the local machine.

# Cross Build

- step1: config your toolchains path: `toolchain/cpp/supported.bzl`
- step2: build

```bash
# Default compilation configuration, --cpu : ubuntu_gcc
$ bazel build --config=compiler_config //main:hello-world
# Specify the toolchain to compile the target
$ bazel build --config=compiler_config --cpu=ubuntu_arm_linux_gnueabihf //main:hello-world
```
