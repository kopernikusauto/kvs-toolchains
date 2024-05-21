import os
from io import StringIO

from conan import ConanFile
from conan.tools.cmake import CMake, cmake_layout


class TestPackageConan(ConanFile):
    settings = "os", "arch", "compiler", "build_type"
    generators = "CMakeToolchain", "VirtualBuildEnv"

    def build_requirements(self):
        self.tool_requires(self.tested_reference_str)

    def layout(self):
        cmake_layout(self)

    def build(self):
        toolchain = "x86_64-centos7-linux-gnu"
        self.run(f"{toolchain}-g++ -static-libstdc++ -static-libgcc -l:libstdc++.a -l:libstdc++exp.a -l:libstdc++fs.a -lc-2.17 -lm-2.17 -lrt-2.17 ../../test_package.cpp -o howdy")

    def test(self):
        toolchain = "x86_64-centos7-linux-gnu"
        self.run(f"{toolchain}-gcc --version")
        stdout = StringIO()
        self.run("./howdy", stdout=stdout)
        assert "Hello Conan!" in stdout.getvalue()
