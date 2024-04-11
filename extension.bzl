"""
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _cloudsmith_url(token, leaf):
    """
    Format a URL given the basic entitlement token, and the leaf path for the package.

    Args:
        token: The basic entitlement token for the Cloudsmith repo
        leaf: The end of the raw package url
    """
    return "https://dl.cloudsmith.io/{}/kopernikusauto/kvs/raw/names/{}".format(token, leaf)

def _tricore_gcc_archives_impl(ctx):
    token = ctx.getenv("CLOUDSMITH_TOKEN", "XXX")
    http_archive(
        name = "tricore_gcc_linux_x86_64",
        strip_prefix = "tricore-elf",
        #url = _cloudsmith_url(token, "tricore-gcc_linux-x86_64/versions/11.3.1/tricore-elf-gcc-11.3.1.tar.xz"),
        url = "https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/tricore-elf-gcc-11.3.1.tar.xz",
        sha256 = "de02d8befcbac36f3bc9f1b06ec0e2059b3b2d6411b2259152cac05eb5d4267c",
        build_file = "@kvs_toolchains//toolchain/archives:tricore_gcc_11.3.1.BUILD",
    )

    http_archive(
        name = "tricore_gcc_windows_x86_64",
        strip_prefix = "tricore-gcc",
        url = _cloudsmith_url(token, "tricore-gcc_windows-x86_64/versions/11.3.1/tricore-elf-gcc-11.3.1-windows.tar.xz"),
        sha256 = "ce11520e9ad0caebaab74f5bf85dbcd524c7203df8c319df249610809f9b4f83",
        build_file = "@kvs_toolchains//toolchain/archives:tricore_gcc_11.3.1.BUILD",
    )

    http_archive(
        name = "aurix_flasher",
        strip_prefix = "aurix-flasher",
        url = _cloudsmith_url(token, "aurix-flasher/versions/1.0.8.0/aurix-flasher-1.0.8.0.tar.xz"),
        sha256 = "ef265195e1323bf6f6f05893c7264faedf9d7ad2544b512f64a3d12c7112f1f2",
        build_file = "@kvs_toolchains//toolchain/archives:aurix_flasher.BUILD",
    )

tricore_gcc_archives = module_extension(
    implementation = _tricore_gcc_archives_impl,
)
