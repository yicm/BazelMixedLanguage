load("//platforms:constraint_set_raw.bzl",
    "get_available_unique_platform_idetifier",
    "get_available_target_os_list",
    "get_available_target_arch_list",
    "get_available_identifier_list",
    "get_available_compiler_type_list",
)

load("//toolchains/cpp:supported.bzl",
    "TOOLCHAIN_TARGET_OS",
    "TOOLCHAIN_TARGET_ARCH",
    "TOOLCHAIN_IDENTIFIER",
    "TOOLCHAIN_CC_COMPILER",
)

def generate_constraint_set_platform():
    available = get_available_unique_platform_idetifier()

    native.constraint_setting(
        name = "platform",
        visibility = ["//visibility:public"],
    )

    for item in available:
        native.constraint_value(
            name = item,
            constraint_setting = ":platform",
            visibility = ["//visibility:public"],
        )


def generate_constraint_set_target_os():
    available = get_available_target_os_list()

    native.constraint_setting(
        name = TOOLCHAIN_TARGET_OS,
        visibility = ["//visibility:public"],
    )

    for item in available:
        native.constraint_value(
            name = item,
            constraint_setting = ":%s" % TOOLCHAIN_TARGET_OS,
            visibility = ["//visibility:public"],
        )

def generate_constraint_set_target_arch():
    available = get_available_target_arch_list()

    native.constraint_setting(
        name = TOOLCHAIN_TARGET_ARCH,
        visibility = ["//visibility:public"],
    )

    for item in available:
        native.constraint_value(
            name = item,
            constraint_setting = ":%s" % TOOLCHAIN_TARGET_ARCH,
            visibility = ["//visibility:public"],
        )

def generate_constraint_set_toolchain_identifier():
    available = get_available_identifier_list()

    native.constraint_setting(
        name = TOOLCHAIN_IDENTIFIER,
        visibility = ["//visibility:public"],
    )

    for item in available:
        native.constraint_value(
            name = item,
            constraint_setting = ":%s" % TOOLCHAIN_IDENTIFIER,
            visibility = ["//visibility:public"],
        )

def generate_constraint_set_compiler_type():
    available = get_available_compiler_type_list()

    native.constraint_setting(
        name = TOOLCHAIN_CC_COMPILER,
        visibility = ["//visibility:public"],
    )

    for item in available:
        native.constraint_value(
            name = item,
            constraint_setting = ":%s" % TOOLCHAIN_CC_COMPILER,
            visibility = ["//visibility:public"],
        )

def generate_device_platform():
    available = get_available_unique_platform_idetifier()

    for platform in available:
        native.platform(
            name = "p_%s" % platform,
            constraint_values = [
                "//platforms:%s" % platform
            ],
            visibility = ["//visibility:public"],
        )
