load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")
load("//toolchains/cpp:supported.bzl", "TOOLCHAIN_SUPPORT_MATRIX", "BAZEL_EXEC_PLATFORM_INFO")
load("//toolchains/cpp:my_cc_toolchain_config.bzl", "my_cc_toolchain_config")

def generate_toolchain_suite():
    toolchains = {}
    native.filegroup(name = "empty")

    for (platform, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        host_os = toolchain_info["host_os"]
        target_os = toolchain_info["target_os"]
        target_arch = toolchain_info["target_arch"]
        compiler_root = toolchain_info["compiler_root"]
        include_paths = toolchain_info["include_paths"]
        toolchain_identifier = toolchain_info["toolchain_identifier"]
        cc_compiler = toolchain_info["cc_compiler"]

        base_name = "{platform}_{target_os}_{target_arch}_{cc_compiler}_{toolchain_identifier}".format(
            platform = platform,
            target_os = target_os,
            target_arch = target_arch,
            cc_compiler = cc_compiler,
            toolchain_identifier = toolchain_identifier
        )

        configuration_name = "%s_cc_toolchain_config" % base_name
        toolchain_name = "%s_cc_toolchain" % base_name
        toolchain_name = "%s_cc" % base_name

        my_cc_toolchain_config(
            name = configuration_name,
            include_paths = include_paths,
            compiler_root = compiler_root,
            host_os = host_os,
            toolchain_identifier = toolchain_identifier,
            target_os = target_os,
            target_arch = target_arch,
            cc_compiler = cc_compiler,
            extra_features = [],
        )

        cc_toolchain(
            name = toolchain_name,
            toolchain_identifier = toolchain_name,
            toolchain_config = ":%s" % configuration_name,
            all_files = ":empty",
            compiler_files = ":empty",
            dwp_files = ":empty",
            linker_files = ":empty",
            objcopy_files = ":empty",
            strip_files = ":empty",
            supports_param_files = 0,
        )

        if platform in toolchains.keys():
            print("%s already exist!" % platform)
            fail("%s already exist!" % platform)
        else:
            toolchains[platform] = toolchain_name

    print("toolchains = ", toolchains)
    cc_toolchain_suite(
        name = "compiler_suite",
        toolchains = toolchains
    )


