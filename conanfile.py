from conan import ConanFile

class ProjectDeps(ConanFile):
    name = "myproject"
    version = "0.1"
    settings = "os", "arch", "compiler", "build_type"
    requires = (
        "gtest/cci.20210126",
        "boost/1.85.0",
    )
    generators = "CMakeDeps", "CMakeToolchain"
