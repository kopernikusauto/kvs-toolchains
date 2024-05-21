import os
from conan import ConanFile
from conan.tools.files import get, copy
from conan.errors import ConanInvalidConfiguration

PREFIX = "tricore-elf"

ARCHIVES = {
    "Linux": ("https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/tricore-elf-gcc-11.3.1.tar.xz",
              "de02d8befcbac36f3bc9f1b06ec0e2059b3b2d6411b2259152cac05eb5d4267c"),
    "Windows": ("https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/llvm-mingw-20240417-ucrt-x86_64.zip",
                "afa69ac40f08721658bbd6826b633f3b54579d7ae4cab1f624cc6e2efd05bf0e"),
}

class TricoreGccToolchain(ConanFile):
    name = "tricore-gcc"
    version = "11.3.1"
    description = "Conan package for GCC 11.3.1"
    license = "GPL-3.0-only"
    package_type="application"
    settings = "os", "arch"

    def validate(self):
        if self.settings.arch != "x86_64":
            raise ConanInvalidConfiguration(f"This toolchain is not compatible with arch: {self.settings.arch}.")
        if self.settings.os != "Linux" and self.settings.os != "Windows":
            raise ConanInvalidConfiguration(f"This toolchain is only available on Windows and Linux")

    def _sha(self):
        return ARCHIVES[str(self.settings.os)][1]

    def _url(self):
        return ARCHIVES[str(self.settings.os)][0]

    def build(self):
        url, sha = ARCHIVES[str(self.settings.os)]
        get(self, url, sha256=sha)

    def package_id(self):
        self.info.settings_target = self.settings_target
        # We only want the ``arch`` setting
        self.info.settings_target.rm_safe("compiler")
        self.info.settings_target.rm_safe("build_type")

    def package(self):
        toolchain = PREFIX
        dirs_to_copy = ["bin", "include", "lib", "libexec", "mcs-elf", "share", PREFIX]
        for dir_name in dirs_to_copy:
            copy(self, pattern=f"{toolchain}/{dir_name}/*", src=self.build_folder, dst=self.package_folder, keep_path=True)
        copy(self, "LICENSE", src=self.build_folder, dst=os.path.join(self.package_folder, "licenses"), keep_path=False)

    def package_info(self):
        toolchain = PREFIX
        self.cpp_info.bindirs.append(os.path.join(self.package_folder, toolchain, "bin"))
        #set(CMAKE_C_COMPILER ${GCC13_ROOT}/bin/${_prefix}-gcc)
        #set(CMAKE_CXX_COMPILER ${GCC13_ROOT}/bin/${_prefix}-g++)
        #set(CMAKE_ASM_COMPILER ${GCC13_ROOT}/bin/${_prefix}-gcc)
        #set(CMAKE_OBJDUMP ${GCC13_ROOT}/bin/${_prefix}-objdump)
        #set(CMAKE_OBJCOPY ${GCC13_ROOT}/bin/${_prefix}-objcopy)
        #set(CMAKE_SIZE ${GCC13_ROOT}/bin/${_prefix}-size)
        #set(GCOV ${GCC13_ROOT}/bin/${_prefix}-gcov CACHE STRING "Path to GCov")

        self.conf_info.define("tools.build:compiler_executables", {
            "c":   f"{toolchain}-gcc",
            "cpp": f"{toolchain}-g++",
            "asm": f"{toolchain}-as"
        })
