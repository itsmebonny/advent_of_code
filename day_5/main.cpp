#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
int main(){
    std::string input_draw = "../input_draw.txt";
    std::string input = "../input.txt";
    std::ifstream f(input_draw);
    std::string line;
    while (std::getline(f, line, '\n'))
    {
        std::cout << line[0] << std::endl;
    }
    
    return 0;
}