#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
char strcompare(std::string s1, std::string s2);
std::vector<char> strcompvec (std::string s1, std::string s2);
int main(){
    std::string input = "../input.txt";
    FileManager FM;
    FileManager::table_type rucksacks = FM.parse_file(input);
    //std::vector<char> priority;
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
    std::vector<char> last_set;

    for (size_t i = 2; i < rucksacks.size(); i+= 3)
    {
        std::vector<char> priority = {};
        std::cout << i << std::endl;
        std::vector<char> r1, r2;
        r1 = strcompvec(rucksacks[i-2][0], rucksacks[i-1][0]);
        std::cout << "Stringa 1: ";
        for(auto i: r1)
        std::cout << i << " ";
        std::cout << std::endl;
        r2 = strcompvec(rucksacks[i-1][0], rucksacks[i][0]);
        std::cout << "Stringa 2: ";
        for(auto i: r2)
        std::cout << i << " ";
        std::cout << std::endl;
        int count = 0;
        for(auto i: r1)
        {
            for(auto j:r2)
            {
                if(i == j){
                    priority.push_back(i);
                }
            }
            count = 0;
        }
        std::unordered_set<char> priority_set(priority.begin(), priority.end());
        std::cout << "Priority set: ";
        for (auto q:priority_set)
        {
            std::cout << q <<" ";
        }
        std::cout << std::endl;
        if (priority_set.size() == 1){
        
        for (auto q:priority_set)
        {
            std::cout << "Inserisco " << q << std::endl;
            last_set.push_back(q);
        }
        
        std::cout << std::endl;
        }
    }
    int total = 0;
    int test = 'A';
    int temp;
    for (auto i: last_set)
    {
        std::cout << i << " ";
        if (i != '&' && i >= 97)
        {   
            temp = i-96;
            std::cout << temp << std::endl;
            total += temp;
        }
        else if (i != '&' && i <= 90)
        {
            temp = i-38;
            std::cout << temp << std::endl;
            total += temp;
        }
        
    }
    std::cout << "Last set: "<< last_set.size() << std::endl;
    if(last_set.size() == rucksacks.size()/3)
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
    int duplicate = 0;
    if (s1.length() >= s2.length()){
        std::cout << "Stringa 1 maggiore " << s1 << " comparata con " << s2 << std::endl;
        for (size_t i = 0; i < s1.length(); i++)
        {
            for (size_t j = 0; j < s2.length(); j++)
            {
                if (s1[i] == s2[j] && duplicate == 0)
                {
                    res.push_back(s1[i]);
                    duplicate++;
                }
                
            }
            duplicate = 0;
        }
    }
    else{
        std::cout << "Stringa 2 maggiore " << s2 << " comparata con " << s1 << std::endl;
        for (size_t i = 0; i < s2.length(); i++)
        {
            for (size_t j = 0; j < s1.length(); j++)
            {
                if (s2[i] == s1[j] && duplicate == 0)
                {
                    res.push_back(s2[i]);
                    duplicate++;
                }
                
            }
            duplicate = 0;
        }
    }
    return res;
}