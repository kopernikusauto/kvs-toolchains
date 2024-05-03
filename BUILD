"""
Our top level toolchains are defined and provided here.
Use them in your module with the `register_toolchain` function.
"""

toolchain(
    name = "tricore_gcc_linux",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "//platform/cpu:tricore",
        "@platforms//os:none",
    ],
    toolchain = "@tricore_gcc_linux_x86_64//:cc_toolchain",
    toolchain_type = "@rules_cc//cc:toolchain_type",
)

toolchain(
    name = "tricore_gcc_windows",
    exec_compatible_with = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "//platform/cpu:tricore",
        "@platforms//os:none",
    ],
    toolchain = "@tricore_gcc_windows_x86_64//:cc_toolchain",
    toolchain_type = "@rules_cc//cc:toolchain_type",
)

toolchain(
    name = "llvm_mingw_ucrt",
    exec_compatible_with = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:windows",
    ],
    toolchain = "@llvm_mingw_ucrt//:cc_toolchain",
    toolchain_type = "@rules_cc//cc:toolchain_type",
)

toolchain(
    name = "gcc_linux_x86_64",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = "@gcc_linux_x86_64//:cc_toolchain",
    toolchain_type = "@rules_cc//cc:toolchain_type",
)
