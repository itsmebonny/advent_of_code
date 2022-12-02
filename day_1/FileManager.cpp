#include <iostream>
#include <fstream>
#include <sstream>

#include "FileManager.h"




// reads the file passed as argument, whose elements are separated by
// the given character, and returns a table with the corresponding fields
const FileManager::table_type &FileManager::parse_file (const std::string& filename, char d){
    std::ifstream f(filename);
    std::string line;
    unsigned j = 0;
    int count = 0;
    while (std::getline(f, line))
    {
        j++;
    }
    fields.resize(j);
    std::ifstream g(filename);
    while (std::getline(g, line))
    {
        
        std::istringstream record(line);
        std::string stringa;
        if (count == 0){
            fields.push_back(std::vector<int>());
        }
        if (line.length() == 0)
        {
            count++;
            std::cout << "cambio elfo "<< std::endl;
        }
        else
            fields[count].push_back(std::stoi(line));
        
    }
    
    return fields;
}


