#include "FileManager.hpp"
#include <unordered_set>
#include <set>
#include <algorithm>
int main(){
    std::string input_draw = "../input_draw.txt";
    std::string input = "../input.txt";
    std::ifstream r(input_draw);
    std::string pine;
    int it = 0;
    while (std::getline(r, pine, '\n'))
    {
        it++;   
    }
    std::ifstream f(input_draw);
    std::string line;
    std::vector<std::vector<std::string>> v(it);
    while (std::getline(f, line, '\n'))
    {   
        for(size_t k = 0; k < line.length(); k++){
            if (line[k] == '['){
                std::string s(1,line[k]);
                s.push_back(line[k+1]);
                s.push_back(line[k+2]);
                //std::cout <<"Crane: "<< k/4 << " " << s << std::endl;
                v[k/4].push_back(s);
                
            }
        }
    }
    
    for (size_t i = 0; i < v.size(); i++)
    {
        std::reverse(v[i].begin(),v[i].end());
        std::cout << i << ": ";
        for (size_t j = 0; j < v[i].size(); j++)
        {
            std::cout << v[i][j] << " ";
        }
        std::cout << std::endl;
    }
    std::ifstream num(input);
    int count = 0;
    while(std::getline(num, line, '\n')){
        count++;
    }
    std::ifstream g(input);
    std::vector<std::vector<std::string>> instructions(count);
    int pos = 0;
    while(std::getline(g, line, '\n')){
        
        if(line[6] != ' '){
            std::string doublenumber(1,line[5]);
            doublenumber.push_back(line[6]);
            instructions[pos].push_back(doublenumber);
            instructions[pos].push_back("crane(s)");
            instructions[pos].push_back("from");
            instructions[pos].push_back(std::string(1, line[13]-1));
            instructions[pos].push_back("to");
            instructions[pos].push_back(std::string(1, line[18]-1));            
        }
        else{
            instructions[pos].push_back(std::string (1, line[5]));
            instructions[pos].push_back("crane(s)");
            instructions[pos].push_back("from");
            instructions[pos].push_back(std::string(1, line[12]-1));
            instructions[pos].push_back("to");
            instructions[pos].push_back(std::string(1, line[17]-1));
        }
        pos++;
    }
    /*
    for (size_t u = 0; u < instructions.size(); u++)
    {
        for (size_t i = 0; i < instructions[u].size(); i++)
        {
            std::cout <<instructions[u][i] <<" ";
        }
        std::cout << std::endl;
    } 
    */  
    std::cout << "CRANE PROCESS" <<std::endl;
    for (size_t u = 0; u < instructions.size(); u++)
    {       std::vector<std::string> crane;
            int num_cranes = std::stoi(instructions[u][0]);
            int start = std::stoi(instructions[u][3]);
            int end = std::stoi(instructions[u][5]);
            int position = 0;
            for (size_t m = 1; m <= num_cranes; m++)
            {
                            
                std::cout << "Picking "<< m << " -> "<< v[start][v[start].size()-m] << " from " << start << std::endl;
                std::cout << "Putting them in " << end << std::endl;
                crane.push_back(v[start][v[start].size()-m]);
                position = v[start].size()-num_cranes;
                

            }
            std::reverse(crane.begin(), crane.end());
            for (size_t w = 0; w < crane.size(); w++)
            {
                v[end].push_back(crane[w]);
                v[start].pop_back();
                position++;   
            }
            
            std::cout <<"============================" <<std::endl;
            for (size_t i = 0; i < v.size(); i++)
            {
                std::cout << i << ": ";
                for (size_t j = 0; j < v[i].size(); j++)
                {
                    std::cout << v[i][j] << " ";
                }
                std::cout << std::endl;
            }
            std::cout <<"============================" <<std::endl;            
        
        std::cout << std::endl;
        
    }
    std::cout << "Crane order now: " <<std::endl;
    for (size_t i = 0; i < v.size(); i++)
    {
        std::cout << i << ": ";
        for (size_t j = 0; j < v[i].size(); j++)
        {
            std::cout << v[i][j] << " ";
        }
        std::cout << std::endl;
    }
    std::string answer("Answer is: ");
    for (size_t i = 0; i < v.size(); i++)
    {
        answer.push_back(v[i][v[i].size()-1][1]);
    }
    std::cout << answer << std::endl;
    return 0;
}