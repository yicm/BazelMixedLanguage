load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# bazel_skylib
http_archive(
    name = "bazel_skylib",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
        "https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.2/bazel-skylib-1.0.2.tar.gz",
    ],
    sha256 = "97e70364e9249702246c0e9444bccdc4b847bed1eb03c5a3ece4f83dfe6abc44",
)
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
bazel_skylib_workspace()


# bazelbuild/platforms
http_archive(
    name = "platforms",
    strip_prefix = "platforms-681f1ee032566aa2d443cf0335d012925d9c58d4",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/platforms/archive/681f1ee032566aa2d443cf0335d012925d9c58d4.zip",
        "https://github.com/bazelbuild/platforms/archive/681f1ee032566aa2d443cf0335d012925d9c58d4.zip",
    ],
    # shasum -a 256 xx.zip
    sha256 = "ae95e4bfcd9f66e9dc73a92cee0107fede74163f788e3deefe00f3aaae75c431",
)

# register toolchain
register_toolchains(
    "//toolchains/cpp:all",
)
