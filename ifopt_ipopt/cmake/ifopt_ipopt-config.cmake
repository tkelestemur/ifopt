# ifopt_ipopt-config.cmake
# ---------
#
# Locates the solver interface ifopt_ipopt.
# Copyright (c) 2018, Alexander W. Winkler. All rights reserved.
#
#
# Imported targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following IMPORTED targets:
#   ifopt::ifopt_ipopt  - interface to NLP solver ifopt
#
# Example usage
# ^^^^^^^^^^^^^
#
#   find_package(ifopt_ipopt REQUIRED)
#   add_executable(foo my_problem_to_solve_with_IPOPT.cc)
#   target_link_libraries(foo PUBLIC ifopt::ifopt_ipopt)
#
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project. 
# These can be neccessary when building with catkin and not modern cmake
#   ifopt_ipopt_INCLUDE_DIRS    - path to public include (.h) files
#   ifopt_ipopt_LIBRARIES       - path to all libraries
#
#=============================================================================
include(CMakeFindDependencyMacro)
find_dependency(ifopt)

# these are autogenerate by cmake
include("${CMAKE_CURRENT_LIST_DIR}/ifopt_ipopt-targets.cmake")
get_target_property(ifopt_ipopt_INCLUDE_DIRS ifopt::ifopt_ipopt INTERFACE_INCLUDE_DIRECTORIES)
get_property(ifopt_ipopt_LIBRARIES TARGET ifopt::ifopt_ipopt PROPERTY LOCATION)

