load(":my_cc_toolchain_config.bzl", "my_cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

my_cc_toolchain_config(
    name = "armv7_toolchain_config",
    include_paths = [
        "/usr/arm-linux-gnueabihf/include/",
        "/usr/lib/gcc-cross/arm-linux-gnueabihf/7/include",
    ],
    compiler_root = "/usr/bin/",
    host_os = "linux",
    toolchain_identifier = "arm-linux-gnueabihf-",
    target_os = "linux",
    target_arch = "armv7a",
    cc_compiler = "gcc",
    extra_features = [],
)

my_cc_toolchain_config(
    name = "x86_64_toolchain_config",
    include_paths = [
        "/usr/include",
        "/usr/lib/gcc/x86_64-linux-gnu/7/include/",
    ],
    compiler_root = "/usr/bin/",
    host_os = "linux",
    toolchain_identifier = "",
    target_os = "linux",
    target_arch = "x86-64",
    cc_compiler = "gcc",
    extra_features = [],
)

filegroup(name = "empty")

cc_toolchain(
    name = "armv7_toolchain",
    toolchain_identifier = "armv7_toolchain",
    toolchain_config = ":armv7_toolchain_config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)

cc_toolchain(
    name = "x86_64_toolchain",
    toolchain_identifier = "x86_64_toolchain",
    toolchain_config = ":x86_64_toolchain_config",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 0,
)



cc_toolchain_suite(
    name = "compiler_suite",
    toolchains = {
        "armv7": ":armv7_toolchain",
        "x86-64" : ":x86_64_toolchain"
    },
)
