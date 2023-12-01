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
    std::unordered_set verifica = {'A', 'B', 'C', 'X', 'Y', 'Z'};

    while (std::getline(f, line, '\n'))
    {
        fields.push_back(row_type());  
        fields[i].push_back(line);
        i++;
        
    }
    
    return fields;
}


