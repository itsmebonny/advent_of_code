#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <array>
#include <algorithm>
#include <cmath>
#include "Monkey.h"
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
int main(){
    std::string input = "../input.txt";
    std::ifstream f(input);
    std::string line;
    std::vector<std::vector<std::string>> signal;
    size_t k = 0;
    Monkey m0(0, {79,98}, "mul 19", 23, 2, 3);
    Monkey m1(1, {54, 65, 75, 74}, "add 6", 19, 2, 0);
    Monkey m2(2, {79, 60, 97}, "mul old", 13, 1, 3);
    Monkey m3(3, {74}, "add 3", 17, 0, 1);
    std::vector<Monkey> jungle;
    jungle.push_back(m0);
    jungle.push_back(m1);
    jungle.push_back(m2);
    jungle.push_back(m3);
    int rounds = 20;
    m0.print();

    for (size_t i = 0; i < rounds; i++)
    {
        for (auto j : jungle){
            Monkey yes = get_monkey(jungle, j.yes());
            Monkey no = get_monkey(jungle, j.no());
            for (size_t k = 0; k < j.get_size(); k++)
            {
                j.update_holding();
                if(j.check())
                    j.throw_item(k, yes);
                else    
                    j.throw_item(k, no);
            }
            
        }
    }
    
    //print_instructions(signal);
  
    std::cout << "===============" << std::endl;
    m0.print();
    return 0;
}