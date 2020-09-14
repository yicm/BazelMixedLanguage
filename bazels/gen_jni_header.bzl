def _android_jar(android_api_level):
    if android_api_level == -1:
        return None
    return Label("@androidsdk//:platforms/android-%s/android.jar" % android_api_level)

def _impl(ctx):
    java_home = str(ctx.attr._jdk[java_common.JavaRuntimeInfo].java_home)
    javah = "%s/bin/javah" % java_home
    transitive_deps = []

    if ctx.attr._android_jar:
        transitive_deps.append(ctx.attr._android_jar.files)

    classpath = depset([], transitive = transitive_deps).to_list()

    cmd = (
        '%s ' % javah +
        '-cp ' + ':'.join([jar.path for jar in classpath]) +
        ":." +
        ":execroot/__main__:%s" % ctx.attr.base_dir
    )

    deps = depset(transitive = [dep.files for dep in ctx.attr.deps]).to_list()
    for f in ctx.attr.classes:
        output_filename = '%s.h' % f.replace('.', '_')
        out = ctx.actions.declare_file(output_filename)
        run_cmd = cmd + ' -d %s ' % out.dirname + f
        print(run_cmd)
        ctx.actions.run_shell(
            inputs = deps + classpath + ctx.files._jdk,
            command = run_cmd,
            outputs = [out],
        )

gen_jni_header= rule(
    implementation = _impl,
    attrs = {
        "base_dir": attr.string(default="", mandatory=False),
        "deps": attr.label_list(allow_empty=True, allow_files=True),
        "classes": attr.string_list(mandatory=True),
        "android_api_level": attr.int(default = 21),
        "_android_jar": attr.label(
            default=_android_jar,
            allow_single_file=True,
        ),
        "_jdk": attr.label(
            default=Label("@bazel_tools//tools/jdk:current_java_runtime"),
            providers=[java_common.JavaRuntimeInfo],
        ),
        "outputs": attr.output_list(allow_empty=False, mandatory=True),
    },
)
