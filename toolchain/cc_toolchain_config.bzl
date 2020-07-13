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
    #cc_toolchain = find_cpp_toolchain(ctx)
    #print("cpu = ", cc_toolchain.cpu)
    #print("target_gnu_system_name = ", cc_toolchain.target_gnu_system_name)
    #print()
    #print(cc_toolchain)
    toolchain_identifier = "stub_armeabi-v7a"
    host_system_name = "armeabi-v7a"
    target_system_name = "armeabi-v7a"
    target_cpu = "armeabi-v7a"
    target_libc = "armeabi-v7a"
    compiler = "compiler"
    abi_version = "armeabi-v7a"
    abi_libc_version = "armeabi-v7a"
    cc_target_os = None
    builtin_sysroot = None
    action_configs = []

    #supports_pic_feature = feature(name = "supports_pic", enabled = True)
    #supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)
    #features = [supports_dynamic_linker_feature, supports_pic_feature]
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

    cxx_builtin_include_directories = [
        "/home/SENSETIME/yichengming/Softwares/arm-himix100-linux/target/usr/include/",
        "/home/SENSETIME/yichengming/Softwares/arm-himix100-linux/arm-himix100-linux/include/c++/6.3.0/",
        "/home/SENSETIME/yichengming/Softwares/arm-himix100-linux/arm-linux-uclibceabi/include/c++/6.3.0/",
        "/home/SENSETIME/yichengming/Softwares/arm-himix100-linux/lib/gcc/arm-linux-uclibceabi/6.3.0/include/"
    ]
    artifact_name_patterns = []
    make_variables = []

    tool_paths = [
        tool_path(name = "ar", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-ar"),
        tool_path(name = "compat-ld", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-compat-ld"),
        tool_path(name = "cpp", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-cpp"),
        tool_path(name = "dwp", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-dwp"),
        tool_path(name = "gcc", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-gcc"),
        tool_path(name = "gcov", path = "/bin/false"),
        tool_path(name = "ld", path = "/home/ethan/Softwares/arm-himix100-linux/bin/arm-himix100-linux-ld"),
        tool_path(name = "nm", path = "/bin/false"),
        tool_path(name = "objcopy", path = "/bin/false"),
        tool_path(name = "objdump", path = "/bin/false"),
        tool_path(name = "strip", path = "/bin/false"),
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        action_configs = action_configs,
        artifact_name_patterns = artifact_name_patterns,
        cxx_builtin_include_directories = cxx_builtin_include_directories,
        toolchain_identifier = toolchain_identifier,
        host_system_name = host_system_name,
        target_system_name = target_system_name,
        target_cpu = target_cpu,
        target_libc = target_libc,
        compiler = compiler,
        abi_version = abi_version,
        abi_libc_version = abi_libc_version,
        tool_paths = tool_paths,
        make_variables = make_variables,
        builtin_sysroot = builtin_sysroot,
        cc_target_os = cc_target_os,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        #"src": attr.label(mandatory = True, allow_single_file = True),
        #"_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    provides = [CcToolchainConfigInfo],
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
)
