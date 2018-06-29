# Copyright (c) 2017, Alexander W. Winkler, ETH Zurich. All rights reserved.
cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(ifopt VERSION 2.0.0)

include(GNUInstallDirs) # for correct libraries locations across platforms
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
find_package(Eigen3 REQUIRED)


##############################################
## catkin specific configuration (optional) ##
##############################################
if (CATKIN_DEVEL_PREFIX) # set only when building with catkin, not pure cmake
find_package(catkin REQUIRED)
catkin_package(
  INCLUDE_DIRS include
               ${EIGEN3_INCLUDE_DIR}                                
  LIBRARIES    ${PROJECT_NAME}
)
endif()


###########
## Build ##
###########
add_library(${PROJECT_NAME} SHARED
    src/problem.cc
    src/composite.cc
    src/leaves.cc
)
target_include_directories(${PROJECT_NAME} 
  PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/test>
    $<INSTALL_INTERFACE:include>
    ${EIGEN3_INCLUDE_DIR}
)
# better specify features you need, not c++ version
target_compile_features(${PROJECT_NAME} 
  PUBLIC 
    cxx_range_for 
    cxx_auto_type
)

#############
## Install ##
#############
# store in export-set for find-script generation
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}-targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
# Copy header files to usr/local/include/ifopt/*
install(
  DIRECTORY include/ifopt/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ifopt
)
install(
  FILES test/test_vars_constr_cost.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ifopt
)
# Generate the find scripts
set(config_package_location share/ifopt/cmake)
install(EXPORT ${PROJECT_NAME}-targets
  FILE ${PROJECT_NAME}-targets.cmake
  NAMESPACE ifopt::
  DESTINATION ${config_package_location}
)
# generate the file IfoptConfigVersion.cmake
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake"
  VERSION ${ifopt_VERSION}
  COMPATIBILITY SameMajorVersion
)
# install the two files in a place where cmake looks for them so can call
install(
  FILES 
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/${PROJECT_NAME}-config.cmake"   # self-written
    "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config-version.cmake" # generated
  DESTINATION ${config_package_location}
)



#############
## Testing ##
############
find_package(GTest QUIET)
if (TARGET GTest::GTest) # only build when modern target exists
  add_executable(${PROJECT_NAME}-test 
    test/composite_test.cc
    test/problem_test.cc
  )  
  target_link_libraries(${PROJECT_NAME}-test  
    PRIVATE 
      ${PROJECT_NAME} 
      GTest::GTest GTest::Main
  )    
  add_test(${PROJECT_NAME}-test  ${PROJECT_NAME}-test)
endif()
