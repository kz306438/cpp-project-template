add_executable(EmailValidatorTest email_validator_test.cpp)

target_include_directories(EmailValidatorTest
    PRIVATE
        ${GTest_INCLUDE_DIRS}
)

target_link_libraries(EmailValidatorTest
    PRIVATE
        EmailValidator
        ${GTest_LIBRARIES}
        pthread    
)

add_test(NAME EmailValidatorTest COMMAND EmailValidatorTest)