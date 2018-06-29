# ifopt-config.cmake
# ---------
#
# Locates the optimization interface ifopt.
# Copyright (c) 2018, Alexander W. Winkler. All rights reserved.
#
#
# Imported targets
# ^^^^^^^^^^^^^^^^
#
# This module defines the following IMPORTED targets:
#   ifopt::ifopt  - formulate a solver-independent optimization problem
#
# Example usage
# ^^^^^^^^^^^^^
#
#   find_package(ifopt REQUIRED)
#   add_executable(foo my_problem_formulation.cc)
#   target_link_libraries(foo PUBLIC ifopt::ifopt)
#
#
# Result variables
# ^^^^^^^^^^^^^^^^
#
# This module will set the following variables in your project. 
# These can be neccessary when building with catkin and not modern cmake
#   ifopt_INCLUDE_DIRS    - path to public include (.h) files
#   ifopt_LIBRARIES       - path to all libraries
#
#=============================================================================


# these are autogenerate by cmake
include("${CMAKE_CURRENT_LIST_DIR}/ifopt-targets.cmake")
get_target_property(ifopt_INCLUDE_DIRS ifopt::ifopt INTERFACE_INCLUDE_DIRECTORIES)
get_property(ifopt_LIBRARIES TARGET ifopt::ifopt PROPERTY LOCATION)

