workspace(name = "bazel_mixed_language")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_mixed_language//toolchains/cpp:register.bzl", "my_register_toolchains")


# ----------------------------------------------------------------------
# bazel_skylib
# ----------------------------------------------------------------------
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


# ----------------------------------------------------------------------
# bazelbuild/platforms
# ----------------------------------------------------------------------
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

# ----------------------------------------------------------------------
# register toolchain
# ----------------------------------------------------------------------
my_register_toolchains()
#register_toolchains("//toolchains/cpp:all")


# ----------------------------------------------------------------------
# Buildfarm
# ----------------------------------------------------------------------
# sha256 sum xx.zip
BUILDFARM_EXTERNAL_COMMIT = "f0cb2c3cd3531cacd828acddc1046e3c6f6cc7fd"
BUILDFARM_EXTERNAL_SHA256 = "7fa105eb4fbaecd7e456af238f716f9c802c143e9627d6fb1c97564f40977f9c"

http_archive(
    name = "build_buildfarm",
    strip_prefix = "bazel-buildfarm-%s" % BUILDFARM_EXTERNAL_COMMIT,
    sha256 = BUILDFARM_EXTERNAL_SHA256,
    url = "https://github.com/bazelbuild/bazel-buildfarm/archive/%s.zip" % BUILDFARM_EXTERNAL_COMMIT,
)

load("@build_buildfarm//:deps.bzl", "buildfarm_dependencies")

buildfarm_dependencies()

load("@build_buildfarm//:defs.bzl", "buildfarm_init")

buildfarm_init()


# ----------------------------------------------------------------------
# Config rules_go
# ----------------------------------------------------------------------
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# download rules_go
http_archive(
    name = "io_bazel_rules_go",
    sha256 = "8663604808d2738dc615a2c3eb70eba54a9a982089dd09f6ffe5d0e75771bc4f",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.23.6/rules_go-v0.23.6.tar.gz",
        "https://github.com/bazelbuild/rules_go/releases/download/v0.23.6/rules_go-v0.23.6.tar.gz",
    ],
)

# load rules_go
load("@io_bazel_rules_go//go:deps.bzl", "go_rules_dependencies", "go_register_toolchains")

go_rules_dependencies()

go_register_toolchains()

# ----------------------------------------------------------------------
# download gazelle
# ----------------------------------------------------------------------
http_archive(
    name = "bazel_gazelle",
    sha256 = "cdb02a887a7187ea4d5a27452311a75ed8637379a1287d8eeb952138ea485f7d",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v0.21.1/bazel-gazelle-v0.21.1.tar.gz",
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v0.21.1/bazel-gazelle-v0.21.1.tar.gz",
    ],
)

# load gazelle
load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

# ----------------------------------------------------------------------
# load go repsitories
# ----------------------------------------------------------------------
load("//:go_repositories.bzl", "go_repositories")

# gazelle:repository_macro go_repositories.bzl%go_repositories
go_repositories()
