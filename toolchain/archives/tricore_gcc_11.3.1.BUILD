"""
This BUILD file is used to provide the content of a tricore_gcc archive
"""

load("@kvs_toolchains//toolchain:config.bzl", "cc_tricore_gcc_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

PREFIX = "tricore-elf"

VERSION = "11.3.1"

TOOLS = [
    "as",
    "ar",
    "c++",
    "cpp",
    "g++",
    "gcc",
    "gcov",
    "gcov-dump",
    "gcov-tool",
    "gprof",
    "ld",
    "nm",
    "objcopy",
    "objdump",
    "readelf",
    "strip",
    "size",
]

# executables.
[
    filegroup(
        name = tool,
        srcs = ["bin/{}-{}".format(PREFIX, tool)],
    )
    for tool in TOOLS
]

filegroup(
    name = "include_path",
    srcs = [
        "lib/gcc/{}/{}/include".format(PREFIX, VERSION),
        "lib/gcc/{}/{}/include-fixed".format(PREFIX, VERSION),
        "{}/include".format(PREFIX),
        "{}/include/c++/{}".format(PREFIX, VERSION),
        "{}/include/c++/{}/{}".format(PREFIX, VERSION, PREFIX),
    ],
)

# Just the components to add to the library path.
filegroup(
    name = "library_path",
    srcs = [
        PREFIX,
        "{}/lib".format(PREFIX),
    ] + glob(["lib/gcc/{}/*".format(PREFIX)]),
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
        "libexec/**",
        "{}/**".format(PREFIX),
        "lib/**",
        "lib/gcc/{}/**".format(PREFIX),
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

cc_tricore_gcc_toolchain_config(
    name = "cc_toolchain_config",
    abi_version = "",
    copts = [],
    gcc_repo = "tricore_gcc_linux_x86_64",
    gcc_tool = "gcc",
    gcc_version = "11.3.1",
    host_system_name = "linux_x86_64",
    include_path = [":include_path"],
    include_std = True,
    library_path = [":library_path"],
    linkopts = [],
    toolchain_bins = ":compiler_components",
    toolchain_identifier = "tricore_gcc",
    toolchain_prefix = "tricore-elf",
)
