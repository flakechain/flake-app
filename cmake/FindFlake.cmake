#------------------------------------------------------------------------------
# CMake helper for the majority of the flake-app modules.
#
# This module defines
#     XSF_LIBRARIES, the libraries needed to use FlakeChain.
#     FLAKE_FOUND, If false, do not try to use FlakeChain.
#
# The documentation for flake-app is hosted at https://flakechain.github.io
#
# (c) 2018 flake-app contributors.
# (c) 2014-2016 cpp-ethereum contributors.
#------------------------------------------------------------------------------

set(LIBS common;blocks;cryptonote_basic;cryptonote_core;
		cryptonote_protocol;daemonizer;mnemonics;epee;lmdb;device;
		blockchain_db;ringct;wallet;cncrypto;easylogging;version;checkpoints)

set(XSF_INCLUDE_DIRS "${CPP_FLAKE_DIR}")

# if the project is a subset of main cpp-ethereum project
# use same pattern for variables as Boost uses

foreach (l ${LIBS})

	string(TOUPPER ${l} L)

	find_library(XSF_${L}_LIBRARY
			NAMES ${l}
			PATHS ${CMAKE_LIBRARY_PATH}
			PATH_SUFFIXES "/src/${l}" "/src/" "/external/db_drivers/lib${l}" "/lib" "/src/crypto" "/contrib/epee/src" "/external/easylogging++/"
			NO_DEFAULT_PATH
			)

	set(XSF_${L}_LIBRARIES ${XSF_${L}_LIBRARY})

	message(STATUS FindFlake " XSF_${L}_LIBRARIES ${XSF_${L}_LIBRARY}")

	add_library(${l} STATIC IMPORTED)
	set_property(TARGET ${l} PROPERTY IMPORTED_LOCATION ${XSF_${L}_LIBRARIES})

endforeach()


if (EXISTS ${FLAKE_BUILD_DIR}/src/ringct/libringct_basic.a)
	message(STATUS FindFlake " found libringct_basic.a")
	add_library(ringct_basic STATIC IMPORTED)
	set_property(TARGET ringct_basic
			PROPERTY IMPORTED_LOCATION ${FLAKE_BUILD_DIR}/src/ringct/libringct_basic.a)
endif()

message(STATUS ${FLAKE_SOURCE_DIR}/build)

# include flake headers
include_directories(
		${FLAKE_SOURCE_DIR}/src
		${FLAKE_SOURCE_DIR}/external
		${FLAKE_SOURCE_DIR}/build
		${FLAKE_SOURCE_DIR}/external/easylogging++
		${FLAKE_SOURCE_DIR}/contrib/epee/include
		${FLAKE_SOURCE_DIR}/external/db_drivers/liblmdb)
