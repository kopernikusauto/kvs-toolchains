"""
This BUILD file is used to provide the content of a tricore_gcc archive
"""

load("@kvs_toolchains//toolchain/config:tricore_gcc.bzl", "cc_tricore_gcc_toolchain_config")
load("@rules_cc//cc:defs.bzl", "cc_toolchain")

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

PREFIX = "tricore-elf"

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
        "lib/gcc/tricore-elf/11.3.1/include",
        "lib/gcc/tricore-elf/11.3.1/include-fixed",
        "tricore-elf/include",
        "tricore-elf/include/c++/11.3.1",
        "tricore-elf/include/c++/11.3.1/tr1",
        "tricore-elf/include/c++/11.3.1/tricore-elf",
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
    include_path = [":include_path"],
    library_path = [":library_path"],
    sysroot = "{}".format(PREFIX),
    toolchain_bins = ":toolchain_bins",
)
