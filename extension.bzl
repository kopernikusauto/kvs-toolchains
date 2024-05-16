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

def _kvs_toolchain_archives_impl(ctx):
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

    http_archive(
        name = "llvm_mingw_ucrt",
        strip_prefix = "llvm-mingw-20240417-ucrt-x86_64",
        #url = _cloudsmith_url(token, "llvm-mingw-ucrt/versions/18.1.4/llvm-mingw-20240417-ucrt-x86_64.zip"),
        url = "https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/llvm-mingw-20240417-ucrt-x86_64.zip",
        integrity = "sha256-r6aaxA8IchZYu9aCa2M/O1RXnXrkyrH2JMxuLv0Fvw4=",
        build_file = "@kvs_toolchains//toolchain/archives:llvm_mingw_ucrt.BUILD",
    )

    # Originally sourced from: https://toolchains.bootlin.com/
    http_archive(
        name = "gcc_linux_x86_64",
        strip_prefix = "x86_64-centos7-linux-gnu",
        #url = _cloudsmith_url(token, "gcc_linux_x86_64/versions/13.2.0/gcc_13.2.0_x86_64-centos7-linux-gnu.tar.xz"),
        url = "https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/gcc_13.2.0_x86_64-centos7-linux-gnu.tar.xz",
        sha256 = "b79fcb3fe1f6e9d3b96d514aff120fa2e6e98f8df3730feb80df07129f82b476",
        build_file = "@kvs_toolchains//toolchain/archives:gcc_linux_x86_64_13.2.0.BUILD",
    )

kvs_toolchain_archives = module_extension(
    implementation = _kvs_toolchain_archives_impl,
)
