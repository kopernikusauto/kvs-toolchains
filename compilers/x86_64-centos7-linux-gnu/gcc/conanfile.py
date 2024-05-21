import os
from conan import ConanFile
from conan.tools.files import get, copy
from conan.errors import ConanInvalidConfiguration

PREFIX = "x86_64-centos7-linux-gnu"

class Gcc13Toolchain(ConanFile):
    name = "x86_64-centos7-linux-gnu-gcc"
    version = "13.2.0"
    description = "Conan package for GCC 13.2.0 built with glibc-2.17 using crosstool-ng"
    license = "GPL-3.0-only"
    package_type="application"
    settings = "os", "arch"

    def validate(self):
        if self.settings.arch != "x86_64" or self.settings.os != "Linux":
            raise ConanInvalidConfiguration(f"This toolchain is not compatible with {self.settings.os}-{self.settings.arch}. "
                                            "It can only run on Linux-x86_64.")

        if self.settings_target.os != "Linux" or self.settings_target.arch != "x86_64":
            raise ConanInvalidConfiguration(f"This toolchain only supports building for Linux-x86_64. "
                                        f"{self.settings_target.os}-{self.settings_target.arch} is not supported.")

        if self.settings_target.compiler != "gcc":
            raise ConanInvalidConfiguration(f"The compiler is set to '{self.settings_target.compiler}', but this "
                                            "toolchain only supports building with gcc.")

    def build(self):
        get(self,
            "https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/gcc_13.2.0_x86_64-centos7-linux-gnu.tar.xz",
            sha256="8c456531d4c24d35e20b491fe3b29c22ac61ff6b38e437e282f55ad9c18f1b6b")

    def package_id(self):
        self.info.settings_target = self.settings_target
        # We only want the ``arch`` setting
        self.info.settings_target.rm_safe("os")
        self.info.settings_target.rm_safe("compiler")
        self.info.settings_target.rm_safe("build_type")

    def package(self):
        toolchain = PREFIX
        dirs_to_copy = [toolchain, "bin", "include", "lib", "libexec"]
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
