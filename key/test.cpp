#include <iostream>

extern "C" {
    double sscc(double, double);
}

int main() {
    std::cout << "average of 3.0 and 4.0: " << sscc(3.0, 4.0) << std::endl;
}