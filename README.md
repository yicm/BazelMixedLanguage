[toc]

# 1 Features

- Support to build cpp application or library with bazel platform
- Support to build golang application or library with bazel platform
- Support to build android jni library with bazel platform

# 2 Environment

- WSL,Ubuntu18.04
- Bazel 3.3+
- Android JNI Library
    - Local JDK 8+(just for using `javah` or `javac` to generate native headers)
        - `sudo apt install openjdk-8-jdk-headless`
    - Android sdkmanager (https://developer.android.com/studio#command-tools)
        - config the environment of `sdkmanager`
        - `sdkmanager --sdk_root=$HOME/Android --list`
        - `sdkmanager --sdk_root=$HOME/Android 'build-tools;29.0.2'`
        - `sdkmanager --sdk_root=$HOME/Android 'platforms;android-28'`
        - `sdkmanager --sdk_root=$HOME/Android --install "ndk;18.1.5063045"`
            - more older releases: https://developer.android.com/ndk/downloads/older_releases ,also you can get the support list by `--list`


```bash
$ sudo apt-get install gcc
$ sudo apt-get install g++
$ sudo apt-get install gcc-arm-linux-gnueabihf
$ sudo apt-get install g++-arm-linux-gnueabihf
```

# 3 Non-Platform

## 3.1 Enable

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

## 3.2 Default Build(cpu=k8)

To build this example you can use:

```
$ bazel build //cpp:hello-world
```

> This compilation will only use the default compiler of the local machine.

## 3.3 Cross Build

- step1: config your toolchains path: `toolchain/cpp/supported.bzl`
- step2: build

```bash
# Default compilation configuration, --cpu : ubuntu_gcc
$ bazel build --config=compiler_config //cpp:hello-world
# Specify the toolchain to compile the target
$ bazel build --config=compiler_config --cpu=ubuntu_arm_linux_gnueabihf //cpp:hello-world
```

# 4 Platform & Mixed Language

- cpp
- golang

## 4.1 Enable

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

## 4.2 Query Supported Platforms

```bash
$ bazel cquery "//platforms:all"
```

## 4.3 Build

```bash
# p_ubuntu_gcc
$ bazel build cpp:hello-world --platforms=//platforms:p_ubuntu_gcc

# p_ubuntu_arm_linux_gnueabihf
$ bazel build cpp:hello-world --platforms=//platforms:p_ubuntu_arm_linux_gnueabihf

$ bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64 golang/cmd/hello
$ bazel build --platforms=@io_bazel_rules_go//go/toolchain:linux_arm //golang/cmd/hello

# build all targets
$ bazel build --platforms=//platforms:p_ubuntu_gcc //...

# Remote caching
$ bazel clean
$ bazel build --remote_cache=grpc://10.151.176.11:8980 cpp:hello-world --platforms=//platforms:p_ubuntu_arm_linux_gnueabihf

# Android JNI Library
$ bazel build --platforms=//platforms:p_android_armv7a android:gen_jni_header
$ bazel build --platforms=//platforms:p_android_armv7a android:jni_lib_shared
$ bazel build --platforms=//platforms:p_android_aarch64 android:jni_lib_shared
```

> All toolchain information is in file `toolchains/cpp/supported.bzl`.
