# -----------------------------------------------------------------------------
# CONTRIB FRAMEWORK
#
# Based on CMake ExternalProjects, this repository offers functionality
# to configure, build, and install software dependencies that can be used
# by other projects.
#
# It has been developed in course of the open source
# research software BALL (Biochemical ALgorithms Library).
#
#
# Copyright 2016, the BALL team (http://www.ball-project.org)
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL ANY OF THE AUTHORS OR THE CONTRIBUTING
# INSTITUTIONS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# -----------------------------------------------------------------------------


IF(MSVC)
	SET(GLEW_BUILD_COMMAND "")
	SET(GLEW_INSTALL_COMMAND "")

	SET(GLEW_ARCH_DIR "x64")
	IF(${CONTRIB_ADDRESSMODEL} EQUAL 32)
		SET(GLEW_ARCH_DIR "Win32")
	ENDIF()
ELSE()
	SET(GLEW_BUILD_COMMAND env GLEW_DEST=${CONTRIB_INSTALL_PREFIX} ${MAKE_COMMAND} STRIP=strip)
	SET(GLEW_INSTALL_COMMAND env GLEW_DEST=${CONTRIB_INSTALL_PREFIX} ${MAKE_INSTALL_COMMAND})
ENDIF()


ExternalProject_Add(${PACKAGE}

	PREFIX ${PROJECT_BINARY_DIR}
	DOWNLOAD_COMMAND ""
	BUILD_IN_SOURCE ${CUSTOM_BUILD_IN_SOURCE}

	LOG_DOWNLOAD ${CUSTOM_LOG_DOWNLOAD}
	LOG_UPDATE ${CUSTOM_LOG_UPDATE}
	LOG_CONFIGURE ${CUSTOM_LOG_CONFIGURE}
	LOG_BUILD ${CUSTOM_LOG_BUILD}
	LOG_INSTALL ${CUSTOM_LOG_INSTALL}

	CONFIGURE_COMMAND ""
	BUILD_COMMAND "${GLEW_BUILD_COMMAND}"
	INSTALL_COMMAND "${GLEW_INSTALL_COMMAND}"
)

IF(MSVC)
	# Add custom install step for Windows
	ExternalProject_Add_Step(${PACKAGE} custom_install

		LOG 1
		DEPENDEES build

		WORKING_DIRECTORY "${CONTRIB_BINARY_SRC}"
		COMMAND ${CMAKE_COMMAND} -E copy_directory ${PACKAGE}/include/GL ${CONTRIB_INSTALL_INC}/GL
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/bin/Release/${GLEW_ARCH_DIR}/glew32.dll ${CONTRIB_INSTALL_BIN}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/lib/Release/${GLEW_ARCH_DIR}/glew32.lib ${CONTRIB_INSTALL_LIB}
		COMMAND ${CMAKE_COMMAND} -E copy ${PACKAGE}/lib/Release/${GLEW_ARCH_DIR}/glew32s.lib ${CONTRIB_INSTALL_LIB}

		DEPENDERS install
	)
ENDIF()
