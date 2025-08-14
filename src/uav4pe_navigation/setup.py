#!/usr/bin/env python3

from distutils.core import setup
from catkin_pkg.python_setup import generate_distutils_setup

args = generate_distutils_setup(
    packages=['uav4pe_navigation'],
    scripts=['scripts/uav4pe_navigate'],
    package_dir={'': 'src'}
)

setup(**args)