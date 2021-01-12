
# 2020y-08m-24d. WorkSpace project.
# 2020y-12m-21d. WorkSpace project.
################################################################################
################################################################################

function(detect_dir_sources)
    set(gDIR_SOURCES "$ENV{eDIR_SOURCES}")
    if(NOT gDIR_SOURCES)
        find_symptoms(
            gDIR_SOURCES
            "${CMAKE_CURRENT_SOURCE_DIR}" 
            "include;deploy" 
            "src;source;sources;project.root"
        )
    endif()
    if(NOT gDIR_SOURCES)
        message(FATAL_ERROR "not found: 'gDIR_SOURCES'")
    endif()
    file(TO_CMAKE_PATH "${gDIR_SOURCES}" gDIR_SOURCES)
    set(gDIR_SOURCES "${gDIR_SOURCES}" PARENT_SCOPE)
endfunction()

function(detect_dir_workspace)
    if(IS_DIRECTORY "${gDIR_SOURCES}")
        set(start "${gDIR_SOURCES}")
    else()
        set(start "${CMAKE_CURRENT_LIST_DIR}")
    endif()

    find_symptoms(gDIR_WORKSPACE 
        "${start}" "3rd_party" "programs" "scripts"
    )
    set(gDIR_WORKSPACE "${gDIR_WORKSPACE}" PARENT_SCOPE)
endfunction()


function(detect_dir_cmake_scenario name)
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${name}.cmake")
        get_filename_component(gDIR_CMAKE_SCENARIO 
            "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE
        )

    elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/cmake-${name}.cmake")
        get_filename_component(gDIR_CMAKE_SCENARIO 
            "${CMAKE_CURRENT_LIST_DIR}/cmake" ABSOLUTE
        )

    elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/cmake/${name}.cmake")
        get_filename_component(gDIR_CMAKE_SCENARIO 
            "${CMAKE_CURRENT_LIST_DIR}/cmake" ABSOLUTE
        )

    else()
        if(NOT gDIR_WORKSPACE)
            message(FATAL_ERROR "not found: 'gDIR_WORKSPACE'")
        endif()

        if(IS_DIRECTORY "${gDIR_WORKSPACE}/scripts/cmake-${name}")
            get_filename_component(gDIR_CMAKE_SCENARIO 
                "${gDIR_WORKSPACE}/scripts/cmake-${name}" ABSOLUTE
            )

        elseif(IS_DIRECTORY "${gDIR_WORKSPACE}/scripts/cmake/${name}")
            get_filename_component(gDIR_CMAKE_SCENARIO 
                "${gDIR_WORKSPACE}/scripts/cmake/${name}" ABSOLUTE
            )

        else()
            message(FATAL_ERROR "not found: 'gDIR_WORKSPACE/scripts/cmake-${name}'")
        endif()
    endif()
    set(gDIR_CMAKE_SCENARIO "${gDIR_CMAKE_SCENARIO}" PARENT_SCOPE)
endfunction()

function(detect_name_project)
    set(gNAME_PROJECT "$ENV{eNAME_PROJECT}")
    if(NOT gNAME_PROJECT)
        get_filename_component(gNAME_PROJECT "${gDIR_SOURCES}" NAME)
    endif()
    set(gNAME_PROJECT "${gNAME_PROJECT}" PARENT_SCOPE)
endfunction()

################################################################################

