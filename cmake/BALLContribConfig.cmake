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

# Binary CMake module folder
SET(CONTRIB_CMAKE_MODULES "${PROJECT_BINARY_DIR}/cmake")
FILE(MAKE_DIRECTORY "${CONTRIB_CMAKE_MODULES}")

# Folder to store the downloaded tarballs
SET(CONTRIB_ARCHIVES_PATH "${PROJECT_BINARY_DIR}/archives")
FILE(MAKE_DIRECTORY "${CONTRIB_ARCHIVES_PATH}")

# Install directory
SET(CONTRIB_INSTALL_BASE "${PROJECT_BINARY_DIR}/install")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_BASE}")

# Install directory: binaries
SET(CONTRIB_INSTALL_BIN "${CONTRIB_INSTALL_BASE}/bin")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_BIN}")

# Install directory: libraries
SET(CONTRIB_INSTALL_LIB "${CONTRIB_INSTALL_BASE}/lib")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_LIB}")

# Install directory: dynamic libraries on Windows
IF(MSVC)
	SET(CONTRIB_INSTALL_DLL "${CONTRIB_INSTALL_BASE}/dlls")
	FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_DLL}")
ENDIF()

# Install directory: headers
SET(CONTRIB_INSTALL_INC "${CONTRIB_INSTALL_BASE}/include")
FILE(MAKE_DIRECTORY "${CONTRIB_INSTALL_INC}")

# Path that contains extracted sources (usually <build_dir>/src)
SET(CONTRIB_BINARY_SRC "${PROJECT_BINARY_DIR}/src")
FILE(MAKE_DIRECTORY "${CONTRIB_BINARY_SRC}")

# Path that contains the contrib libraries
# Directory already exists (git)
SET(CONTRIB_LIBRARY_PATH "${PROJECT_SOURCE_DIR}/libraries")

# Optional path to directory that contains ball_contrib package tarballs.
# Amongst others, this variable can be used to provide self-contained ball_contrib packages.
SET(ARCHIVES_PATH "" CACHE PATH "Optional path to the folder containing the contrib archives.")

# Set URL for archive download
SET(ARCHIVES_URL "http://build-archive.informatik.uni-tuebingen.de/ball/contrib/v${BALL_CONTRIB_VERSION}/archives")
SET(ARCHIVES_URL_FALLBACK "http://sourceforge.net/projects/ballproject/files/contrib/v${BALL_CONTRIB_VERSION}/archives")
SET_CONTRIB_ARCHIVES_URL()

# Logging options
SET(CUSTOM_LOG_DOWNLOAD 1 CACHE STRING  "Write logfile for download step instead of printing (default 1).")
SET(CUSTOM_LOG_UPDATE 1 CACHE STRING  "Write logfile for update/patch step instead of printing (default 1).")
SET(CUSTOM_LOG_CONFIGURE 1 CACHE STRING  "Write logfile for configure step instead of printing (default 1).")
SET(CUSTOM_LOG_BUILD 1 CACHE STRING  "Write logfile for build step instead of printing (default 1).")
SET(CUSTOM_LOG_INSTALL 1 CACHE STRING  "Write logfile for install step instead of printing (default 1).")

# Option to specify number of threads used by make
SET(THREADS 1 CACHE STRING "Number of threads used by make steps (default 1).")

# Set contrib build type
IF(CMAKE_BUILD_TYPE STREQUAL "Debug")
	SET(CONTRIB_BUILD_TYPE "Debug")
ELSEIF(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
	SET(CONTRIB_BUILD_TYPE "RelWithDebInfo")
ELSE()
	SET(CONTRIB_BUILD_TYPE "Release")
ENDIF()

# Determine whether this is a 32 or 64 bit build
IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
	SET(CONTRIB_ADDRESSMODEL 64)
	SET(MSBUILD "msbuild" "/m:${THREADS}" "/p:Platform=x64"   "/p:Configuration=${CONTRIB_BUILD_TYPE}")
ELSE()
	SET(CONTRIB_ADDRESSMODEL 32)
	SET(MSBUILD "msbuild" "/m:${THREADS}" "/p:Platform=win32" "/p:Configuration=${CONTRIB_BUILD_TYPE}")
ENDIF()

# Set appropriate build commands for non-windows systems
IF(NOT MSVC)
	SET(MAKE_COMMAND "make" "-j${THREADS}")
	SET(MAKE_INSTALL_COMMAND "make" "install")
ENDIF()


