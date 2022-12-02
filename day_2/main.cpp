#include<iostream>
#include<unordered_map>
#include "FileManager.hpp"
#include <utility>
#include <functional>

int main(){
    std::string input = "../input.txt";
    FileManager FM;
    FileManager::table_type strategy;
    std::unordered_map<std::string, int> results;
    std::unordered_map<std::string, int> second_results;
    int win = 6;
    int lose = 0;
    int draw = 3;
    int rock = 1;
    int paper = 2; 
    int scissors = 3;
    int total = 0;
    /*
    A X Rock  1
    B Y Paper  2
    C Z Scissors  3

    AX AY AZ XA YA ZA
    BX BY BZ XB YB ZB
    CX CY CZ XC YC ZC
    */
    results.insert(std::make_pair("A X", draw + rock));
    results.insert(std::make_pair("A Y", win + paper));
    results.insert(std::make_pair("A Z", lose + scissors));
    results.insert(std::make_pair("B X", lose + rock));
    results.insert(std::make_pair("B Y", draw + paper));
    results.insert(std::make_pair("B Z", win + scissors));
    results.insert(std::make_pair("C X", win + rock));
    results.insert(std::make_pair("C Y", lose + paper));
    results.insert(std::make_pair("C Z", draw + scissors));
    strategy = FM.parse_file(input);
    for (size_t i = 0; i < strategy.size(); i++)
    {
        for (size_t j = 0; j < strategy[i].size(); j++){
            std::unordered_map<std::string, int>::const_iterator got = results.find(strategy[i][j]);
            std::cout << got->second << std::endl;
            total += got->second;
        }
    }
    
    std::cout << total << std::endl;
    // second part

    /*
    A  Rock  1
    B  Paper  2
    C  Scissors  3


    X lose
    Y draw
    Z win

    AX AY AZ XA YA ZA
    BX BY BZ XB YB ZB
    CX CY CZ XC YC ZC
    */

    second_results.insert(std::make_pair("A X", lose + scissors));
    second_results.insert(std::make_pair("A Y", draw + rock));
    second_results.insert(std::make_pair("A Z", win + paper));
    second_results.insert(std::make_pair("B X", lose + rock));
    second_results.insert(std::make_pair("B Y", draw + paper));
    second_results.insert(std::make_pair("B Z", win + scissors));
    second_results.insert(std::make_pair("C X", lose + paper));
    second_results.insert(std::make_pair("C Y", draw + scissors));
    second_results.insert(std::make_pair("C Z", win + rock));
    int second_total = 0;
    for (size_t i = 0; i < strategy.size(); i++)
    {
        for (size_t j = 0; j < strategy[i].size(); j++){
            std::unordered_map<std::string, int>::const_iterator got = second_results.find(strategy[i][j]);
            second_total += got->second;
        }
    }
    
    std::cout << second_total << std::endl;
    return 0;
}