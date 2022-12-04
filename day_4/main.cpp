#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
std::vector<int> strtoint(std::string s1);
int main(){
    std::string input = "../input.txt";
    FileManager FM;
    FileManager::table_type ranges = FM.parse_file(input);
    for (size_t i = 0; i < ranges.size(); i++)
    {   std::cout <<" bar" << std::endl;
        std::vector<int> range1;
        std::vector<int> range2;
        for (size_t j = 0; j < ranges[i].size(); j++)
        {
            range1 = strtoint(ranges[i][0]);
            std::cout <<" fbaroo" << std::endl;
            range2 = strtoint(ranges[i][1]);
        }
        std::cout << std::endl;
        
    }
    
    return 0;
}
std::vector<int> strtoint(std::string s1){
    int it = s1.find('-');
    std::cout <<" foo" << std::endl;

    std::vector<int> v;
    std::cout <<" foo" << s1[it];
    std::string fhalf = s1.substr(0, it-1);
    std::string shalf = s1.substr(it+1, s1.length());
    for (size_t i = std::stoi(fhalf); i < std::stoi(shalf); i++)
    {
        v.push_back(i);
    }
    return v;
}