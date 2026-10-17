function(get_warnings output_var)
    set(_wae FALSE)
    if("WARNINGS_AS_ERROR" IN_LIST ARGN)
        set(_wae TRUE)
    endif()

    set(MSVC_WARNINGS
        /W4
        /w14242 /w14254 /w14263 /w14265 /w14287
        /we4289 /w14296 /w14311
        /w14545 /w14546 /w14547 /w14549 /w14555
        /w14619 /w14640 /w14826 /w14905 /w14906 /w14928
        /permissive-
    )

    set(CLANG_WARNINGS
        -Wall -Wextra -Wshadow -Wnon-virtual-dtor -Wold-style-cast
        -Wcast-align -Wunused -Woverloaded-virtual -Wpedantic
        -Wconversion -Wnull-dereference -Wdouble-promotion
        -Wformat=2 -Wimplicit-fallthrough
    )

    set(GCC_WARNINGS
        ${CLANG_WARNINGS}
        -Wmisleading-indentation -Wduplicated-cond
        -Wduplicated-branches -Wlogical-op -Wuseless-cast
        -Wsuggest-override
    )

    if(_wae)
        list(APPEND CLANG_WARNINGS -Werror)
        list(APPEND GCC_WARNINGS   -Werror)
        list(APPEND MSVC_WARNINGS  /WX)
    endif()

    if(MSVC)
        set(PROJECT_WARNINGS_CXX ${MSVC_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(PROJECT_WARNINGS_CXX ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(PROJECT_WARNINGS_CXX ${GCC_WARNINGS})
    else()
        message(AUTHOR_WARNING "No compiler warnings for '${CMAKE_CXX_COMPILER_ID}'")
        return()
    endif()

    set(${output_var} ${PROJECT_WARNINGS_CXX} PARENT_SCOPE)
endfunction()