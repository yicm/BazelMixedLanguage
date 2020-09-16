load("//toolchains/cpp:supported.bzl",
    "TOOLCHAIN_SUPPORT_MATRIX",
    "BAZEL_EXEC_PLATFORM_INFO",
    "TOOLCHAIN_HOST_OS",
    "TOOLCHAIN_TARGET_OS",
    "TOOLCHAIN_TARGET_ARCH",
    "TOOLCHAIN_COMPILER_ROOT",
    "TOOLCHAIN_INCLUDE_PATHS",
    "TOOLCHAIN_IDENTIFIER",
    "TOOLCHAIN_CC_COMPILER",
    "TOOLCHAIN_EMPTY",
)

def _generate_toolchain_names():
    names = []
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

        toolchain_name = "%s_cc" % base_name
        names.append(toolchain_name)
    return names


def _register_toolchains(repo):
    labels = [
        "{}:{}".format(repo, name)
        for name in _generate_toolchain_names()
    ]
    native.register_toolchains(*labels)

def my_register_toolchains():
    _register_toolchains("//toolchains/cpp")
