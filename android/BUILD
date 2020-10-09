load("//bazels:gen_jni_header.bzl", "gen_jni_header")


gen_jni_header(
    name = "gen_jni_header",
    android_api_level = 28,
    base_dir = "android/java",
    deps = glob([
        "java/net/xiaobaiai/test/base/*.java",
        "java/net/xiaobaiai/test/*.java",
    ]),
    classes = [
        "net.xiaobaiai.test.APIs",
    ],
    outputs = [
        "net_xiaobaiai_test_APIs.h",
    ],
)

cc_library(
    name = "jni_lib",
    hdrs = glob([
        "jni/*.h",
    ]),
    srcs = glob([
        "jni/*.cpp",
        "jni/*.c",
    ]),  
    copts = [
        "-DAPI_EXPORT_ON",
        "-DANDROID_LOGGER_ON",
    ],
    deps = [
        ":gen_jni_header",      
    ],
    linkopts = [
        "-llog",
        "-landroid",
        "-lm",
    ],
    # must be set alwayslink = True!
    alwayslink = True,
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "jni_lib_shared",
    srcs = glob([
        "jni/*.cpp",
        "jni/*.h",
        "jni/*.c",
    ]),
    linkshared = True,
    copts = [            
        "-DAPI_EXPORT_ON",
        "-DANDROID_LOGGER_ON",
    ],
    deps = [
        ":gen_jni_header",        
    ],
    linkopts = [
        "-llog",
        "-landroid",
        "-lm",
    ],
    visibility = ["//visibility:public"],
)

android_library(
    name = "android_java_lib",
    srcs = glob([
        "java/net/xiaobaiai/test/base/*.java",
        "java/net/xiaobaiai/test/*.java",
    ]),
    custom_package = "net.xiaobaiai.test",
    deps = [
        ":jni_lib",
    ],
    visibility = ["//visibility:public"],
)