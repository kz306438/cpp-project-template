#include "email_validator.h"

#include <iostream>

int main()
{
    std::string email;
    std::cin >> email;
    std::cout << (isValidEmail(email) ? "valid" : "invalid") << std::endl;
    return 0;
}