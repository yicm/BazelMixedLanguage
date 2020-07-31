BAZEL_EXEC_PLATFORM_INFO = {
    "os" : "linux",
    "cpu" : "x86_64"
}

TOOLCHAIN_SUPPORT_MATRIX = {
    "hisi": {
        "host_os" : "linux",
        "target_os" : "linux",
        "target_arch" : "armv7",
        "compiler_root" : "",
        "include_paths" : [],
        "toolchain_identifier" : "",
        "cc_compiler" : "gcc"
    },
    "ubuntu_gcc": {
        "host_os" : "linux",
        "target_os" : "linux",
        "target_arch" : "x86-64",
        "compiler_root" : "/usr/bin/",
        "include_paths" : [
            "/usr/include",
            "/usr/lib/gcc",
            "/usr/local/include"
        ],
        "toolchain_identifier" : "",
        "cc_compiler" : "gcc"
    },
    "ubuntu_clang": {
        "host_os" : "linux",
        "target_os" : "linux",
        "target_arch" : "x86-64",
        "compiler_root" : "",
        "include_paths" : [],
        "toolchain_identifier" : "",
        "cc_compiler" : "clang"
    },
    "ubuntu_arm_linux_gnueabihf" : {
        "host_os" : "linux",
        "target_os" : "linux",
        "target_arch" : "aarch64",
        "compiler_root" : "/usr/bin/",
        "include_paths" : [
            "/usr/arm-linux-gnueabihf/include/",
            "/usr/lib/gcc-cross/arm-linux-gnueabihf/7/include",
        ],
        "toolchain_identifier" : "arm-linux-gnueabihf-",
        "cc_compiler" : "gcc"
    }
}
