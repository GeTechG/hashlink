# HarfBuzz is built into the library from the amalgamated source of a pinned release:
# no FreeType, ICU, GLib or platform shaper, nothing needed on the system.
if(CMAKE_VERSION VERSION_LESS 3.18)
    message(FATAL_ERROR "harfbuzz.hdll needs CMake 3.18 or later (or -DWITH_HARFBUZZ=OFF)")
endif()
include(FetchContent)
FetchContent_Declare(harfbuzz-project
    URL https://github.com/harfbuzz/harfbuzz/releases/download/14.6.0/harfbuzz-14.6.0.tar.xz
    URL_HASH SHA256=d07a007327277708a2a73ae437887cdbaf282937f6d03ca5467723e9099af586
    # only the sources are needed: a directory without CMakeLists.txt keeps HarfBuzz's own build out
    SOURCE_SUBDIR no-cmake
)
FetchContent_MakeAvailable(harfbuzz-project)

add_library(harfbuzz.hdll
    harfbuzz.c
    ${harfbuzz-project_SOURCE_DIR}/src/harfbuzz.cc
)

set_as_hdll(harfbuzz)

target_include_directories(harfbuzz.hdll
    PRIVATE
    ${harfbuzz-project_SOURCE_DIR}/src
)

# the flags of HarfBuzz's own build: no C++ exceptions or RTTI, pthread mutexes outside Windows
set_source_files_properties(${harfbuzz-project_SOURCE_DIR}/src/harfbuzz.cc
    PROPERTIES
    COMPILE_OPTIONS "$<IF:$<BOOL:${MSVC}>,/bigobj;/wd4244;/wd4267,-fno-exceptions;-fno-rtti>"
    COMPILE_DEFINITIONS "$<$<NOT:$<BOOL:${WIN32}>>:HAVE_PTHREAD>"
)

target_compile_features(harfbuzz.hdll PRIVATE cxx_std_11)

target_link_libraries(harfbuzz.hdll
    libhl
)

install(
    TARGETS
        harfbuzz.hdll
    DESTINATION ${HDLL_DESTINATION}
)
