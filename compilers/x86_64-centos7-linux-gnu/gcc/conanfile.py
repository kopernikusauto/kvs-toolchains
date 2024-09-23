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

    def build(self):
        get(self,
            "https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/gcc_13.2.0_x86_64-centos7-linux-gnu.tar.xz",
            sha256="8c456531d4c24d35e20b491fe3b29c22ac61ff6b38e437e282f55ad9c18f1b6b")

    def package(self):
        toolchain = PREFIX
        dirs_to_copy = [toolchain, "bin", "include", "lib", "libexec", "etc", "share"]
        for dir_name in dirs_to_copy:
            copy(self, pattern=f"{toolchain}/{dir_name}/*", src=self.build_folder, dst=self.package_folder, keep_path=True)
        copy(self, "LICENSE", src=self.build_folder, dst=os.path.join(self.package_folder, "licenses"), keep_path=False)

    def package_info(self):
        toolchain = PREFIX
        _tc_path = os.path.join(self.package_folder, PREFIX, "bin", f"{PREFIX}-")
        self.cpp_info.bindirs.append(os.path.join(self.package_folder, toolchain, "bin"))

        self.buildenv_info.define("X86_64_GCC_CC", f"{_tc_path}-gcc")
        self.buildenv_info.define("X86_64_GCC_CXX", f"{_tc_path}-g++")
        self.buildenv_info.define("X86_64_GCC_LD", f"{_tc_path}-ld")
        self.buildenv_info.define("X86_64_GCC_AR", f"{_tc_path}-ar")
        self.buildenv_info.define("X86_64_GCC_AS", f"{_tc_path}-as")
        self.buildenv_info.define("X86_64_GCC_OBJCOPY", f"{_tc_path}-objcopy")
        self.buildenv_info.define("X86_64_GCC_OBJDUMP", f"{_tc_path}-objdump")
        self.buildenv_info.define("X86_64_GCC_SIZE", f"{_tc_path}-size")
        self.buildenv_info.define("X86_64_GCC_GCOV", f"{_tc_path}-gcov")

        # self.conf_info.define("tools.build:compiler_executables", {
        #     "c":   f"{toolchain}-gcc",
        #     "cpp": f"{toolchain}-g++",
        #     "asm": f"{toolchain}-as"
        # })
