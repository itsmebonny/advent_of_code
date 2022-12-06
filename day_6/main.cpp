#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <unordered_set>
#include <set>
#include <algorithm>
int main(){
    std::string input = "../input.txt";
    std::ifstream f(input);
    std::string line;
    std::string signal;
    while (std::getline(f, line, '\n'))
    {   
        signal = line;
    }
    
    std::cout << signal << std::endl;
    bool check = true;
    std::vector<char> s;
    s.push_back(signal[0]);
    s.push_back(signal[1]);
    s.push_back(signal[2]);
    for (size_t i = 3; i < signal.length(); i++)
    {
        for (size_t j = 0; j < s.size(); j++)
        {
            for (char k:s)
            {
                std::cout << k << " ";
            }
            std::cout << std::endl;
            if (signal[i] == s[j] && s.size() < 4)
            {
                std::cout << "pulisco per " << signal[i] << std::endl;
                
                i = i - j;
                std::cout << "inserisco " << signal[i] << std::endl;

                s.clear();
            }
            else
            {
                if (s.size() == 4){
                    std::cout << i << std::endl;
                    i = signal.length();
                    j = s.size();
                    }
            }

        }
        s.push_back(signal[i]);

        
    }
    
    
    return 0;
}