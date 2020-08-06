load("//platforms:constraint_set_raw.bzl",
    "get_available_unique_platform_idetifier",
)

def generate_device_platform():
    available = get_available_unique_platform_idetifier()

    for platform in available:
        native.platform(
            name = "p_%s" % platform,
            constraint_values = [
                "//platforms/devices:%s" % platform
            ],
            visibility = ["//visibility:public"],
        )
