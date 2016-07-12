# -----------------------------------------------------------------------------
#   BALL - Biochemical ALgorithms Library
#   A C++ framework for molecular modeling and structural bioinformatics.
# -----------------------------------------------------------------------------
#
# Copyright (C) 1996-2012, the BALL Team:
#  - Andreas Hildebrandt
#  - Oliver Kohlbacher
#  - Hans-Peter Lenhof
#  - Eberhard Karls University, Tuebingen
#  - Saarland University, Saarbrücken
#  - others
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library (BALL/source/LICENSE); if not, write
#  to the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
#  Boston, MA  02111-1307  USA
#
# -----------------------------------------------------------------------------
# $Maintainer: Philipp Thiel $
# $Authors: Philipp Thiel $
# -----------------------------------------------------------------------------


PROJECT("BALL_contrib")

SET(BALL_CONTRIB_VERSION_MAJOR "1")
SET(BALL_CONTRIB_VERSION_MINOR "5")
SET(BALL_CONTRIB_VERSION_PATCH "0")
SET(BALL_CONTRIB_VERSION "${BALL_CONTRIB_VERSION_MAJOR}.${BALL_CONTRIB_VERSION_MINOR}.${BALL_CONTRIB_VERSION_PATCH}")


# -----------------------------------------------------------------------------
# CMake settings
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12 FATAL_ERROR)

# Path to contrib-specific CMake modules
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
LIST(APPEND CMAKE_MODULE_PATH "${PROJECT_BINARY_DIR}/cmake")

# ExternalProjects package
INCLUDE(ExternalProject)

# Load contrib-specific macros and messages
INCLUDE(BALLContribMacros)

# Load contrib-specific macros and messages
INCLUDE(BALLContribConfig)

# Check availability of Python
INCLUDE(BALLContribPython)


# -----------------------------------------------------------------------------
# Select and check packages to be installed
#

INCLUDE(BALLContribPackages)

# Print help message if HELP is set
OPTION(HELP "Show help for ball_contrib installation." FALSE)
IF(HELP)
	MSG_HELP()
	RETURN(0)
ENDIF()

# Optional variable set by the user to select the packages to be build.
# If not set by the user, all packages are selected.
SET(PACKAGES "" CACHE STRING "Variable to control which packages are build.")
IF(PACKAGES STREQUAL "")
	SET(PACKAGES "${CONTRIB_PACKAGES}")
ENDIF()

# Check if selected packages are valid.
# Macro populates BUILD_PACKAGES variable
SET(BUILD_PACKAGES "")
EVALUATE_SELECTION()

# Iterate valid packages, configure them, and add them to DOWNLOAD_ARCHIVES
SET(DOWNLOAD_ARCHIVES "")
FOREACH(PACKAGE_NAME ${BUILD_PACKAGES})

	BALL_CONTRIB_MACRO_ext_pro_init()

	INCLUDE("${CONTRIB_LIBRARY_PATH}/${PACKAGE_NAME}.cmake" RESULT_VARIABLE SUCCESS)

	IF(NOT ${SUCCESS} STREQUAL "NOTFOUND")
		LIST(APPEND DOWNLOAD_ARCHIVES "${PACKAGE_NAME}")
	ENDIF()

ENDFOREACH()

# Option to skip MD5 checks of downloaded archives.
OPTION(SKIP_MD5_CHECKS "Skip download verification. For development purpose only." FALSE)

# Finally, download archives
FETCH_PACKAGE_ARCHIVES()

# Configure version file
CONFIGURE_FILE(cmake/ball_contrib_version.cmake.in "${CONTRIB_CMAKE_MODULES}/ball_contrib_version.cmake")







