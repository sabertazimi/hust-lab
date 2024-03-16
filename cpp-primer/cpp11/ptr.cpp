#include <iostream>
#include <memory>

int *nullable = nullptr;

void foo(std::shared_ptr<int> i) {
    (*i++);
}

void shared_ptr_test(void) {
    auto pointer = std::make_shared<int>(10);
    int *raw_pointer = pointer.get();
    foo(pointer);
    std::cout << *pointer << std::endl;
}

template<typename T, typename... Args>
std::unique_ptr<T> make_unique(Args&& ...args) {
    return std::unique_ptr<T>(new T(std::forward<Args>(args)...));
}


