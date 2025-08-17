add_executable(EmailValidatorTest email_validator_test.cpp)

target_include_directories(EmailValidatorTest
    PRIVATE
        ${GTest_INCLUDE_DIRS}
)

target_link_libraries(EmailValidatorTest
    PRIVATE
        EmailValidator
        gtest::gtest
)

add_test(NAME EmailValidatorTest COMMAND EmailValidatorTest)