#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <array>
#include <algorithm>
#include <cmath>
typedef std::array<int, 2> position;

void print_instructions(std::vector<std::vector<std::string>> &signal){
    for (size_t i = 0; i < signal.size(); i++)
    {
        for (size_t j = 0; j < signal.at(i).size(); j++)
        {
            std::cout << signal.at(i).at(j) << " ";
        }
        std::cout << std::endl;
    }
}
void print_crt(std::vector<std::vector<char>> CRT){
std::cout << "===================" << std::endl;
        for (size_t o = 0; o < CRT.size(); o++)
    {
        for (size_t j = 0; j < CRT.at(o).size(); j++)
        {
            std::cout << CRT.at(o).at(j);
        }
        std::cout << std::endl;
    }
std::cout << "===================" << std::endl;
}
int main(){
    std::string input = "../input.txt";
    std::ifstream f(input);
    std::string line;
    std::vector<std::vector<std::string>> signal;
    std::vector<int> old_checks = {20, 60, 100, 140, 180, 220};
    std::vector<int> checks = {41, 81, 121, 161, 201, 241};
    std::vector<std::vector<char>> CRT(7);
    unsigned count = 0;
    int x = 1;
    size_t k = 0;
    while (std::getline(f, line, '\n'))
    {   
        signal.push_back(std::vector<std::string>(2));
        signal.at(k).at(0) = (line.substr(0, 4));
        try{signal.at(k).at(1) = (line.substr(5));}
        catch(std::out_of_range){signal.at(k).at(1) = "skip";}
        k++;
    }
    //print_instructions(signal);
    int cycle = 0;
    int total = 0;
    int col = 0;
    for (size_t i = 0; i < signal.size(); i++)
    {
    std::cout << "cycle: " << count << " x: "<< x << std::endl;
        if (signal.at(i).at(0) == "addx"){
            count++;
            if(cycle < checks.size() && count == checks.at(cycle))
            {cycle++;col=0;}
            if (std::abs(col - x) <= 1)
                CRT.at(cycle).push_back('#');
            else
                CRT.at(cycle).push_back('.');
            col++;
            count++;
            if(cycle < checks.size() && count == checks.at(cycle))
            {cycle++;col=0;}
            if (std::abs(col - x) <= 1)
                CRT.at(cycle).push_back('#');
            else
                CRT.at(cycle).push_back('.');
            col++;
            x += std::stoi(signal.at(i).at(1));
        }
        else
            {count++;
            if(cycle < checks.size() && count == checks.at(cycle))
            {cycle++;col=0;}
            if (std::abs(col - x) <= 1)
                CRT.at(cycle).push_back('#');
            else
                CRT.at(cycle).push_back('.');
            col++;
        
    }
    }
std::cout << cycle << " pooo" <<std::endl;

for (size_t i = 0; i < CRT.size(); i++)
    {
        for (size_t j = 0; j < CRT.at(i).size(); j++)
        {
            std::cout << CRT.at(i).at(j);
        }
        std::cout << std::endl;
    }

    std::cout << total << std::endl;
    return 0;
}