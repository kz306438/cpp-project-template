#include "email_validator.h"

#include <regex>

bool isValidEmail(const std::string& email)
{
    static const std::regex pattern(R"(^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$)");
    return std::regex_match(email, pattern);
}