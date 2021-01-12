
# 2020y-08m-24d. WorkSpace project.
# 2020y-12m-21d. WorkSpace project.
# 2021y-01m-12d. WorkSpace project.
################################################################################
################################################################################

function(detect_dir_sources)
    set(gDIR_SOURCES "$ENV{eDIR_SOURCES}")
    if(NOT gDIR_SOURCES)
        find_symptoms(gDIR_SOURCES 
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

function(detect_dir_scripts)
    set(gDIR_BAT_SCRIPTS "$ENV{eDIR_BAT_SCRIPTS}")

    if(gDIR_BAT_SCRIPTS AND IS_DIRECTORY "${gDIR_BAT_SCRIPTS}")
        get_filename_component(gDIR_BAT_SCRIPTS "${gDIR_BAT_SCRIPTS}" ABSOLUTE)
    elseif(gDIR_WORKSPACE AND IS_DIRECTORY "${gDIR_WORKSPACE}/scripts")
        get_filename_component(gDIR_BAT_SCRIPTS "${gDIR_WORKSPACE}/scripts" ABSOLUTE)
    endif()    

    if(gDIR_BAT_SCRIPTS)
        set(gDIR_BAT_SCRIPTS "${gDIR_BAT_SCRIPTS}" PARENT_SCOPE)
        return()
    endif()
endfunction()

macro(check_scenario dir name)
    if(IS_DIRECTORY "${dir}/${name}")
        get_filename_component(gDIR_CMAKE_SCENARIO "${dir}/${name}" ABSOLUTE)

    elseif(IS_DIRECTORY "${dir}/cmake-${name}")
        get_filename_component(gDIR_CMAKE_SCENARIO "${dir}/cmake-${name}" ABSOLUTE)

    elseif(IS_DIRECTORY "${dir}/cmake/${name}")
        get_filename_component(gDIR_CMAKE_SCENARIO "${dir}/cmake/${name}" ABSOLUTE)
    endif()

    if(gDIR_CMAKE_SCENARIO)
        set(gDIR_CMAKE_SCENARIO "${gDIR_CMAKE_SCENARIO}" PARENT_SCOPE)
        return()
    endif()
endmacro()

function(detect_dir_cmake_scenario name)
    if(gDIR_BAT_SCRIPTS)
        check_scenario("${gDIR_BAT_SCRIPTS}/.." "${name}")
    endif()

    check_scenario("${CMAKE_CURRENT_LIST_DIR}" "${name}")
    check_scenario("${gDIR_SOURCES}"    "${name}")
    check_scenario("${gDIR_SOURCES}/.." "${name}")

    message(FATAL_ERROR "not found: scenario '${name}'")
endfunction()

function(detect_name_project)
    set(gNAME_PROJECT "$ENV{eNAME_PROJECT}")
    if(NOT gNAME_PROJECT)
        get_filename_component(gNAME_PROJECT "${gDIR_SOURCES}" NAME)
    endif()
    set(gNAME_PROJECT "${gNAME_PROJECT}" PARENT_SCOPE)
endfunction()

################################################################################
