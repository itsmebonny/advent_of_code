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
    char temp;
    int count = 0;
    std::vector<char> s;
    for (size_t i = 0; i < signal.length(); i++)
    {
        s.push_back(signal[i]);
        std::cout << i << " " << s.size() << std::endl;
        if (s.size() == 14){
            for(char k:s)
                std::cout << k << " ";
            std::cout << std::endl; 
            std::unordered_set check(s.begin(), s.end());
            if(check.size() == 14)
               { std::cout << i+1 << std::endl;
                i = signal.length();}
            else
                {   std::cout << "riprovo" << std::endl;
                    s.clear();
                    i -= 13;
                }    
            }

    }
    
    
    return 0;
}