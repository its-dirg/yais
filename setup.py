from distutils.core import setup

setup(
    name="yais",
    version="0.1",
    description='Yet antoher install script ',
    author = "Hans, Hörberg",
    author_email = "hans.horberg@umu.se",
    license="Apache 2.0",
    packages=[],
    package_dir = {"": "src"},
    classifiers = ["Development Status :: 4 - Beta",
        "License :: OSI Approved :: Apache Software License",
        "Topic :: Software Development :: Libraries :: Python Modules"],
    install_requires = [],
    scripts=["script/setupLinux.sh", "script/setupIdp.py"],
    zip_safe=False,
)