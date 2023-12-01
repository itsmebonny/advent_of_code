#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <algorithm>

#include "FileManager.h"
typedef std::vector<int> row_type;
typedef std::vector<row_type> table_type;


int  main(){
    std::string input("../input.txt");
    FileManager FM;
    int total = 0;
    int best = 0;
    int second = 0;
    int third = 0;
    std::vector<int> sums(3);
    table_type elves = FM.parse_file(input);
    for (size_t i = 0; i < elves.size(); i++)
    {
        for (size_t j = 0; j < elves[i].size(); j++)
        {
            total += elves[i][j];
            
        }
        
        sums.push_back(total);
        for (size_t i = 0; i < sums.size(); i++)
        {
            if (sums[i] > best)
            best = sums[i];
            if (sums[i] > second && sums[i] < best)
            second = sums[i];
            if (sums[i] > third && sums[i] < second)
            third = sums[i];
        }
        
        
            total = 0;
    }

    std::sort(sums.begin(), sums.end());

    std::cout << best+second+third << std::endl;
    return 0;    
}

