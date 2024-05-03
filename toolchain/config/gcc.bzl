# ------------------------------------------------------------------------------
#  Copyright (C) 2024 Kopernikus Automotive GmbH - All Rights Reserved
# ------------------------------------------------------------------------------

"""
GCC
"""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_compile_actions = [
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.lto_backend,
    ACTION_NAMES.clif_match,
]

cpp_compile_actions = [
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
]

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

PREFIX = "x86_64-centos7-linux-gnu"

def _gcc_impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = "bin/{}-g++".format(PREFIX),
        ),
        tool_path(
            name = "g++",
            path = "bin/{}-g++".format(PREFIX),
        ),
        tool_path(
            name = "ld",
            path = "bin/{}-ld".format(PREFIX),
        ),
        tool_path(
            name = "ld.gold",
            path = "bin/{}-ld.gold".format(PREFIX),
        ),
        tool_path(
            name = "ldd",
            path = "bin/{}-ldd".format(PREFIX),
        ),
        tool_path(
            name = "ar",
            path = "bin/{}-ar".format(PREFIX),
        ),
        tool_path(
            name = "cpp",
            path = "bin/{}-cpp".format(PREFIX),
        ),
        tool_path(
            name = "gcov",
            path = "bin/{}-gcov".format(PREFIX),
        ),
        tool_path(
            name = "gcov-dump",
            path = "bin/{}-gcov-dump".format(PREFIX),
        ),
        tool_path(
            name = "gcov-tool",
            path = "bin/{}-gcov-tool".format(PREFIX),
        ),
        tool_path(
            name = "nm",
            path = "bin/{}-nm".format(PREFIX),
        ),
        tool_path(
            name = "objdump",
            path = "bin/{}-objdump".format(PREFIX),
        ),
        tool_path(
            name = "strip",
            path = "bin/{}-strip".format(PREFIX),
        ),
        tool_path(
            name = "size",
            path = "bin/{}-size".format(PREFIX),
        ),
        tool_path(
            name = "readelf",
            path = "bin/{}-readelf".format(PREFIX),
        ),
        tool_path(
            name = "gfortran",
            path = "bin/{}-gfortran".format(PREFIX),
        ),
    ]

    # system_include_directories = []
    # for inc in ctx.files.include_path:
    #     system_include_directories += ["-isystem", inc.path]

    toolchain_compiler_flags = feature(
        name = "compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = [
                    ACTION_NAMES.c_compile,
                ],
                flag_groups = [
                    flag_group(flags = ["-xc", "-std=c17"]),
                ],
            ),
            flag_set(
                actions = cpp_compile_actions,
                flag_groups = [
                    flag_group(flags = [
                        "-xc++",
                        "-std=c++20",
                    ]),
                ],
            ),
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(flags = [
                        "-fno-canonical-system-headers",
                        "-no-canonical-prefixes",
                        "-Wall",
                        "-Wextra",
                        "-Wpedantic",
                        "-Wno-error=deprecated",
                        "-fdiagnostics-color=auto",
                        #"-nostdinc",
                    ]),
                    #flag_group(flags = system_include_directories),
                ],
            ),
        ],
    )

    toolchain_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            #"-static",
                            "-l:libstdc++.a",
                        ],
                    ),
                    flag_group(flags = ["-L{}".format(lib.path) for lib in ctx.files.library_path]),
                    flag_group(flags = ["-fuse-ld=gold"]),
                ]),
            ),
        ],
    )

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "gcc_linux_x86_64",
        target_system_name = PREFIX,
        compiler = "gcc",
        tool_paths = tool_paths,
        target_cpu = "x86_64",
        target_libc = "glibc",
        cxx_builtin_include_directories = [include.path for include in ctx.files.include_path],
        features = [
            toolchain_compiler_flags,
            toolchain_linker_flags,
        ],
        builtin_sysroot = ctx.file.sysroot.path,
    )

cc_gcc_toolchain_config = rule(
    implementation = _gcc_impl,
    attrs = {
        "toolchain_bins": attr.label(mandatory = True, allow_files = True),
        "include_path": attr.label_list(default = [], allow_files = True),
        "library_path": attr.label_list(default = [], allow_files = True),
        "sysroot": attr.label(mandatory = False, default = None, allow_single_file = True),
    },
    provides = [CcToolchainConfigInfo],
)
