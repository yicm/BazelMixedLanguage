cc_library(
    name = "logger",
    srcs = glob(["*.cpp"]),
    hdrs = glob(["*.h"]),
    linkstatic = True,
    copts = [
        "-Icpp -fPIC",
    ],
    deps = ["@spdlog"],
    visibility = ["//visibility:public"],

)

cc_binary(
    name = "logger_shared",
    srcs = glob(["*.cpp", "*.h"]),
    linkshared = True,
    copts = [
        "-Icpp",
    ],
    linkopts = [
    ],
    deps = ["@spdlog"],
    visibility = ["//visibility:public"],
)

