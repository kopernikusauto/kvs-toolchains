# ------------------------------------------------------------------------------
#  Copyright (C) 2024 Kopernikus Automotive GmbH - All Rights Reserved
# ------------------------------------------------------------------------------

"""
"""

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain", "use_cpp_toolchain")
load("@rules_cc//cc:defs.bzl", "cc_binary")

def _gen_hex_impl(ctx):
    cc_toolchain = find_cpp_toolchain(ctx)
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    objcopy = cc_common.get_tool_for_action(
        feature_configuration = feature_configuration,
        action_name = ACTION_NAMES.objcopy_embed_data,
    )

    elf_src = ctx.file.elf
    output_file = ctx.actions.declare_file(ctx.label.name + ".hex")

    args = ctx.actions.args()
    args.add("-O")
    args.add("ihex")
    args.add(elf_src)
    args.add(output_file)

    ctx.actions.run(
        mnemonic = "GenerateHex",
        executable = objcopy,
        arguments = [args],
        outputs = [output_file],
        inputs = depset(
            direct = [elf_src],
            transitive = [
                cc_toolchain.all_files,
            ],
        ),
    )

    return [
        DefaultInfo(files = depset([output_file, elf_src])),
    ]

_gen_hex = rule(
    implementation = _gen_hex_impl,
    attrs = dict(
        elf = attr.label(allow_single_file = True),
        _cc_toolchain = attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    ),
    fragments = ["cpp"],
    toolchains = use_cpp_toolchain(),
)

def aurix_binary(name, **kw):
    cc_binary(
        name = name + ".elf",
        **kw
    )
    _gen_hex(
        name = name,
        elf = ":{}.elf".format(name),
    )
