# fmt
CPMAddPackage(
  GITHUB_REPOSITORY fmtlib/fmt
  GIT_SHALLOW ON
  GIT_TAG 11.2.0
  OPTIONS "FMT_HEADER_ONLY ON" 
  SYSTEM YES
  EXCLUDE_FROM_ALL YES
)

target_link_libraries(
  ${PROJECT_NAME} 
  PUBLIC
  fmt::fmt-header-only
)

# spdlog
include(CPMPackageManager)
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(SPDLOG_WCHAR_SUPPORT "SPDLOG_WCHAR_SUPPORT ON")
  set(SPDLOG_WCHAR_FILENAME "SPDLOG_WCHAR_FILENAMES ON")
else()
  set(SPDLOG_WCHAR_SUPPORT "SPDLOG_WCHAR_SUPPORT OFF")
  set(SPDLOG_WCHAR_FILENAME "SPDLOG_WCHAR_FILENAMES OFF")
endif()

CPMAddPackage(
  GITHUB_REPOSITORY gabime/spdlog 
  GIT_SHALLOW ON
  VERSION 1.15.3 
  OPTIONS
    "SPDLOG_FMT_EXTERNAL_HO ON"
    "SPDLOG_ENABLE_PCH ON"
    "SPDLOG_BUILD_PIC ON"
    "SPDLOG_NO_EXCEPTIONS ON"
    "${SPDLOG_WCHAR_SUPPORT}"
    "${SPDLOG_WCHAR_FILENAME}"
  SYSTEM YES
  EXCLUDE_FROM_ALL YES
)

target_link_libraries(
  ${PROJECT_NAME}
  PUBLIC
  fmt::fmt-header-only # need fmt header-only because we enable SPDLOG_FMT_EXTERNAL_HO
  spdlog::spdlog
)

# tinyobjloader
CPMAddPackage(
  GITHUB_REPOSITORY tinyobjloader/tinyobjloader
  GIT_SHALLOW ON
  VERSION 2.0.0rc13
  SYSTEM YES
  EXCLUDE_FROM_ALL YES
)

target_link_libraries(
  ${PROJECT_NAME}
  PUBLIC
  tinyobjloader
)

# slang shader
set(SLANG_VERSION "2025.24.3")

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
  set(Slang_URL https://github.com/shader-slang/slang/releases/download/v${SLANG_VERSION}/slang-${SLANG_VERSION}-windows-x86_64.tar.gz)
  set(Slang_SHA_256 fa90e674e76f0268fa2f4987ae2d9e88e781ac34290c521ecd1257c7f3c1f964)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(Slang_URL https://github.com/shader-slang/slang/releases/download/v${SLANG_VERSION}/slang-${SLANG_VERSION}-linux-x86_64.tar.gz)
  set(Slang_SHA_256 7e86e0f123c35ba2d6802c46d916100d9f324aa2da53f5179e87bbfd16cdff63)
else()
  message(FATAL_ERROR "Unsupported platform")
endif()

if(Slang_URL AND Slang_SHA_256)
  CPMAddPackage(
    NAME slang_download
    VERSION ${SLANG_VERSION}
    URL ${Slang_URL}
    URL_HASH SHA256=${Slang_SHA_256}
    DOWNLOAD_ONLY
  )
endif()

if (slang_download_ADDED)
  list(APPEND CMAKE_PREFIX_PATH "${slang_download_SOURCE_DIR}")
  find_package(Slang REQUIRED)
else()
  message(FATAL_ERROR "Unable to add slang from \"${Slang_URL}\"")
endif()

target_link_libraries(      
  ${PROJECT_NAME}
  PUBLIC
    Slang::slang
)
