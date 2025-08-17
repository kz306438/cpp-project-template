set(LIBRARY_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/email_validator.cpp")
set(LIBRARY_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/email_validator.h")
set(LIBRARY_INCLUDES "${CMAKE_CURRENT_SOURCE_DIR}")

add_library("EmailValidator" STATIC ${LIBRARY_SOURCES} ${LIBRARY_HEADERS})
target_include_directories(EmailValidator
    PUBLIC
        ${LIBRARY_INCLUDES}
        ${Boost_INCLUDE_DIRS}

)
target_link_libraries("EmailValidator"
    PRIVATE 
        Boost::boost
)

if(${ENABLE_CLANG_TIDY})
    add_clang_tidy_to_target("EmailValidator")
endif()