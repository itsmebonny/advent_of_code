#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_set>
#include <set>
#include <algorithm>
int main(){
    std::string input = "../input.txt";
    std::ifstream f(input);
    std::string line;
    std::vector<std::vector<std::string>> signal;
    std::vector<std::vector<int>> matrix;
    int i = 0;
    while (std::getline(f, line, '\n'))
    {   
        signal.push_back(std::vector<std::string>(2));
        signal.at(i).at(0) = (line.substr(0, 1));
        signal.at(i).at(1) = (line.substr(2));
        i++;
    }
    for (size_t i = 0; i < signal.size(); i++)
    {
        std::cout << signal.at(i).at(0) << " " << signal.at(i).at(1) << std::endl;  
    }
    
    
    return 0;
}