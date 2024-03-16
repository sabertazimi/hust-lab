template<typename... Args>
void printf(const std::string &str, Args... args);

template<typename... Args>
void magic(Args... args) {
    std::cout << sizeof...(args) << std::endl;
}

template<typename T>
void printf(T value) {
    std::cout << value << std::endl;
}

// recursion
template<typename T, typename... Args>
void printf(T value, Args... args) {
    std::cout << value << std::endl;
    printf(args...);
}

// initializer_list
template<typename T, typename... Args>
auto printf(T value, Args... args) {
    std::cout << value << std::endl;
    return std::initializer_list<T> {([&] {
        std::cout << args << std::endl;
    }(), value)...};
}
