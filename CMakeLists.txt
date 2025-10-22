cmake_minimum_required(VERSION 3.27)

project("raylib_dummy" VERSION 0.0.1 DESCRIPTION "raylib_dummy")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if (CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
  string(JOIN " " CMAKE_CXX_FLAGS 
  )
  string(JOIN " " CMAKE_EXE_LINKER_FLAGS
    "-sUSE_GLFW=3"
    "-sGL_ENABLE_GET_PROC_ADDRESS=1"
    "-gsource-map"
    "-sEXIT_RUNTIME"
    "-sASYNCIFY"
    "-sALLOW_MEMORY_GROWTH"
    "-sMEMORY_GROWTH_GEOMETRIC_STEP=0.5"
    "-sEXPORTED_RUNTIME_METHODS=stringToNewUTF8"
  )
endif()


# Download Raylib
include(cmake/CMakePackageManager.cmake)
CPMAddPackage(
      GITHUB_REPOSITORY raysan5/raylib
      GIT_SHALLOW ON
      GIT_TAG c1ab645ca298a2801097931d1079b10ff7eb9df8
      SYSTEM YES
      EXCLUDE_FROM_ALL YES)


# Include and Link Raylib in the game
add_executable(${PROJECT_NAME})

target_sources(
    ${PROJECT_NAME}
    PRIVATE
    main.cpp
)

target_link_libraries(${PROJECT_NAME} PRIVATE raylib)
set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")

# if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
#   add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
#     COMMAND ${CMAKE_COMMAND} -E copy_if_different  
#     $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}>
#     $<TARGET_FILE_DIR:${PROJECT_NAME}>
#     COMMAND_EXPAND_LISTS
#   )
# endif()