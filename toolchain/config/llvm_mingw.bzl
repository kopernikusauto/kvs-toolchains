# ------------------------------------------------------------------------------
#  Copyright (C) 2024 Kopernikus Automotive GmbH - All Rights Reserved
# ------------------------------------------------------------------------------

"""
LLVM Mingw64 UCRT (Windows)
"""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@rules_cc//cc:cc_toolchain_config_lib.bzl",
    "artifact_name_pattern",
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

def _llvm_mingw_impl(ctx):
    tool_paths = [
        # NEW
        tool_path(
            name = "gcc",
            path = "bin/clang.exe",
        ),
        tool_path(
            name = "clang",
            path = "bin/clang.exe",
        ),
        tool_path(
            name = "ld",
            path = "bin/ld.lld.exe",
        ),
        tool_path(
            name = "ar",
            path = "bin/llvm-ar.exe",
        ),
        tool_path(
            name = "cpp",
            path = "bin/c++.exe",
        ),
        tool_path(
            name = "gcov",
            path = "bin/llvm-cov.exe",
        ),
        tool_path(
            name = "nm",
            path = "bin/llvm-nm.exe",
        ),
        tool_path(
            name = "objdump",
            path = "bin/llvm-objdump.exe",
        ),
        tool_path(
            name = "strip",
            path = "bin/llvm-strip.exe",
        ),
    ]

    toolchain_compiler_flags = feature(
        name = "compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(flags = [
                        "-no-canonical-prefixes",
                        "-Wall",
                        "-Wextra",
                        "-Wpedantic",
                        "-Wno-error=deprecated",
                        "-fdiagnostics-color=auto",
                    ]),
                    flag_group(flags = ["-isystem {}".format(include.path) for include in ctx.files.include_path]),
                ],
            ),
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
                            "-stdlib=libc++",
                            "-static",
                            "-lc++",
                        ],
                    ),
                    flag_group(flags = ["-L{}".format(lib.path) for lib in ctx.files.library_path]),
                ]),
            ),
        ],
    )

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        toolchain_identifier = "llvm_mingw",
        target_system_name = "x86_64-w64-mingw32",
        compiler = "llvm_mingw_ucrt",
        tool_paths = tool_paths,
        target_cpu = "x86_64",
        target_libc = "unknown",
        features = [
            toolchain_compiler_flags,
            toolchain_linker_flags,
        ],
        artifact_name_patterns = [
            artifact_name_pattern(
                category_name = "executable",
                prefix = "",
                extension = ".exe",
            ),
            artifact_name_pattern(
                category_name = "dynamic_library",
                prefix = "",
                extension = ".dll",
            ),
        ],
    )

cc_llvm_mingw_toolchain_config = rule(
    implementation = _llvm_mingw_impl,
    attrs = {
        "llvm_repo": attr.string(default = ""),
        "toolchain_bins": attr.label(mandatory = True, allow_files = True),
        "include_path": attr.label_list(default = [], allow_files = True),
        "library_path": attr.label_list(default = [], allow_files = True),
    },
    provides = [CcToolchainConfigInfo],
)
