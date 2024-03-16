// [capture list](arglist) mutable(optional) exceptionalProperty -> returnType {
//     body
// }
void lambda_ref(void) {
    int value = 1;
    auto copy_value = [&value] {
        return value;
    }
    value = 100;
    auto stored_value = copy_value();   // => 100
}

void lambda_function_container(void) {
    int closure = 100;

    std::function<int(int)> func = [&](int value) -> int {
        return 1 + value + closure;
    };
}

int foo(int a, int b, int c) {
    return a + b + c;
}

void lambda_bind_curry(void) {
    auto bindFoo = std::bind(foo, std::placeholders::_1, 1, 2); // curry
    bindFoo(1);
}
