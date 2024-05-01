"""
This BUILD file is used to provide the content of a tricore_gcc archive
"""

load("@kvs_toolchains//toolchain:config.bzl", "cc_llvm_mingw_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

PREFIX = "x86_64-w64-mingw32"

VERSION = "18.1.4"

TOOLS = [
    "as",
    "llvm-ar",
    "c++",
    "clang++",
    "clang",
    "llvm-cov",
    "llvm-dlltool",
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
        "lib",
        "{}/lib".format(PREFIX),
        "{}/mingw/lib".format(PREFIX),
        "lib/clang/18/lib/windows",
    ],
)

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

# libraries, headers and executables.
filegroup(
    name = "compiler_pieces",
    srcs = glob([
        "bin/**",
        "{}/**".format(PREFIX),
        "lib/**",
        "include/**",
        "python/**",
    ]),
)

# files for executing compiler.
filegroup(
    name = "compiler_files",
    srcs = [":compiler_pieces"],
)

filegroup(
    name = "ar_files",
    srcs = [":compiler_pieces"],
)

filegroup(
    name = "linker_files",
    srcs = [":compiler_pieces"],
)

# collection of executables.
filegroup(
    name = "compiler_components",
    srcs = [":compiler_pieces"],
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
    abi_version = "",
    copts = [],
    gcc_tool = "clang",
    host_system_name = "windows_x86_64",
    include_path = [":include_path"],
    include_std = True,
    library_path = [":library_path"],
    linkopts = [],
    llvm_repo = "llvm_mingw_ucrt",
    llvm_version = VERSION,
    toolchain_bins = ":compiler_components",
    toolchain_identifier = "llvm_mingw",
    toolchain_prefix = "x86_64-w64-mingw32",
)
