#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
std::vector<int> strtoint(std::string s1){
    int it = s1.find('-');
    std::vector<int> v;
    std::string uno = s1.substr(0, it);
    std::string due = s1.substr(it+1, s1.length()-1);
    int start = std::stoi(uno);
    int end = std::stoi(due);
    for (size_t i = start; i <= end; i++)
    {
        v.push_back(i);
    }
    return v;
}
int main(){
    std::string input = "../input.txt";
    FileManager FM;
    int count = 0;
    FileManager::table_type ranges = FM.parse_file(input);
    for (size_t i = 0; i < ranges.size(); i++){  
        std::vector<int> range1;
        std::vector<int> range2;
        
            range1 = strtoint(ranges[i][0]);
            range2 = strtoint(ranges[i][1]);
            if (range1[0] <= range2[0] && range1[range1.size()-1] >= range2[0])
            {
                count++;
            }
            else if (range2[0] <= range1[0] && range2[range2.size()-1] >= range1[0])
            {
                count++;
            }
            
        
        
        
    }
    std::cout << count << std::endl;
    return 0;
}
