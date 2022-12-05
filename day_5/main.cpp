#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
int main(){
    std::string input_draw = "../input_draw.txt";
    std::string input = "../input.txt";
    std::ifstream f(input_draw);
    std::string line;
    std::vector<std::vector<char>> v(3);
    std::cout << v.size() << std::endl;
    while (std::getline(f, line, '\n'))
    {   
        for(size_t k = 0; k < line.length(); k++){
            
            if (line[k] == '['){
                v[k/3].push_back(line[k]);
                v[k/3].push_back(line[k+1]);
                v[k/3].push_back(line[k+2]);
                k+=3;
            }
        }
    }
    for (size_t i = 0; i < v.size(); i++)
    {
        std::cout << i << ": ";
        for (size_t j = 0; j < v[i].size(); j+=3)
        {
            std::cout << v[i][j] << v[i][j+1] << v[i][j+2] << " ";
        }
        std::cout << std::endl;
    }
    std::ifstream num(input);
    int count = 0;
    while(std::getline(num, line, '\n')){
        count++;
    }
    std::cout << count << std::endl;
    std::ifstream g(input);
    std::vector<std::vector<std::string>> instructions(count);
    int pos = 0;
    while(std::getline(g, line, '\n')){
        instructions[pos].push_back(std::string (1, line[5]));
        instructions[pos].push_back("crane(s)");
        instructions[pos].push_back("from");
        instructions[pos].push_back(std::string(1, line[12]));
        instructions[pos].push_back("to");
        instructions[pos].push_back(std::string(1, line[17]));
        pos++;
    }
    for (size_t u = 0; u < instructions.size(); u++)
    {
        for (size_t i = 0; i < instructions[u].size(); i++)
        {
            std::cout << instructions[u][i] << " ";
        }
        std::cout << std::endl;
        
    }
    
    return 0;
}