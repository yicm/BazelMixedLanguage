load("@rules_cc//cc:defs.bzl", "cc_toolchain", "cc_toolchain_suite")
load("//toolchains/cpp:supported.bzl",
    "TOOLCHAIN_SUPPORT_MATRIX",
    "BAZEL_EXEC_PLATFORM_INFO",
    "TOOLCHAIN_HOST_OS",
    "TOOLCHAIN_TARGET_OS",
    "TOOLCHAIN_TARGET_ARCH",
    "TOOLCHAIN_TARGET_CGO",
    "TOOLCHAIN_COMPILER_ROOT",
    "TOOLCHAIN_INCLUDE_PATHS",
    "TOOLCHAIN_IDENTIFIER",
    "TOOLCHAIN_CC_COMPILER",
    "TOOLCHAIN_EMPTY",
)
load("//toolchains/cpp:my_cc_toolchain_config.bzl", "my_cc_toolchain_config")


def generate_toolchain_suite():
    native.filegroup(name = "empty")

    toolchains = {}
    for (platform, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        host_os = toolchain_info[TOOLCHAIN_HOST_OS]
        target_os = toolchain_info[TOOLCHAIN_TARGET_OS]
        target_arch = toolchain_info[TOOLCHAIN_TARGET_ARCH]
    
        toolchain_empty = toolchain_info[TOOLCHAIN_EMPTY]
        if toolchain_empty == 'true':
            print("toolchain does not need to set, continuing.")
            continue

        compiler_root = toolchain_info[TOOLCHAIN_COMPILER_ROOT]
        include_paths = toolchain_info[TOOLCHAIN_INCLUDE_PATHS]
        toolchain_identifier = toolchain_info[TOOLCHAIN_IDENTIFIER]
        cc_compiler = toolchain_info[TOOLCHAIN_CC_COMPILER]

        base_name = "{platform}_{target_os}_{target_arch}_{cc_compiler}_{toolchain_identifier}".format(
            platform = platform,
            target_os = target_os,
            target_arch = target_arch,
            cc_compiler = cc_compiler,
            toolchain_identifier = toolchain_identifier
        )

        configuration_name = "%s_cc_toolchain_config" % base_name
        cc_name = "%s_cc_toolchain" % base_name
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
            name = cc_name,
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
            toolchains[platform] = cc_name

    print("toolchains = ", toolchains)
    cc_toolchain_suite(
        name = "compiler_suite",
        toolchains = toolchains
    )


def generate_toolchains():
    toolchains = {}
    native.filegroup(name = "empty")

    for (platform, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        host_os = toolchain_info[TOOLCHAIN_HOST_OS]
        target_os = toolchain_info[TOOLCHAIN_TARGET_OS]
        target_arch = toolchain_info[TOOLCHAIN_TARGET_ARCH]
        
        toolchain_empty = toolchain_info[TOOLCHAIN_EMPTY]
        if toolchain_empty == 'true':
            print("toolchain does not need to set, continuing.")
            continue

        target_cgo = toolchain_info[TOOLCHAIN_TARGET_CGO]
        compiler_root = toolchain_info[TOOLCHAIN_COMPILER_ROOT]
        include_paths = toolchain_info[TOOLCHAIN_INCLUDE_PATHS]
        toolchain_identifier = toolchain_info[TOOLCHAIN_IDENTIFIER]
        cc_compiler = toolchain_info[TOOLCHAIN_CC_COMPILER]

        base_name = "{platform}_{target_os}_{target_arch}_{cc_compiler}_{toolchain_identifier}".format(
            platform = platform,
            target_os = target_os,
            target_arch = target_arch,
            cc_compiler = cc_compiler,
            toolchain_identifier = toolchain_identifier
        )

        configuration_name = "%s_cc_toolchain_config" % base_name
        cc_name = "%s_cc_toolchain" % base_name
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
            name = cc_name,
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
            toolchains[platform] = cc_name

        bazel_exec_platform_info = BAZEL_EXEC_PLATFORM_INFO
        #print("bazel_exec_platform_info: ", bazel_exec_platform_info)
        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = [
                "@platforms//cpu:%s" % bazel_exec_platform_info["cpu"],
                "@platforms//os:%s" % bazel_exec_platform_info["os"],
            ],
            target_compatible_with = [
                "//platforms/devices:%s" % platform,
                "@platforms//os:%s" % target_os,
                "@platforms//cpu:%s" % target_arch,
                "@io_bazel_rules_go//go/toolchain:cgo_%s" % target_cgo,
            ],
            toolchain = "//toolchains/cpp:%s" % cc_name,
            toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
        )

    return toolchains

