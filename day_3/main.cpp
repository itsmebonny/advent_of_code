#include "FileManager.hpp"
char strcompare(std::string s1, std::string s2);
std::vector<char> strcompvec (std::string s1, std::string s2);
int main(){
    std::string input = "../input.txt";
    FileManager FM;
    FileManager::table_type rucksacks = FM.parse_file(input);
    std::vector<char> priority;
    /*
    Uncomment for first part
    for (size_t i = 0; i < rucksacks.size(); i++)
    {
        {
            priority.push_back(strcompare(rucksacks[i][0], rucksacks[i][1]));
        }
    }
    int total = 0;
    int test = 'A';
    int temp;
    for (size_t i = 0; i < priority.size(); i++)
    {
        if (priority[i] != '&' && priority[i] >= 97)
        {   
            temp = priority[i]-96;
            total += temp;
        }
        else if (priority[i] != '&' && priority[i] <= 90)
        {
            temp = priority[i]-38;
            total += temp;
        }
        
    }
    std::cout << total << std::endl;
    */
    // FileManager must be changed for the second part
    for (size_t i = 2; i < rucksacks.size(); i++)
    {
        std::vector<char>
        
    }
    int total = 0;
    int test = 'A';
    int temp;
    for (size_t i = 0; i < priority.size(); i++)
    {
        std::cout << priority[i] << std::endl;
        if (priority[i] != '&' && priority[i] >= 97)
        {   
            temp = priority[i]-96;
            total += temp;
        }
        else if (priority[i] != '&' && priority[i] <= 90)
        {
            temp = priority[i]-38;
            total += temp;
        }
        
    }    
    std::cout << total <<std::endl;
    return 0;
}
char strcompare(std::string s1, std::string s2){
    char res;
    for (size_t i = 0; i < s1.length(); i++)
    {
        for (size_t j = 0; j < s2.length(); j++)
        {
            if (s1[i] == s2[j])
            {
                return s1[i];
            }
            
        }
        
    }
    return '&';
    
}
std::vector<char> strcompvec (std::string s1, std::string s2){
    std::vector<char> res;
    for (size_t i = 0; i < s1.length(); i++)
    {
        for (size_t j = 0; j < s2.length(); j++)
        {
            if (s1[i] == s2[j])
            {
                res.push_back(s1[i]);
            }
            
        }
        
    }
    return res;
}