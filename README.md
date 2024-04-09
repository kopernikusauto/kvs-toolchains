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
    remote="git@github.com:kopernikusauto/kvs_toolchains.git"
)

register_toolchains(
    "@kvs_toolchains//:tricore_gcc_linux",
    "@kvs_toolchains//:tricore_gcc_windows",
)
```

## Cloudsmith

For archives hosted in our private package repository you'll have to provide your cloudsmith entitle token to the build.

The easiest way to do this is to add the following to your `~/.bazelrc` file:

```
build --action_env="CLOUDSMITH_TOKEN=XXX"
```

> Replace XXX with the token.
