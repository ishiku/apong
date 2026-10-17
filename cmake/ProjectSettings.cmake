set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(_game_exclusive_sanitizers "")
foreach(_san ADDRESS MEMORY THREAD)
    if(GAME_ENABLE_SANITIZER_${_san})
        list(APPEND _game_exclusive_sanitizers ${_san})
    endif()
endforeach()
 
list(LENGTH _game_exclusive_sanitizers _game_exclusive_count)
if(_game_exclusive_count GREATER 1)
    list(JOIN _game_exclusive_sanitizers ", " _game_exclusive_text)
    message(FATAL_ERROR
        "Incompatible sanitizers are enabled at the same time: ${_game_exclusive_text}.\n"
        "GAME_ENABLE_SANITIZER_ADDRESS, GAME_ENABLE_SANITIZER_MEMORY and "
        "GAME_ENABLE_SANITIZER_THREAD cannot be combined with each other. "
        "Enable only one of them (GAME_ENABLE_SANITIZER_UNDEFINED can be "
        "added to any of them).")
endif()
 
set(SANITIZE_ADDRESS ${GAME_ENABLE_SANITIZER_ADDRESS})
set(SANITIZE_MEMORY ${GAME_ENABLE_SANITIZER_MEMORY})
set(SANITIZE_THREAD ${GAME_ENABLE_SANITIZER_THREAD})
set(SANITIZE_UNDEFINED ${GAME_ENABLE_SANITIZER_UNDEFINED})

function(game_project_settings target)
    target_compile_features(${target} PRIVATE cxx_std_23)

    if(GAME_ENABLE_WARNINGS)
        include(CompilerWarnings)

        if(GAME_WARNINGS_AS_ERROR)
            get_warnings(PROJECT_WARNINGS_CXX WARNINGS_AS_ERROR)
        else()
            get_warnings(PROJECT_WARNINGS_CXX)
        endif()

        target_compile_options(${target} PRIVATE
            "$<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNINGS_CXX}>"
        )
    endif()

    if(GAME_ENABLE_IPO)
        set_property(TARGET ${target} PROPERTY INTERPROCEDURAL_OPTIMIZATION_RELEASE TRUE)
    endif()

    if(SANITIZE_ADDRESS OR SANITIZE_MEMORY OR SANITIZE_THREAD OR SANITIZE_UNDEFINED)
        find_package(Sanitizers)
        add_sanitizers(${target})
    endif()

    if(GAME_ENABLE_CLANG_TIDY)
        find_program(GAME_CLANG_TIDY_EXE NAMES clang-tidy)
        if(GAME_CLANG_TIDY_EXE)
            set_property(TARGET ${target} PROPERTY CXX_CLANG_TIDY "${GAME_CLANG_TIDY_EXE}" "--config-file=${CMAKE_SOURCE_DIR}/.clang-tidy")
        else()
            message(FATAL_ERROR "GAME_ENABLE_CLANG_TIDY is ON, but clang-tidy was not found")
        endif()
    endif()

    if(GAME_ENABLE_CPPCHECK)
        find_program(GAME_CPPCHECK_EXE NAMES cppcheck)
        if(GAME_CPPCHECK_EXE)
            set_target_properties(${target} PROPERTIES
                CXX_CPPCHECK "${GAME_CPPCHECK_EXE};--enable=warning,performance,portability;--inline-suppr;--error-exitcode=1"
            )
        else()
            message(FATAL_ERROR "GAME_ENABLE_CPPCHECK is ON, but cppcheck was not found")
        endif()
    endif()

    if(GAME_ENABLE_CACHE)
        include(Cache)
        enable_cache()
    endif()
endfunction()