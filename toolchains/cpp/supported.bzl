BAZEL_EXEC_PLATFORM_INFO = {
    "os" : "linux",
    "cpu" : "x86_64"
}

TOOLCHAIN_TARGET_DEVICE = "target_device"
TOOLCHAIN_HOST_OS = "host_os"
TOOLCHAIN_TARGET_OS = "target_os"
TOOLCHAIN_TARGET_ARCH = "target_arch"
TOOLCHAIN_TARGET_CGO = "target_cgo"
TOOLCHAIN_COMPILER_ROOT = "compiler_root"
TOOLCHAIN_INCLUDE_PATHS = "include_paths"
TOOLCHAIN_IDENTIFIER = "toolchain_identifier"
TOOLCHAIN_CC_COMPILER = "cc_compiler"
TOOLCHAIN_EMPTY = "toolchain_empty"

TOOLCHAIN_SUPPORT_MATRIX = {
    "macos_gcc": {
        TOOLCHAIN_HOST_OS : "macos",
        TOOLCHAIN_TARGET_OS : "macos",
        TOOLCHAIN_TARGET_ARCH : "x86_64",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "/usr/bin/",
        TOOLCHAIN_INCLUDE_PATHS : [
            "/usr/include",
            "/usr/lib/gcc",
            "/usr/local/include"
        ],
        TOOLCHAIN_IDENTIFIER : "",
        TOOLCHAIN_CC_COMPILER : "gcc"
    },    
    "ubuntu_gcc": {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "linux",
        TOOLCHAIN_TARGET_ARCH : "x86_64",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "/usr/bin/",
        TOOLCHAIN_INCLUDE_PATHS : [
            "/usr/include",
            "/usr/lib/gcc",
            "/usr/local/include"
        ],
        TOOLCHAIN_IDENTIFIER : "",
        TOOLCHAIN_CC_COMPILER : "gcc"
    },
    "ubuntu_clang": {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "linux",
        TOOLCHAIN_TARGET_ARCH : "x86_64",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "",
        TOOLCHAIN_INCLUDE_PATHS : [],
        TOOLCHAIN_IDENTIFIER : "",
        TOOLCHAIN_CC_COMPILER : "clang"
    },
    "ubuntu_arm_linux_gnueabihf" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "linux",
        TOOLCHAIN_TARGET_ARCH : "arm",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "/usr/bin/",
        TOOLCHAIN_INCLUDE_PATHS : [
            "/usr/arm-linux-gnueabihf/include/",
            "/usr/lib/gcc-cross/arm-linux-gnueabihf/7/include",
        ],
        TOOLCHAIN_IDENTIFIER : "arm-linux-gnueabihf-",
        TOOLCHAIN_CC_COMPILER : "gcc"
    },
    "hisi_himix200" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "linux",
        TOOLCHAIN_TARGET_ARCH : "arm",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "{YOUR PATH}/arm-himix200-linux/bin/",
        TOOLCHAIN_INCLUDE_PATHS : [
            "{YOUR PATH}/arm-himix200-linux/arm-linux-gnueabi/include/c++/6.3.0/",
            "{YOUR PATH}/arm-himix200-linux/lib/gcc/arm-linux-gnueabi/6.3.0/include",
            "{YOUR PATH}/arm-himix200-linux/target/usr/include",
        ],
        TOOLCHAIN_IDENTIFIER : "arm-himix200-linux-",
        TOOLCHAIN_CC_COMPILER : "gcc"
    },
    "hisi_himix100" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "linux",
        TOOLCHAIN_TARGET_ARCH : "arm",
        TOOLCHAIN_EMPTY : "false",
        TOOLCHAIN_TARGET_CGO: "off", # only on or off
        TOOLCHAIN_COMPILER_ROOT : "{YOUR PATH}/arm-himix100-linux/bin/",
        TOOLCHAIN_INCLUDE_PATHS : [
	    "{YOUR PATH}/arm-himix100-linux/target/usr/include/",
	    "{YOUR PATH}/arm-himix100-linux/arm-linux-uclibceabi/include/c++/6.3.0",
	    "{YOUR PATH}/arm-himix100-linux/lib/gcc/arm-linux-uclibceabi/6.3.0/include",
        ],
        TOOLCHAIN_IDENTIFIER : "arm-himix100-linux-",
        TOOLCHAIN_CC_COMPILER : "gcc"
    },
    "android_armv7a" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "android",
        TOOLCHAIN_TARGET_ARCH : "arm",
        TOOLCHAIN_EMPTY : "true",
    },
    "android_aarch64" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "android",
        TOOLCHAIN_TARGET_ARCH : "aarch64",
        TOOLCHAIN_EMPTY : "true",
    },
    "android_x86_64" : {
        TOOLCHAIN_HOST_OS : "linux",
        TOOLCHAIN_TARGET_OS : "android",
        TOOLCHAIN_TARGET_ARCH : "x86_64",
        TOOLCHAIN_EMPTY : "true",
    },
}
