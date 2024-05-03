"""
This BUILD file is used to provide the content of a llvm_mingw archive
"""

load("@kvs_toolchains//toolchain/config:llvm_mingw.bzl", "cc_llvm_mingw_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

PREFIX = "x86_64-w64-mingw32"

TOOLS = [
    "as",
    "c++",
    "clang++",
    "clang",
    "nm",
    "objcopy",
    "readelf",
    "strip",
    "size",
]

# executables.
[
    filegroup(
        name = tool,
        srcs = ["bin/{}-{}.exe".format(PREFIX, tool)],
    )
    for tool in TOOLS
]

[
    filegroup(
        name = tool,
        srcs = ["bin/{}.exe".format(tool)],
    )
    for tool in [
        "llvm-addr2line",
        "llvm-ar",
        "llvm-cov",
        "llvm-cvtres",
        "llvm-cxxfilt",
        "llvm-dlltool",
        "llvm-ml",
        "llvm-nm",
        "llvm-objcopy",
        "llvm-objdump",
        "llvm-pdbutil",
        "llvm-profdata",
        "llvm-ranlib",
        "llvm-rc",
        "llvm-readelf",
        "llvm-readobj",
        "llvm-size",
        "llvm-strings",
        "llvm-strip",
        "llvm-symbolizer",
        "llvm-windres",
        "llvm-wrapper",
        "clang-format",
        "clang-tidy",
    ]
]

filegroup(
    name = "include_path",
    srcs = [
        "include",
        "include/c++/v1",
        "lib/clang/18/include",
    ],
)

# Just the components to add to the library path.
filegroup(
    name = "library_path",
    srcs = [
        "{}/lib".format(PREFIX),
        "lib/clang/18/lib/windows",
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

cc_llvm_mingw_toolchain_config(
    name = "cc_toolchain_config",
    include_path = [":include_path"],
    library_path = [":library_path"],
    llvm_repo = "llvm_mingw_ucrt",
    toolchain_bins = ":toolchain_bins",
)
