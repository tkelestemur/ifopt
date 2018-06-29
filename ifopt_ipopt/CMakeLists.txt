# Copyright (c) 2017, Alexander W. Winkler, ETH Zurich. All rights reserved.
cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)
project(ifopt_ipopt VERSION 2.0.0)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../ifopt/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
find_package(ifopt 2.0.0 REQUIRED)
find_package(IPOPT 3.11.9 QUIET)


##############################################
## catkin specific configuration (optional) ##
##############################################
if (CATKIN_DEVEL_PREFIX) # set only when building with catkin, not pure cmake
find_package(catkin REQUIRED)
catkin_package(
  INCLUDE_DIRS include                               
  LIBRARIES    ${PROJECT_NAME}
  DEPENDS      ifopt
)
endif()


###########
## Build ##
###########
include(GNUInstallDirs) # for correcnt libraries locations across platforms
set(config_package_location share/ifopt/cmake)       # for .cmake find-scripts installs
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)          # so installed solver libraries link to IFOPT/SNOPT                                          
set(CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_PREFIX}/lib) # so installed solver libraries link to libifopt.so  

add_library(${PROJECT_NAME} SHARED 
    src/ipopt.cc
    src/ipopt_adapter.cc
)
target_include_directories(${PROJECT_NAME} 
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
    ${ifopt_INCLUDE_DIRS}
  PRIVATE
    ${IPOPT_INCLUDE_DIRS}
)
target_link_libraries(${PROJECT_NAME}
  PUBLIC 
    ${ifopt_LIBRARIES}
  PRIVATE
    ${IPOPT_LIBRARIES}
    ${IPOPT_LINK_FLAGS}
)
target_compile_definitions(${PROJECT_NAME}
  PRIVATE
    ${IPOPT_DEFINITIONS}
)

#############
## Install ##
#############
 # Copy library files to usr/local/lib/libifopt_ipopt.so
install(TARGETS ${PROJECT_NAME} EXPORT ${PROJECT_NAME}-targets
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)
# Copy header files to usr/local/include/ifopt/*
install(DIRECTORY include/ifopt/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ifopt
)
# install a *.cmake file in destination
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
#############
add_executable(${PROJECT_NAME}-example test/ex_test_ipopt.cc)
target_link_libraries(${PROJECT_NAME}-example 
  PRIVATE 
    ${PROJECT_NAME}
)
add_test(${PROJECT_NAME}-example ${PROJECT_NAME}-example)
