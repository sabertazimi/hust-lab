template<typename T = int, typename U = int>
auto add(T x, U y) -> decltype(x+y) {
	return x + y;
}

for (auto &x : arr) {
    std::cout << x << std::endl;
}

for (auto &i : vec) {
    std::cout << i << std::endl;
}
