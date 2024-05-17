# ------------------------------------------------------------------------------
#  Copyright (C) 2024 Kopernikus Automotive GmbH - All Rights Reserved
# ------------------------------------------------------------------------------

"""
Tricore GCC (Windows / Linux) toolchain configuration
"""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "flag_group",
    "flag_set",
    "tool",
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

PREFIX = "tricore-elf"

def _tricore_gcc_impl(ctx):
    tool_paths = [
        tool_path(
            name = "gcc",
            path = "bin/{}-gcc".format(PREFIX),
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
            name = "ar",
            path = "bin/{}-ar".format(PREFIX),
        ),
        tool_path(
            name = "as",
            path = "bin/{}-as".format(PREFIX),
        ),
        tool_path(
            name = "elfedit",
            path = "bin/{}-elfedit".format(PREFIX),
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
            name = "objcopy",
            path = "bin/{}-objcopy".format(PREFIX),
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
            name = "gprof",
            path = "bin/{}-gprof".format(PREFIX),
        ),
    ]

    # Why was this not working?
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
                        "-fmessage-length=0",
                        "-fno-common",
                        "-fstrict-volatile-bitfields",
                        "-fdata-sections",
                        "-ffunction-sections",
                        "-fno-eliminate-unused-debug-symbols",
                        "-mtc162",  # TODO: We need to generalize this if we want to support more than the tc377tx!
                        "-D__AURIX__",
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
                            "-Wl,--gc-sections",
                            "-mtc162",  # TODO: We need to generalize this if we want to support more than the tc377tx!
                            "-lstdc++",
                        ],
                    ),
                    flag_group(flags = ["-L{}".format(lib.path) for lib in ctx.files.library_path]),
                ]),
            ),
        ],
    )

    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = False)

    objcopy_embed_flags_feature = feature(
        name = "objcopy_embed_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ["objcopy_embed_data"],
                flag_groups = [
                    #flag_group(flags = ["-I", "binary"]),
                ],
            ),
        ],
    )

    objcopy_action = action_config(
        action_name = ACTION_NAMES.objcopy_embed_data,
        tools = [
            tool(
                path = "bin/{}-objcopy".format(PREFIX),
            ),
        ],
    )

    action_configs = [objcopy_action]
    gcc = tool(path = "bin/{}-gcc".format(PREFIX))
    for action_name in all_compile_actions + all_link_actions:
        action_configs.append(
            action_config(
                action_name = action_name,
                tools = [
                    gcc,
                ],
            ),
        )

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "tricore_gcc",
        target_system_name = PREFIX,
        compiler = "gcc",
        tool_paths = tool_paths,
        target_cpu = "tricore-elf",
        target_libc = "unknown",
        cxx_builtin_include_directories = [include.path for include in ctx.files.include_path],
        action_configs = action_configs,
        features = [
            toolchain_compiler_flags,
            toolchain_linker_flags,
            supports_dynamic_linker_feature,
            objcopy_embed_flags_feature,
        ],
        builtin_sysroot = ctx.file.sysroot.path,
    )

cc_tricore_gcc_toolchain_config = rule(
    implementation = _tricore_gcc_impl,
    attrs = {
        "toolchain_bins": attr.label(mandatory = True, allow_files = True),
        "include_path": attr.label_list(default = [], allow_files = True),
        "library_path": attr.label_list(default = [], allow_files = True),
        "sysroot": attr.label(mandatory = False, default = None, allow_single_file = True),
    },
    provides = [CcToolchainConfigInfo],
)
