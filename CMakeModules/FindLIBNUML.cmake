# Locate libnuml
# This module defines:
# LIBNUML_INCLUDE_DIR, where to find the headers
#
# LIBNUML_LIBRARY, LIBNUML_LIBRARY_DEBUG
# LIBNUML_FOUND, LIBNUML_LIBRARY_NAME


if(UNIX OR CYGWIN OR MINGW)
  set(LIBNUML_LIBRARY_NAME numl)
else()
  set(LIBNUML_LIBRARY_NAME libnuml)
endif()

if (NOT LIBNUML_SHARED)
  set(LIBNUML_LIBRARY_NAME "${LIBNUML_LIBRARY_NAME}-static")
endif()

message (STATUS "Looking for ${LIBNUML_LIBRARY_NAME}")

find_package(${LIBNUML_LIBRARY_NAME} CONFIG QUIET)

if (${LIBNUML_LIBRARY_NAME}_FOUND)

  get_target_property(LIBNUML_LIBRARY ${LIBNUML_LIBRARY_NAME} LOCATION)
  get_filename_component(LIB_PATH ${LIBNUML_LIBRARY} DIRECTORY)
  file(TO_CMAKE_PATH ${LIB_PATH}/../include LIBNUML_INCLUDE_DIR)  
  get_filename_component (LIBNUML_INCLUDE_DIR ${LIBNUML_INCLUDE_DIR} REALPATH)
  get_target_property(LIBNUML_VERSION ${LIBNUML_LIBRARY_NAME} VERSION)

else()

find_path(LIBNUML_INCLUDE_DIR numl/NMBase.h
    PATHS $ENV{LIBNUML_DIR}/include
          $ENV{LIBNUML_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}/include
          ~/Library/Frameworks
          /Library/Frameworks
          /sw/include        # Fink
          /opt/local/include # MacPorts
          /opt/csw/include   # Blastwave
          /opt/include
          /usr/freeware/include
    NO_DEFAULT_PATH)

if (NOT LIBNUML_INCLUDE_DIR)
    message(FATAL_ERROR "libnuml include dir not found not found!")
endif (NOT LIBNUML_INCLUDE_DIR)

if (NOT LIBNUML_INCLUDE_DIR)
    find_path(LIBNUML_INCLUDE_DIR numl/NMBase.h)
endif (NOT LIBNUML_INCLUDE_DIR)

find_library(LIBNUML_LIBRARY 
    NAMES numl-static 
          numl
          libnuml-static 
          libnuml
    PATHS $ENV{LIBNUML_DIR}/lib
          $ENV{LIBNUML_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}
          ${LIBSEDML_DEPENDENCY_DIR}/lib
          ~/Library/Frameworks
          /Library/Frameworks
          /sw/lib        # Fink
          /opt/local/lib # MacPorts
          /opt/csw/lib   # Blastwave
          /opt/lib
          /usr/freeware/lib64
    NO_DEFAULT_PATH)

if (NOT LIBNUML_LIBRARY)
    find_library(LIBNUML_LIBRARY 
        NAMES numl-static 
              numl)
endif (NOT LIBNUML_LIBRARY)

if (NOT LIBNUML_LIBRARY)
    message(FATAL_ERROR "LIBNUML library not found!")
endif (NOT LIBNUML_LIBRARY)

  add_library(${LIBNUML_LIBRARY_NAME} UNKNOWN IMPORTED)
  set_target_properties(${LIBNUML_LIBRARY_NAME} PROPERTIES IMPORTED_LOCATION ${LIBNUML_LIBRARY})

endif()



set(LIBNUML_FOUND "NO")
if(LIBNUML_LIBRARY)
    if (LIBNUML_INCLUDE_DIR)
        SET(LIBNUML_FOUND "YES")
    endif(LIBNUML_INCLUDE_DIR)
endif(LIBNUML_LIBRARY)

# handle the QUIETLY and REQUIRED arguments and set LIBNUML_FOUND to TRUE if 
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBNUML DEFAULT_MSG LIBNUML_LIBRARY_NAME LIBNUML_LIBRARY LIBNUML_INCLUDE_DIR)

mark_as_advanced(LIBNUML_INCLUDE_DIR LIBNUML_LIBRARY LIBNUML_LIBRARY_NAME)
