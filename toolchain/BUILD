load(":cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])

cc_toolchain_config(name = "armv7_toolchain_config")

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

cc_toolchain_suite(
    name = "compiler_suite",
    toolchains = {
        "armv7": ":armv7_toolchain"
    },
)
