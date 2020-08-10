load("//toolchains/cpp:supported.bzl",
    "TOOLCHAIN_SUPPORT_MATRIX",
    "BAZEL_EXEC_PLATFORM_INFO",
    "TOOLCHAIN_TARGET_DEVICE",
    "TOOLCHAIN_HOST_OS",
    "TOOLCHAIN_TARGET_OS",
    "TOOLCHAIN_TARGET_ARCH",
    "TOOLCHAIN_COMPILER_ROOT",
    "TOOLCHAIN_INCLUDE_PATHS",
    "TOOLCHAIN_IDENTIFIER",
    "TOOLCHAIN_CC_COMPILER",
)

def get_available_unique_platform_idetifier():
    results = []

    for (platform, _) in TOOLCHAIN_SUPPORT_MATRIX.items():
        if platform in results:
            continue
        else:
            results.append(platform)

    return results


def get_available_device_info_list():
    results = []

    for (platform, info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        device = {}
        device[TOOLCHAIN_TARGET_DEVICE] = platform
        item = dict(info, **device)
        results.append(item)

    return results

def get_available_target_os_list():
    results = []

    for (_, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        target_os = toolchain_info[TOOLCHAIN_TARGET_OS]
        if target_os in results:
            continue
        else:
            results.append(target_os)

    return results

def get_available_target_arch_list():
    results = []

    for (_, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        target_arch = toolchain_info[TOOLCHAIN_TARGET_ARCH]
        if target_arch in results:
            continue
        else:
            results.append(target_arch)

    return results

def get_available_identifier_list():
    results = []

    for (_, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        toolchain_identifier = toolchain_info[TOOLCHAIN_IDENTIFIER]
        if toolchain_identifier in results:
            continue
        else:
            results.append(toolchain_identifier)

    return results

def get_available_compiler_type_list():
    results = []

    for (_, toolchain_info) in TOOLCHAIN_SUPPORT_MATRIX.items():
        cc_compiler = toolchain_info[TOOLCHAIN_CC_COMPILER]
        if cc_compiler in results:
            continue
        else:
            results.append(cc_compiler)

    return results

