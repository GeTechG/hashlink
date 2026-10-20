set(MINIMP3_INCLUDE_DIR ${INCLUDES_BASE_DIR}/minimp3)
set(MIKKTSPACE_INCLUDE_DIR ${INCLUDES_BASE_DIR}/mikktspace)

add_library(fmt.hdll
    fmt.c
    sha1.c
    dxt.c
    mikkt.c
    ${MIKKTSPACE_INCLUDE_DIR}/mikktspace.c
)

if (WIN32)
    set(PNG_INCLUDE_DIRS ${INCLUDES_BASE_DIR}/png)
    target_sources(fmt.hdll PRIVATE
        ${INCLUDES_BASE_DIR}/png/png.c
        ${INCLUDES_BASE_DIR}/png/pngerror.c
        ${INCLUDES_BASE_DIR}/png/pngget.c
        ${INCLUDES_BASE_DIR}/png/pngmem.c
        ${INCLUDES_BASE_DIR}/png/pngpread.c
        ${INCLUDES_BASE_DIR}/png/pngread.c
        ${INCLUDES_BASE_DIR}/png/pngrio.c
        ${INCLUDES_BASE_DIR}/png/pngrtran.c
        ${INCLUDES_BASE_DIR}/png/pngrutil.c
        ${INCLUDES_BASE_DIR}/png/pngset.c
        ${INCLUDES_BASE_DIR}/png/pngtrans.c
        ${INCLUDES_BASE_DIR}/png/pngwio.c
        ${INCLUDES_BASE_DIR}/png/pngwrite.c
        ${INCLUDES_BASE_DIR}/png/pngwtran.c
        ${INCLUDES_BASE_DIR}/png/pngwutil.c)
endif()

if (WIN32)
    set(VORBIS_INCLUDE_DIR ${INCLUDES_BASE_DIR}/vorbis)

    target_sources(fmt.hdll PRIVATE
        ${INCLUDES_BASE_DIR}/vorbis/bitrate.c
        ${INCLUDES_BASE_DIR}/vorbis/bitwise.c
        ${INCLUDES_BASE_DIR}/vorbis/block.c
        ${INCLUDES_BASE_DIR}/vorbis/codebook.c
        ${INCLUDES_BASE_DIR}/vorbis/envelope.c
        ${INCLUDES_BASE_DIR}/vorbis/floor0.c
        ${INCLUDES_BASE_DIR}/vorbis/floor1.c
        ${INCLUDES_BASE_DIR}/vorbis/framing.c
        ${INCLUDES_BASE_DIR}/vorbis/info.c
        ${INCLUDES_BASE_DIR}/vorbis/lookup.c
        ${INCLUDES_BASE_DIR}/vorbis/lpc.c
        ${INCLUDES_BASE_DIR}/vorbis/lsp.c
        ${INCLUDES_BASE_DIR}/vorbis/mapping0.c
        ${INCLUDES_BASE_DIR}/vorbis/mdct.c
        ${INCLUDES_BASE_DIR}/vorbis/psy.c
        ${INCLUDES_BASE_DIR}/vorbis/registry.c
        ${INCLUDES_BASE_DIR}/vorbis/res0.c
        ${INCLUDES_BASE_DIR}/vorbis/sharedbook.c
        ${INCLUDES_BASE_DIR}/vorbis/smallft.c
        ${INCLUDES_BASE_DIR}/vorbis/synthesis.c
        ${INCLUDES_BASE_DIR}/vorbis/vorbisfile.c
        ${INCLUDES_BASE_DIR}/vorbis/window.c
    )
endif()

if(WIN32)
    set(ZLIB_INCLUDE_DIRS ${INCLUDES_BASE_DIR}/zlib)

    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(TurboJPEG_INCLUDE_DIRS ${INCLUDES_BASE_DIR}/turbojpeg ${INCLUDES_BASE_DIR}/turbojpeg/x64)
        find_library(TurboJPEG_LIBRARIES simd PATHS ${INCLUDES_BASE_DIR}/turbojpeg/x64)
    else()
        set(TurboJPEG_INCLUDE_DIRS ${INCLUDES_BASE_DIR}/turbojpeg ${INCLUDES_BASE_DIR}/turbojpeg/x86)
        find_library(TurboJPEG_LIBRARIES simd PATHS ${INCLUDES_BASE_DIR}/turbojpeg/x86)
    endif()

    target_sources(fmt.hdll PRIVATE
        ${INCLUDES_BASE_DIR}/turbojpeg/jaricom.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcapimin.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcapistd.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcarith.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jccoefct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jccolor.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcdctmgr.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jchuff.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcinit.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcmainct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcmarker.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcmaster.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcomapi.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcparam.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcphuff.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcprepct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jcsample.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jctrans.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdapimin.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdapistd.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdarith.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdatadst-tj.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdatadst.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdatasrc-tj.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdatasrc.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdcoefct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdcolor.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jddctmgr.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdhuff.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdinput.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdmainct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdmarker.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdmaster.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdmerge.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdphuff.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdpostct.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdsample.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jdtrans.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jerror.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jfdctflt.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jfdctfst.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jfdctint.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jidctflt.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jidctfst.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jidctint.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jidctred.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jmemmgr.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jmemnobs.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jquant1.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jquant2.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jsimd.c
        ${INCLUDES_BASE_DIR}/turbojpeg/jutils.c
        ${INCLUDES_BASE_DIR}/turbojpeg/transupp.c
        ${INCLUDES_BASE_DIR}/turbojpeg/turbojpeg.c
        ${INCLUDES_BASE_DIR}/zlib/adler32.c
        ${INCLUDES_BASE_DIR}/zlib/crc32.c
        ${INCLUDES_BASE_DIR}/zlib/deflate.c
        ${INCLUDES_BASE_DIR}/zlib/inffast.c
        ${INCLUDES_BASE_DIR}/zlib/inflate.c
        ${INCLUDES_BASE_DIR}/zlib/inftrees.c
        ${INCLUDES_BASE_DIR}/zlib/trees.c
        ${INCLUDES_BASE_DIR}/zlib/zutil.c
    )
elseif(DOWNLOAD_DEPENDENCIES)
    find_package(ZLIB REQUIRED)

    # the sub-builds get our generator but not its program, which might not be on PATH (Gradle's ninja)
    list(APPEND CMAKE_COMMON_DEP_ARGS -DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM})

	ExternalProject_Add(turbojpeg-project
        URL https://github.com/libjpeg-turbo/libjpeg-turbo/releases/download/3.1.1/libjpeg-turbo-3.1.1.tar.gz
        URL_HASH SHA256=aadc97ea91f6ef078b0ae3a62bba69e008d9a7db19b34e4ac973b19b71b4217c
        CMAKE_ARGS
            ${CMAKE_COMMON_DEP_ARGS}
            -DBUILD_SHARED_LIBS=OFF
            -DCMAKE_INSTALL_LIBDIR=lib
        # INSTALL_BYPRODUCTS in CMake 3.26+
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libturbojpeg.a
    )

    ExternalProject_Get_Property(turbojpeg-project INSTALL_DIR)

    add_library(turbojpeg STATIC IMPORTED)
    set_target_properties(turbojpeg PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libturbojpeg.a)

    set(TurboJPEG_INCLUDE_DIRS ${INSTALL_DIR}/${CMAKE_INSTALL_INCLUDEDIR})
    set(TurboJPEG_LIBRARIES turbojpeg)

    add_dependencies(turbojpeg turbojpeg-project)

    ExternalProject_Add(libpng
        URL https://github.com/pnggroup/libpng/archive/refs/tags/v1.6.50.tar.gz
        URL_HASH SHA256=71158e53cfdf2877bc99bcab33641d78df3f48e6e0daad030afe9cb8c031aa46
        CMAKE_ARGS
            ${CMAKE_COMMON_DEP_ARGS}
            -DPNG_SHARED=OFF
            -DPNG_TESTS=OFF
            -DPNG_TOOLS=OFF
            -DPNG_FRAMEWORK=OFF
            -DCMAKE_INSTALL_LIBDIR=lib
        # INSTALL_BYPRODUCTS in CMake 3.26+
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libpng.a
    )
    ExternalProject_Get_Property(libpng INSTALL_DIR)

    add_library(png STATIC IMPORTED)
    set_target_properties(png PROPERTIES IMPORTED_LOCATION ${INSTALL_DIR}/lib/libpng.a)

    set(PNG_INCLUDE_DIRS ${INSTALL_DIR}/${CMAKE_INSTALL_INCLUDEDIR})
    set(PNG_LIBRARIES png)

    add_dependencies(png libpng)

    ExternalProject_Add(libogg
        URL https://github.com/xiph/ogg/releases/download/v1.3.6/libogg-1.3.6.tar.gz
        URL_HASH SHA256=83e6704730683d004d20e21b8f7f55dcb3383cdf84c0daedf30bde175f774638
        CMAKE_ARGS
            ${CMAKE_COMMON_DEP_ARGS}
            -DCMAKE_INSTALL_LIBDIR=lib
        # INSTALL_BYPRODUCTS in CMake 3.26+
        BUILD_BYPRODUCTS <INSTALL_DIR>/lib/libogg.a
    )
    ExternalProject_Get_Property(libogg INSTALL_DIR)
    set(OGG_INSTALL_DIR ${INSTALL_DIR})

    set(OGG_LIBRARY ${OGG_INSTALL_DIR}/lib/libogg.a)
    set(OGG_INCLUDE_DIR ${OGG_INSTALL_DIR}/${CMAKE_INSTALL_INCLUDEDIR})

    ExternalProject_Add(libvorbis
        URL https://github.com/xiph/vorbis/releases/download/v1.3.7/libvorbis-1.3.7.tar.xz
        URL_HASH SHA256=b33cc4934322bcbf6efcbacf49e3ca01aadbea4114ec9589d1b1e9d20f72954b
        CMAKE_ARGS
            ${CMAKE_COMMON_DEP_ARGS}
            -DOGG_LIBRARY=${OGG_LIBRARY}
            -DOGG_INCLUDE_DIR=${OGG_INCLUDE_DIR}
            -DCMAKE_INSTALL_LIBDIR=lib
            -DCMAKE_POLICY_VERSION_MINIMUM=3.5 # https://github.com/xiph/vorbis/issues/113
        # INSTALL_BYPRODUCTS in CMake 3.26+
        BUILD_BYPRODUCTS
            <INSTALL_DIR>/lib/libvorbis.a
            <INSTALL_DIR>/lib/libvorbisfile.a
    )
    add_dependencies(libvorbis libogg)
    ExternalProject_Get_Property(libvorbis INSTALL_DIR)
    set(VORBIS_INSTALL_DIR ${INSTALL_DIR})

    add_library(ogg STATIC IMPORTED)
    set_target_properties(ogg PROPERTIES IMPORTED_LOCATION ${OGG_LIBRARY})

    add_library(vorbis STATIC IMPORTED)
    set_target_properties(vorbis PROPERTIES IMPORTED_LOCATION ${VORBIS_INSTALL_DIR}/lib/libvorbis.a)
    add_library(vorbisfile STATIC IMPORTED)
    set_target_properties(vorbisfile PROPERTIES IMPORTED_LOCATION ${VORBIS_INSTALL_DIR}/lib/libvorbisfile.a)

    set(VORBIS_INCLUDE_DIR ${VORBIS_INSTALL_DIR}/${CMAKE_INSTALL_INCLUDEDIR} ${OGG_INCLUDE_DIR})
    set(OGGVORBIS_LIBRARIES vorbisfile vorbis ogg)

    add_dependencies(vorbisfile libvorbis)
    add_dependencies(vorbis libvorbis)
    add_dependencies(ogg libogg)
else()
    find_package(ZLIB REQUIRED)
    find_package(PNG REQUIRED)

    find_package(TurboJPEG QUIET)
    if(NOT TurboJPEG_FOUND)
        pkg_check_modules(TurboJPEG REQUIRED libjpeg)
    endif()

    find_package(OggVorbis QUIET)
    if(NOT OGGVORBIS_FOUND)
        pkg_check_modules(OGGVORBIS REQUIRED vorbis vorbisenc vorbisfile)
    endif()
endif()

# Ogg Opus: libopus and opusfile are compiled into the library from pinned releases on every target,
# nothing needed on the system; libogg is the one Vorbis uses above
if(WITH_OPUS)
    if(CMAKE_VERSION VERSION_LESS 3.18)
        message(FATAL_ERROR "Opus in fmt.hdll needs CMake 3.18 or later (or -DWITH_OPUS=OFF)")
    endif()
    include(FetchContent)
    # only the sources are needed: a directory without CMakeLists.txt keeps their own builds out
    FetchContent_Declare(opus-project
        URL https://github.com/xiph/opus/releases/download/v1.5.2/opus-1.5.2.tar.gz
        URL_HASH SHA256=65c1d2f78b9f2fb20082c38cbe47c951ad5839345876e46941612ee87f9a7ce1
        SOURCE_SUBDIR no-cmake
    )
    FetchContent_Declare(opusfile-project
        URL https://github.com/xiph/opusfile/releases/download/v0.12/opusfile-0.12.tar.gz
        URL_HASH SHA256=118d8601c12dd6a44f52423e68ca9083cc9f2bfe72da7a8c1acb22a80ae3550b
        SOURCE_SUBDIR no-cmake
    )
    FetchContent_MakeAvailable(opus-project opusfile-project)

    # the file lists of opus' own Makefile.unix: float build, no SIMD or run-time CPU detection
    set(OPUS_SOURCES)
    foreach(mk_vars
            "celt_sources.mk;CELT_SOURCES"
            "silk_sources.mk;SILK_SOURCES;SILK_SOURCES_FLOAT"
            "opus_sources.mk;OPUS_SOURCES;OPUS_SOURCES_FLOAT")
        list(POP_FRONT mk_vars mk)
        file(READ ${opus-project_SOURCE_DIR}/${mk} mk_text)
        string(REPLACE "\\\n" " " mk_text "${mk_text}")
        string(REPLACE "\n" ";" mk_lines "${mk_text}")
        foreach(var ${mk_vars})
            set(found OFF)
            foreach(line ${mk_lines})
                if(line MATCHES "^${var} = (.*)$")
                    separate_arguments(names UNIX_COMMAND "${CMAKE_MATCH_1}")
                    list(TRANSFORM names PREPEND ${opus-project_SOURCE_DIR}/)
                    list(APPEND OPUS_SOURCES ${names})
                    set(found ON)
                endif()
            endforeach()
            if(NOT found)
                message(FATAL_ERROR "${var} not found in opus ${mk}")
            endif()
        endforeach()
    endforeach()

    set_source_files_properties(${OPUS_SOURCES}
        PROPERTIES
        COMPILE_DEFINITIONS "OPUS_BUILD;USE_ALLOCA;$<$<NOT:$<BOOL:${MSVC}>>:HAVE_LRINTF>"
        INCLUDE_DIRECTORIES "${opus-project_SOURCE_DIR}/celt;${opus-project_SOURCE_DIR}/silk;${opus-project_SOURCE_DIR}/silk/float"
    )

    target_sources(fmt.hdll PRIVATE
        ${OPUS_SOURCES}
        ${opusfile-project_SOURCE_DIR}/src/info.c
        ${opusfile-project_SOURCE_DIR}/src/internal.c
        ${opusfile-project_SOURCE_DIR}/src/opusfile.c
        ${opusfile-project_SOURCE_DIR}/src/stream.c
    )
    target_include_directories(fmt.hdll
        PRIVATE
        ${opus-project_SOURCE_DIR}/include
        ${opusfile-project_SOURCE_DIR}/include
    )
    target_compile_definitions(fmt.hdll PRIVATE FMT_OPUS)
    if(UNIX AND NOT APPLE)
        target_link_libraries(fmt.hdll m)
    endif()
endif()

set_as_hdll(fmt)

target_include_directories(fmt.hdll
    PRIVATE
    ${ZLIB_INCLUDE_DIRS}
    ${PNG_INCLUDE_DIRS}
    ${TurboJPEG_INCLUDE_DIRS}
    ${VORBIS_INCLUDE_DIR}
    ${MINIMP3_INCLUDE_DIR}
    ${MIKKTSPACE_INCLUDE_DIR}
)

target_link_libraries(fmt.hdll
    libhl
    ${ZLIB_LIBRARIES}
    ${PNG_LIBRARIES}
    ${TurboJPEG_LIBRARIES}
    ${OGGVORBIS_LIBRARIES}
)

install(
    TARGETS
        fmt.hdll
    DESTINATION ${HDLL_DESTINATION}
)
