# kvs-toolchains

The standard/default toolchains used by kvs but can be used by any Bazel project.

## Usage

In your `MODULE.bazel`:

```starlark
bazel_dep(name = "kvs_toolchains", version = "1.0.0")
# Until we have a private bazel registry, use the `git_override` function
# to tell Bazel how to actually find this module.
# See: https://bazel.build/versions/6.0.0/rules/lib/globals#git_override
git_override(
    module_name="kvs_toolchains",
    remote="git@github.com:kopernikusauto/kvs_toolchains.git",
    commit="<GIT COMMIT HASH>",
)

register_toolchains(
    "@kvs_toolchains//:tricore_gcc_linux",
    "@kvs_toolchains//:tricore_gcc_windows",
)
```

For targets that intend to use this it should "just work", and you can always use `@kvs_toolchains//platform/cpu:tricore` to contrain things.

For building binaries, you can use the `aurix_binary` macro:

```starlark
load("@kvs_toolchains//toolchain:tricore_gcc_utils.bzl", "aurix_binary")

aurix_binary(
    name = "my_firmware",
    srcs = [
        "source/main.cpp",
    ],
    linkopts = [
        "-lstdc++",
        "-T",
        "$(location :linker_script.ld)",
    ],
    target_compatible_with = ["@kvs_toolchains//platform/cpu:tricore"],
    deps = [
        ":linker_script.ld",
    ],
)
```

This macro works exactly the same as `cc_binary` with the addition being a genrule that will create the associate `.hex` file for your firmware.

In the example above, two targets would be created:

- `my_firmware`
- `my_firmware.elf`


## Cloudsmith

For archives hosted in our private package repository you'll have to provide your cloudsmith entitle token to the build.

The easiest way to do this is to add the following to your `~/.bazelrc` file:

```
build --action_env="CLOUDSMITH_TOKEN=XXX"
```

> Replace XXX with the token.
