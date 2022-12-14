//
// Created by Federica Filippini on 25/11/2019.
//

#ifndef STUDENTSFILE_FILEMANAGER_H
#define STUDENTSFILE_FILEMANAGER_H
#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>


class FileManager {

    typedef std::vector<int> row_type;
    typedef std::vector<row_type> table_type;

    table_type fields;

public:
    // default constructor
    FileManager () = default;

    // reads the file passed as argument, whose elements are separated by
    // the given character, and returns a table with the corresponding fields
    const table_type& parse_file (const std::string& filename, char d = '\n');

};

#endif //STUDENTSFILE_FILEMANAGER_H