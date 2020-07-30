load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "tool_path",
    "flag_set",
    "flag_group",
)

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

def _impl(ctx):
    all_link_actions = [
        ACTION_NAMES.cpp_link_executable,
        ACTION_NAMES.cpp_link_dynamic_library,
        ACTION_NAMES.cpp_link_nodeps_dynamic_library,
    ]

    features = [
        feature(
            name = "default_linker_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = ([
                        flag_group(
                            flags = [
                                "-lstdc++",
                            ],
                        ),
                    ]),
                )
            ],
        ),
    ]

    cxx_builtin_include_directories = ctx.attr.include_paths
    artifact_name_patterns = []
    make_variables = []

    tool_paths = [
        tool_path(name = "ar", path = "{}{}ar".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "compat-ld", path = "{}{}ld".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "cpp", path = "{}{}cpp".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "dwp", path = "{}{}dwp".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "gcc", path = "{}{}gcc".format(ctx.attr.compiler_root, ctx.attr.toolchain_identifier)),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "ld", path = "/bin/false"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objcopy", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
        tool_path(name = "strip", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        action_configs = [],
        artifact_name_patterns = artifact_name_patterns,
        cxx_builtin_include_directories = cxx_builtin_include_directories,
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
        "target_arch" : attr.string(default = "x86_64"),
        "cc_compiler" : attr.string(default = "gcc", doc = "The compiler type."),
        "extra_features": attr.string_list(),
    },
    provides = [CcToolchainConfigInfo],
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
