load("//bazels:json_parser.bzl", "json_parse")

def _is_absolute(path):
    """Returns `True` if `path` is an absolute path.
    Args:
      path: A path (which is a string).
    Returns:
      `True` if `path` is an absolute path.
    """
    return path.startswith("/") or (len(path) > 2 and path[1] == ":")


# ========================================
def _auto_gen_repo_impl(ctx):
    ctx.file("hello.txt", ctx.attr.message)
    ctx.file("BUILD.bazel", 'exports_files(["hello.txt"])')

auto_gen_repo = repository_rule(
    implementation = _auto_gen_repo_impl,
    attrs = {
        "message": attr.string(
            mandatory = True,
        ),
    },
)


# ========================================
def _my_read_conf_file_repo_impl(repository_ctx):
    content = repository_ctx.read(repository_ctx.path(repository_ctx.attr.conf))
    print("content = ", content)
    json_content = json_parse(content, fail_on_invalid = False)

    build_content = ""
    modules_var = "MODULES = ["
    if json_content == None:
        fail("Failed to parse %s. Is this file valid JSON? The file may have been corrupted." %
             repository_ctx.path(repository_ctx.attr.conf))
    if json_content["modules"] == None:
        fail("Failed to get modules information in %s. Please check it!" %
             repository_ctx.path(repository_ctx.attr.conf))

    for module in json_content["modules"]:
        modules_var += "'//src/" + module + "', "
    build_content += modules_var + "]"
    repository_ctx.file("BUILD.bazel", "")
    repository_ctx.file("modules.bzl", build_content)

my_read_conf_file_repo = repository_rule(
    implementation = _my_read_conf_file_repo_impl,
    attrs = {
        "conf" : attr.label(allow_single_file = True),
    },
)

def _my_set_env_vars(repository_ctx):
    home = repository_ctx.os.environ.get("HOME", default = "")
    print("User home directory: ", home)
    content = "HOME = '" + home + "'"
    repository_ctx.file("env.bzl", content)
    repository_ctx.file("BUILD.bazel", "")

my_set_env_vars = repository_rule(
    implementation = _my_set_env_vars,
)


