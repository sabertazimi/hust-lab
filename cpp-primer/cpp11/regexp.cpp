#include <iostream>
#include <regex>

int main(void) {
    std::regex r1("S");
    std::cout << "S works." << std::endl;
    std::regex r2(".");
    std::cout << ". works." << std::endl;
    std::regex r3(".+");
    std::cout << ".+ works." << std::endl;
    std::regex r4("[0-9]");
    std::cout << "[0-9] works." << std::endl;

    std::string fnames[] = {"foo.txt", "bar.txt", "test", "a0.txt", "AAA.txt"};
    std::regex txt_regex("[a-z]+\\.txt");
    for (const auto &fname: fnames) {
        std::cout << fname << ": " << std::regex_match(fname, txt_regex) << std::endl;
    }

    return 0;
}
