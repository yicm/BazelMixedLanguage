load("//bazels:gen_jni_header.bzl", "gen_jni_header")


gen_jni_header(
    name = "gen_jni_header",
    android_api_level = 28,
    base_dir = "android/java",
    deps = glob([
        "java/com/xiaobaiai/test/*.java",
    ]),
    classes = [
        "com.xiaobaiai.test.Test",
    ],
    outputs = [
        "com_xiaobaiai_test_Test.h",
    ],
)

cc_library(
    name = "jni_lib",
    hdrs = glob([
        "jni/*.h",
    ]),
    srcs = glob([
        "jni/*.cpp",
    ]),
    #+ [
    #    "@bazel_tools//tools/jdk:current_java_runtime",
    #],    
    copts = [
        #"-Iexternal/local_jdk/include",
        #"-Iexternal/local_jdk/include/linux",        
        #"-Isrc",
    ],
    deps = [
        ":gen_jni_header",      
    ],
    linkopts = ["-llog"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "jni_lib_shared",
    srcs = glob([
        "jni/*.cpp",
        "jni/*.h",
    ]),
    linkshared = True,
    copts = [            
        
    ],
    deps = [
        ":gen_jni_header",        
    ],
    linkopts = [
        "-llog",
    ],
    visibility = ["//visibility:public"],
)