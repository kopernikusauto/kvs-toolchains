import os
from conan import ConanFile
from conan.tools.files import get, copy
from conan.errors import ConanInvalidConfiguration

PREFIX = "tricore-elf"

ARCHIVES = {
    "Linux": ("https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/tricore-elf-gcc-11.3.1.tar.xz",
              "de02d8befcbac36f3bc9f1b06ec0e2059b3b2d6411b2259152cac05eb5d4267c"),
    "Windows": ("https://github.com/kopernikusauto/kvs-toolchains/releases/download/2024.01.25/tricore-elf-gcc-11.3.1.zip",
                "6980edcd0eedf3f8727a232ed99e56dd16f6484df20f221c7ab03e59991328e2"),
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

    def package(self):
        copy(self, pattern="*", src=self.build_folder, dst=self.package_folder, keep_path=True)

    def package_info(self):
        toolchain = PREFIX
        self.cpp_info.bindirs.append(os.path.join(self.package_folder, PREFIX, "bin"))
        if self.settings.os == "Windows":
            self.cpp_info.bindirs.append(os.path.join(self.package_folder, PREFIX, "aurix-flasher"))

        # 'c', 'cpp', 'asm', 'ld', 'ar'
        self.conf_info.define("tools.build:compiler_executables", {
            "c":   f"{toolchain}-gcc",
            "cpp": f"{toolchain}-g++",
            "ld": f"{toolchain}-ld",
            "ar": f"{toolchain}-ar",
            "asm": f"{toolchain}-as"
        })
