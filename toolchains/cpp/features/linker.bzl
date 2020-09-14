load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_set",
    "flag_group",
    "with_feature_set",
)

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")

load(
    "@bazel_tools//tools/build_defs/cc:action_names.bzl",
    _ASSEMBLE_ACTION_NAME = "ASSEMBLE_ACTION_NAME",
    _CLIF_MATCH_ACTION_NAME = "CLIF_MATCH_ACTION_NAME",
    _CPP_COMPILE_ACTION_NAME = "CPP_COMPILE_ACTION_NAME",
    _CPP_HEADER_PARSING_ACTION_NAME = "CPP_HEADER_PARSING_ACTION_NAME",
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_LINK_EXECUTABLE_ACTION_NAME = "CPP_LINK_EXECUTABLE_ACTION_NAME",
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME = "CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME",
    _CPP_MODULE_CODEGEN_ACTION_NAME = "CPP_MODULE_CODEGEN_ACTION_NAME",
    _CPP_MODULE_COMPILE_ACTION_NAME = "CPP_MODULE_COMPILE_ACTION_NAME",
    _C_COMPILE_ACTION_NAME = "C_COMPILE_ACTION_NAME",
    _LINKSTAMP_COMPILE_ACTION_NAME = "LINKSTAMP_COMPILE_ACTION_NAME",
    _LTO_BACKEND_ACTION_NAME = "LTO_BACKEND_ACTION_NAME",
    _PREPROCESS_ASSEMBLE_ACTION_NAME = "PREPROCESS_ASSEMBLE_ACTION_NAME",
)

all_link_actions = [
    _CPP_LINK_EXECUTABLE_ACTION_NAME,
    _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
    _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
]

def generate_linker_features(ctx):
    features = []
    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)
    supports_pic_feature = feature(name = "supports_pic", enabled = True)
    objcopy_embed_flags_feature = feature(
        name = "objcopy_embed_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ["objcopy_embed_data"],
                flag_groups = [flag_group(flags = ["-I", "binary"])],
            ),
        ],
    )

    dbg_feature = feature(name = "dbg")
    opt_feature = feature(name = "opt")

    if (ctx.attr.target_os == "linux"):
        # link feature
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                #"-Wl,-z,relro,-z,now",
                                #"-no-canonical-prefixes",
                                #"-pass-exit-codes",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
        # compile feature
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-U_FORTIFY_SOURCE",
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-Wall",
                                "-Wunused-but-set-parameter",
                                "-Wno-free-nonheap-object",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O2",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = [
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [flag_group(flags = ["-std=c++11"])],
                ),
            ],
        )

        # user compile feature
        user_compile_flags_feature = feature(
            name = "user_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _ASSEMBLE_ACTION_NAME,
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["%{user_compile_flags}"],
                            iterate_over = "user_compile_flags",
                            expand_if_available = "user_compile_flags",
                        ),
                    ],
                ),
            ],
        )
        # sysroot feature
        sysroot_feature = feature(
            name = "sysroot",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = [
                        _PREPROCESS_ASSEMBLE_ACTION_NAME,
                        _LINKSTAMP_COMPILE_ACTION_NAME,
                        _C_COMPILE_ACTION_NAME,
                        _CPP_COMPILE_ACTION_NAME,
                        _CPP_HEADER_PARSING_ACTION_NAME,
                        _CPP_MODULE_COMPILE_ACTION_NAME,
                        _CPP_MODULE_CODEGEN_ACTION_NAME,
                        _LTO_BACKEND_ACTION_NAME,
                        _CLIF_MATCH_ACTION_NAME,
                        _CPP_LINK_EXECUTABLE_ACTION_NAME,
                        _CPP_LINK_DYNAMIC_LIBRARY_ACTION_NAME,
                        _CPP_LINK_NODEPS_DYNAMIC_LIBRARY_ACTION_NAME,
                    ],
                    flag_groups = [
                        flag_group(
                            flags = ["--sysroot=%{sysroot}"],
                            expand_if_available = "sysroot",
                        ),
                    ],
                ),
            ],
        )


    if (ctx.attr.target_os == "windows" and ctx.attr.cc_compiler == "msys"):
        features = []
    elif (ctx.attr.target_os == "darwin"):
        features = []
    elif (ctx.attr.target_os == "linux" and ctx.attr.target_arch == "x86_64" or
          ctx.attr.target_os == "linux" and ctx.attr.target_arch == "x86"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            objcopy_embed_flags_feature,
            opt_feature,
            dbg_feature,
            user_compile_flags_feature,
            sysroot_feature,
        ]
    elif (ctx.attr.target_os == "windows"
          and ctx.attr.cc_compiler == "clang"
          and ctx.attr.target_arch == "x86-64"
          or
          ctx.attr.target_os == "windows"
          and ctx.attr.cc_compiler == "mingw"
          and ctx.attr.target_arch == "x86-64"):
        features = []
    elif (ctx.attr.target_os == "linux" and ctx.attr.target_arch == "armv7a" or
          ctx.attr.target_os == "linux" and ctx.attr.target_arch == "arm" or
          ctx.attr.target_os == "linux" and ctx.attr.target_arch == "aarch64"):
        features = [
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature
        ]

    return features
