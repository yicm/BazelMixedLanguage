load("//platforms:constraint_set_raw.bzl",
    "get_available_device_info_list",
)

load("//toolchains/cpp:supported.bzl",
    "TOOLCHAIN_TARGET_DEVICE",
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



def generate_device_platform():
    available = get_available_device_info_list()

    for device in available:
        target_platform = device[TOOLCHAIN_TARGET_DEVICE]
        target_os = device[TOOLCHAIN_TARGET_OS]
        target_arch = device[TOOLCHAIN_TARGET_ARCH]

        toolchain_empty = device[TOOLCHAIN_EMPTY]

        if toolchain_empty == 'true':
            native.platform(
                name = "p_%s" % target_platform,
                constraint_values = [
                    "//platforms/devices:%s" % target_platform,
                    # needs three constraint values in rules_go for cross-compile
                    "@platforms//os:%s" % target_os,
                    "@platforms//cpu:%s" % target_arch,
                    "@io_bazel_rules_go//go/toolchain:cgo_off",
                ],
                visibility = ["//visibility:public"],
            )
        else:
            target_cgo = device[TOOLCHAIN_TARGET_CGO]
            #print("target_os = ", target_os)
            #print("target_arch = ", target_arch)
            #print("target_cgo = ", target_cgo)
            native.platform(
                name = "p_%s" % target_platform,
                constraint_values = [
                    "//platforms/devices:%s" % target_platform,
                    # needs three constraint values in rules_go for cross-compile
                    "@platforms//os:%s" % target_os,
                    "@platforms//cpu:%s" % target_arch,
                    "@io_bazel_rules_go//go/toolchain:cgo_%s" % target_cgo,
                ],
                visibility = ["//visibility:public"],
            )
