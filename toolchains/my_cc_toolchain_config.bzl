load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "tool_path",
    "flag_set",
    "flag_group",
    "with_feature_set",
)

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

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

def _impl(ctx):
    # ===========================================================
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
                                "-Wl,-z,relro,-z,now",
                                "-no-canonical-prefixes",
                                "-pass-exit-codes",
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
                    flag_groups = [flag_group(flags = ["-std=c++0x"])],
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
    elif (ctx.attr.target_os == "linux" and ctx.attr.target_arch == "x86-64" or
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
    elif (ctx.attr.target_os == "windows" and ctx.attr.cc_compiler == "clang" and ctx.attr.target_arch == "x86-64" or
          ctx.attr.target_os == "windows" and ctx.attr.cc_compiler == "mingw" and ctx.attr.target_arch == "x86-64"):
        features = []
    elif (ctx.attr.target_os == "linux" and ctx.attr.target_arch == "armv7" or
          ctx.attr.target_os == "linux" and ctx.attr.target_arch == "aarch64"):
        features = [supports_dynamic_linker_feature, supports_pic_feature]


    tool_paths = [
        tool_path(name = "ar", path = "{}{}ar".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "compat-ld", path = "{}{}ld".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "cpp", path = "{}{}cpp".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "dwp", path = "{}{}dwp".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "gcc", path = "{}{}gcc".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "ld", path = "{}{}ld".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "strip", path = "{}{}strip".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objcopy", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        action_configs = [],
        artifact_name_patterns = [],
        cxx_builtin_include_directories = ctx.attr.include_paths,
        toolchain_identifier = ctx.attr.toolchain_identifier,
        host_system_name = ctx.attr.host_os,
        target_system_name = ctx.attr.target_os,
        target_cpu = ctx.attr.target_arch,
        target_libc = ctx.attr.cc_compiler,
        compiler = ctx.attr.cc_compiler,
        abi_version = ctx.attr.cc_compiler,
        abi_libc_version = ctx.attr.cc_compiler,
        tool_paths = tool_paths,
        make_variables = [],
        builtin_sysroot = None,
        cc_target_os = ctx.attr.target_os,
    )

my_cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "include_paths" : attr.string_list(doc = "The compiler include directories."),
        "compiler_root" : attr.string(doc = "The compiler root directory."),
        "host_os" : attr.string(default = "linux", doc = "The cross toolchain prefix."),
        "toolchain_identifier": attr.string(),
        "target_os" : attr.string(default = "linux"),
        "target_arch" : attr.string(default = "x86-64"),
        "cc_compiler" : attr.string(default = "gcc", doc = "The compiler type."),
        "extra_features": attr.string_list(),
    },
    provides = [CcToolchainConfigInfo],
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
