
# 2020y-08m-24d. WorkSpace project.
################################################################################
include("${CMAKE_CURRENT_LIST_DIR}/001-symptoms.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/002-detect.cmake")
################################################################################

function(view_startup)
    if(NOT gDEBUG)
        return()
    endif()

    message(STATUS "[CMAKE_BUILD_TYPE] ........... '${CMAKE_BUILD_TYPE}'"        )
    message(STATUS "[CMAKE_GENERATOR] ............ '${CMAKE_GENERATOR}'"         )
    message(STATUS "[CMAKE_BINARY_DIR] ........... '${CMAKE_BINARY_DIR}'"        )
    message(STATUS "[CMAKE_CURRENT_SOURCE_DIR] ... '${CMAKE_CURRENT_SOURCE_DIR}'")

    message(STATUS "")

    message(STATUS "[gDIR_WORKSPACE] ........ ${gDIR_WORKSPACE}"     )
    message(STATUS "[gDIR_CMAKE_SCENARIO] ... ${gDIR_CMAKE_SCENARIO}")
    message(STATUS "[gDIR_SOURCES] .......... ${gDIR_SOURCES}"       )
    message(STATUS "[gNAME_PROJECT] ......... ${gNAME_PROJECT}"      )

endfunction()

macro(cmake_scenario name)
    set(gCMAKE_SCENARIO "${name}")
    detect_dir_sources()
    detect_dir_workspace()
    detect_dir_scripts()
    detect_dir_cmake_scenario("${name}")
    detect_name_project()
    view_startup()
    project(${gNAME_PROJECT} CXX)
    include("${gDIR_CMAKE_SCENARIO}/${gCMAKE_SCENARIO}.cmake")
endmacro()

################################################################################
################################################################################

if(NOT gDEBUG)
    set(gDEBUG "$ENV{eDEBUG}")
endif()

################################################################################
################################################################################
