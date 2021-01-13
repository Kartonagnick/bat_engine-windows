
# 2021y-01m-13d. WorkSpace project.
################################################################################
################################################################################

set(gDEBUG           "$ENV{eDEBUG}"          )
set(gDIR_PRODUCT     "$ENV{eDIR_PRODUCT}"    )
set(gEXPANDED_SUFFIX "$ENV{eEXPANDED_SUFFIX}")
set(gNAME_PROJECT    "$ENV{eNAME_PROJECT}"   )

################################################################################
################################################################################

macro(apply_path type_target path_output)
    set_target_properties(${gNAME_PROJECT} 
        PROPERTIES 
        "${type_target}"
        "${path_output}"
     )
endmacro()

macro(set_path_output type_target path_output)
    foreach(conf ${CMAKE_CONFIGURATION_TYPES})
        string(TOUPPER ${conf} CONFIG) 
        apply_path("${type_target}_${CONFIG}" "${path_output}")
    endforeach()
endmacro()

################################################################################
################################################################################

cmake_minimum_required(VERSION 3.1)
project(${gNAME_PROJECT} CXX)

get_filename_component(gDIR_SOURCE 
    "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE
)

file(GLOB_RECURSE sources 
  "${gDIR_SOURCE}/src/*.cpp"
  "${gDIR_SOURCE}/include/*.hpp"
)

################################################################################
################################################################################

add_executable(${gNAME_PROJECT} ${sources})

target_include_directories(
    ${gNAME_PROJECT} PUBLIC "${gDIR_SOURCE}/include"
)
get_filename_component(output 
    "${gDIR_PRODUCT}/${gEXPANDED_SUFFIX}" ABSOLUTE
)

if(gDEBUG)
    message(STATUS "output: ${output}")
endif()
set_path_output("RUNTIME_OUTPUT_DIRECTORY" "${output}")

# для dll необходимо указать:
#   RUNTIME_OUTPUT_DIRECTORY  --- расположение dll
#   LIBRARY_OUTPUT_DIRECTORY  --- расположение lib (расположение библиотеки импорта)

# для exe необходимо указать:
#   RUNTIME_OUTPUT_DIRECTORY  --- расположение exe

# для lib необходимо указать:
#   ARCHIVE_OUTPUT_DIRECTORY  --- расположение lib

# для hpp необходимо указать:
#   LIBRARY_OUTPUT_DIRECTORY  --- расположение include

################################################################################
################################################################################

