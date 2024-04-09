"""
This BUILD file provides the content of the aurix flasher archive
"""

package(default_visibility = ["//visibility:public"])

# export the executable files to make them available for direct use.
exports_files(glob(
    ["**"],
    exclude_directories = 0,
))

filegroup(
    name = "flasher",
    srcs = ["AurixFlasher.exe"],
)

# libraries, headers and executables.
filegroup(
    name = "all",
    srcs = glob(["**"]),
)
