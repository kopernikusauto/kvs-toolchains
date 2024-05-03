"""
This BUILD file is used to provide the content of a llvm_mingw archive
"""

load("@kvs_toolchains//toolchain/config:gcc.bzl", "cc_gcc_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

PREFIX = "x86_64-centos7-linux-gnu"

VERSION = "13.2.0"

[
    filegroup(
        name = tool,
        srcs = ["bin/{}-{}".format(PREFIX, tool)],
    )
    for tool in [
        "addr2line",
        "ar",
        "as",
        "c++",
        "c++.br_real",
        "c++filt",
        "cc",
        "cpp",
        "elfedit",
        "g++",
        "gcc",
        "gcc-ar",
        "gcc-nm",
        "gcc-ranlib",
        "gcc.br_real",
        "gcov",
        "gcov-dump",
        "gcov-tool",
        "gprof",
        "gprofng",
        "ld",
        "ld.gold",
        "lto-dump",
        "nm",
        "objcopy",
        "objdump",
        "ranlib",
        "readelf",
        "size",
        "strings",
        "strip",
    ]
]

filegroup(
    name = "python",
    srcs = ["bin/python3.11"],
)

filegroup(
    name = "bison",
    srcs = ["bin/bison"],
)

filegroup(
    name = "yacc",
    srcs = ["bin/yacc"],
)

filegroup(
    name = "include_path",
    srcs = [
        "lib/gcc/{}/{}/include".format(PREFIX, VERSION),
        "lib/gcc/{}/{}/include-fixed".format(PREFIX, VERSION),
        "{}/include".format(PREFIX),
        "{}/include/c++/{}".format(PREFIX, VERSION),
        "{}/include/c++/{}/backward".format(PREFIX, VERSION),
        "{}/include/c++/{}/tr1".format(PREFIX, VERSION),
        "{}/include/c++/{}/{}".format(PREFIX, VERSION, PREFIX),
        "{}/sysroot/usr/include".format(PREFIX),
    ],
)

# Just the components to add to the library path.
filegroup(
    name = "library_path",
    srcs = [
        "lib",
        "{}/lib".format(PREFIX),
        "{}/lib64".format(PREFIX),
        "{}/sysroot/lib64".format(PREFIX),
        "{}/sysroot/usr/lib64".format(PREFIX),
    ],
)

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

# libraries, headers and executables.
filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "bin/**",
    ]),
)

filegroup(
    name = "sysroot",
    srcs = glob([
        "{}/sysroot/**".format(PREFIX),
    ]),
)

cc_toolchain(
    name = "cc_toolchain",
    all_files = ":all",
    ar_files = ":all",
    as_files = ":all",
    compiler_files = ":all",
    dwp_files = ":all",
    linker_files = ":all",
    objcopy_files = ":all",
    static_runtime_lib = ":all",
    strip_files = ":all",
    toolchain_config = ":cc_toolchain_config",
)

cc_gcc_toolchain_config(
    name = "cc_toolchain_config",
    include_path = [":include_path"],
    library_path = [":library_path"],
    sysroot = "{}/sysroot".format(PREFIX),
    toolchain_bins = ":toolchain_bins",
)
