#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_set>
#include "FileManager.hpp"




// reads the file passed as argument, whose elements are separated by
// the given character, and returns a table with the corresponding fields
const FileManager::table_type &FileManager::parse_file (const std::string& filename, char d){
    std::ifstream f(filename);
    std::string line;
    unsigned j = 0;
    unsigned i = 0;
    int count = 0;
    std::string substr1;
    std::string substr2;
    while (std::getline(f, line, '\n'))
    {   substr1 = line.substr(0, line.length()/2);
        substr2 = line.substr(line.length()/2, line.length());
        fields.push_back(row_type());
        //uncomment for second part 
        fields[i].push_back(line); 
        //uncomment for first part
        //fields[i].push_back(substr1);
        //fields[i].push_back(substr2);
        i++;
        
    }
    
    return fields;
}


