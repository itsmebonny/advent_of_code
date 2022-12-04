#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_set>
#include "FileManager.hpp"




// reads the file passed as argument, whose elements are separated by
// the given character, and returns a table with the corresponding fields
const FileManager::table_type &FileManager::parse_file (const std::string &filename, char d){
    std::ifstream f(filename);
    std::string line;
    unsigned j = 0;
    unsigned i = 0;
    int count = 0;
    while (std::getline(f, line, '\n'))
    {   
        std::istringstream record(line);
        std::string linea;
        fields.push_back(row_type());
        while(std::getline(record, linea, ',')){
        fields[i].push_back(linea);
        }
        i++;
        
    }
    
    return fields;
}


