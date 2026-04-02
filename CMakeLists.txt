cmake_minimum_required(VERSION 3.27)

project("raylib_dummy" VERSION 0.0.1 DESCRIPTION "raylib_dummy")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE INTERNAL "")

if (CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
  string(JOIN " " CMAKE_CXX_FLAGS 
    "-g"
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

# # Download Raylib
include(cmake/CMakePackageManager.cmake)
# CPMAddPackage(
#       GITHUB_REPOSITORY raysan5/raylib
#       GIT_SHALLOW ON
#       GIT_TAG c1ab645ca298a2801097931d1079b10ff7eb9df8
#       SYSTEM YES
#       OPTIONS
#       raylib_USE_STATIC_LIBS YES
#       EXCLUDE_FROM_ALL YES)

# Download SDL3
CPMAddPackage(
      GITHUB_REPOSITORY libsdl-org/SDL
      GIT_SHALLOW ON
      GIT_TAG 683181b47cfabd293e3ea409f838915b8297a4fd
      SYSTEM YES
      OPTIONS
      SDL_SHARED NO
      SDL_STATIC YES
      EXCLUDE_FROM_ALL YES)

CPMAddPackage(
      GITHUB_REPOSITORY libsdl-org/SDL_image
      GIT_SHALLOW ON
      GIT_TAG ad58ecfc27a1bd09e510ceff8bbbdb1094806476
      SYSTEM YES
      OPTIONS
      SDL_SHARED NO
      SDL_STATIC YES
      EXCLUDE_FROM_ALL YES)

# Include and Link Raylib in the game
add_executable(${PROJECT_NAME})

target_sources(
    ${PROJECT_NAME}
    PRIVATE
    main.cpp
)

set_property(TARGET ${PROJECT_NAME} PROPERTY C_STANDARD 23)
target_compile_features(${PROJECT_NAME} INTERFACE c_std_23)

set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 23)
target_compile_features(${PROJECT_NAME} INTERFACE cxx_std_23)

target_link_libraries(${PROJECT_NAME} PRIVATE SDL3::SDL3 SDL3_image::SDL3_image )

if (CMAKE_SYSTEM_NAME STREQUAL "Emscripten")
  set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".html")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy  
    -t $<TARGET_RUNTIME_DLLS:${PROJECT_NAME}>
    $<TARGET_FILE_DIR:${PROJECT_NAME}>
    COMMAND_EXPAND_LISTS
  )
endif()


