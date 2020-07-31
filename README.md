# Environment

- WSL,Ubuntu18.04
- Build label: 3.3.1

```bash
$ sudo apt-get install gcc
$ sudo apt-get install g++
$ sudo apt-get install gcc-arm-linux-gnueabihf
$ sudo apt-get install g++-arm-linux-gnueabihf
```

# Non-Platform

## Enable

1. Open `.bazelrc` file:

```bash
build   --toolchain_resolution_debug

# --------------------------
# Way1: enable/disable --crosstool_top,--cpu
# --------------------------
build:compiler_config --crosstool_top=//toolchains/cpp:compiler_suite
build:compiler_config --cpu=ubuntu_gcc
build:compiler_config --host_crosstool_top=@bazel_tools//tools/cpp:toolchain

# --------------------------
# Way2: enable/diable platform
# --------------------------
#build   --incompatible_enable_cc_toolchain_resolution
```

2. Open `toolchains/cpp/BUILD`, and comment `generate_toolchains` function, and uncomment `generate_toolchain_suite` function.

## Default Build(cpu=k8)

To build this example you can use:

```
$ bazel build //main:hello-world
```

> This compilation will only use the default compiler of the local machine.

## Cross Build

- step1: config your toolchains path: `toolchain/cpp/supported.bzl`
- step2: build

```bash
# Default compilation configuration, --cpu : ubuntu_gcc
$ bazel build --config=compiler_config //main:hello-world
# Specify the toolchain to compile the target
$ bazel build --config=compiler_config --cpu=ubuntu_arm_linux_gnueabihf //main:hello-world
```

# Platform

## Enable

1. Open `.bazelrc` file:

```bash
build   --toolchain_resolution_debug

# --------------------------
# Way1: enable/disable --crosstool_top,--cpu
# --------------------------
#build:compiler_config --crosstool_top=//toolchains/cpp:compiler_suite
#build:compiler_config --cpu=ubuntu_gcc
#build:compiler_config --host_crosstool_top=@bazel_tools//tools/cpp:toolchain

# --------------------------
# Way2: enable/diable platform
# --------------------------
build   --incompatible_enable_cc_toolchain_resolution
```

2. Open `toolchains/cpp/BUILD`, and comment `generate_toolchain_suite` function, and uncomment `generate_toolchains` function.

## Build

```
# p_ubuntu_gcc
$ bazel build main:hello-world --platforms=//platforms:p_ubuntu_gcc
# p_ubuntu_arm_linux_gnueabihf
$ bazel build main:hello-world --platforms=//platforms:p_ubuntu_arm_linux_gnueabihf
```

> All toolchain information is in file `toolchains/cpp/supported.bzl`.
