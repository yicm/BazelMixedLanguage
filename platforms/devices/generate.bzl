load("//platforms:constraint_set_raw.bzl",
    "get_available_unique_platform_idetifier",
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

        native.config_setting(
            name = "is_%s" % item,
            constraint_values = [":%s" % item],
            visibility = ["//visibility:public"]
        )
