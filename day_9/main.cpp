#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <array>
#include <algorithm>
#include <cmath>
typedef std::array<int, 2> position;

position update(position pos_head, position pos_tail){
    if (pos_head.at(0) == pos_tail.at(0) && pos_head.at(1) > pos_tail.at(1))
        pos_tail.at(1)++;
    else if (pos_head.at(0) == pos_tail.at(0) && pos_head.at(1) < pos_tail.at(1))
        pos_tail.at(1)--;
    else if (pos_head.at(0) > pos_tail.at(0) && pos_head.at(1) == pos_tail.at(1))
        pos_tail.at(0)++;
    else if (pos_head.at(0) < pos_tail.at(0) && pos_head.at(1) == pos_tail.at(1))
        pos_tail.at(0)--;
    else{
        if (pos_head.at(0) > pos_tail.at(0) && pos_head.at(1) > pos_tail.at(1))
            {pos_tail.at(0)++;
            pos_tail.at(1)++;}
        else if (pos_head.at(0) > pos_tail.at(0) && pos_head.at(1) < pos_tail.at(1))
            {pos_tail.at(0)++;
            pos_tail.at(1)--;}
        else if (pos_head.at(0) < pos_tail.at(0) && pos_head.at(1) > pos_tail.at(1))
            {pos_tail.at(0)--;
            pos_tail.at(1)++;}
        else if (pos_head.at(0) < pos_tail.at(0) && pos_head.at(1) < pos_tail.at(1))
            {pos_tail.at(0)--;
            pos_tail.at(1)--;}
    }
    return pos_tail;
}

bool valid (position pos1, position pos2){
    return ((pos1.at(0) - pos2.at(0) <= 1 && pos1.at(0) - pos2.at(0) >= -1) && (pos1.at(1) - pos2.at(1) <= 1 && pos1.at(1) - pos2.at(1) >= -1));
    }

position update_rope(std::vector<position> &rope){
    for (size_t i = 1; i < rope.size(); i++)
    {
        if(!valid(rope.at(i-1), rope.at(i)))
        {            
            rope.at(i) = update(rope.at(i-1), rope.at(i));
        }    
    }
    return rope.at(rope.size()-1);
}

int main(){
    std::string input = "../input.txt";
    std::ifstream f(input);
    std::string line;
    std::vector<std::vector<std::string>> signal;
    std::map<position, bool> matrix;
    unsigned i = 0;
    while (std::getline(f, line, '\n'))
    {   
        signal.push_back(std::vector<std::string>(2));
        signal.at(i).at(0) = (line.substr(0, 1));
        signal.at(i).at(1) = (line.substr(2));
        i++;
    }
    std::vector<position> rope(9, {0,0});    
    position pos_tail = {0,0};
    for (size_t i = 0; i < signal.size(); i++)
    {
        if (signal.at(i).at(0) == "R")
        {
            std::cout <<"DESTRA ->"<< std::endl; 
            for (size_t j = 1; j <= std::stoi(signal.at(i).at(1)); j++)
            {
                rope.at(0).at(1)++;
                position pos_head = update_rope(rope);
                if (valid(pos_head, pos_tail))
                {
                    matrix[pos_tail] = true;
                }
                else{
                    pos_tail = update(pos_head, pos_tail);
                    if(valid(pos_head, pos_tail)){matrix[pos_tail] = true;}
                }
                
            }
        std::cout << "corda: ";
        for (size_t i = 0; i < rope.size(); i++)
        {
            std::cout << i << ": " << rope.at(i).at(0) << " " << rope.at(i).at(1) << ", ";
        }
        std::cout << "coda: " << pos_tail[0] << " " << pos_tail[i] << std::endl;
        }
        if (signal.at(i).at(0) == "U")
        {
            std::cout <<"SU ^"<< std::endl;
            for (size_t j = 1; j <= std::stoi(signal.at(i).at(1)); j++)
            {
                rope.at(0).at(0)++;
                position pos_head = update_rope(rope);
                if (valid(pos_head, pos_tail))
                {
                    matrix[pos_tail] = true;
                }
                else{
                    pos_tail = update(pos_head, pos_tail);
                    if(valid(pos_head, pos_tail)){matrix[pos_tail] = true;}
                }
                
                
            }
        
        std::cout << "corda: ";
        for (size_t i = 0; i < rope.size(); i++)
        {
            std::cout << i << ": " << rope.at(i).at(0) << " " << rope.at(i).at(1) << ", ";
        }
        std::cout << "coda: " << pos_tail[0] << " " << pos_tail[i] << std::endl;
        }
        if (signal.at(i).at(0) == "L")
        {
            std::cout <<"SINISTRA <-"<< std::endl;
            for (size_t j = 1; j <= std::stoi(signal.at(i).at(1)); j++)
            {
                rope.at(0).at(1)--;
                position pos_head = update_rope(rope);
                std::cout << pos_head[0]<< " " << pos_head[1] << std::endl;
                if (valid(pos_head, pos_tail))
                {
                    matrix[pos_tail] = true;
                }
                else{
                    pos_tail = update(pos_head, pos_tail);
                    if(valid(pos_head, pos_tail)){matrix[pos_tail] = true;}
                }
                
            }
        
        std::cout << "corda: ";
        for (size_t i = 0; i < rope.size(); i++)
        {
            std::cout << i << ": " << rope.at(i).at(0) << " " << rope.at(i).at(1) << ", ";
        }
        std::cout << "coda: " << pos_tail[0] << " " << pos_tail[i] << std::endl;
        }
        if (signal.at(i).at(0) == "D")
        {
            std::cout <<"GIÙ"<< std::endl;
            for (size_t j = 1; j <= std::stoi(signal.at(i).at(1)); j++)
            {
                rope.at(0).at(0)--;
                position pos_head = update_rope(rope);
                
                if (valid(pos_head, pos_tail))
                {
                    matrix[pos_tail] = true;
                }
                else{
                    
                    pos_tail = update(pos_head, pos_tail);
                    if(valid(pos_head, pos_tail)){matrix[pos_tail] = true;}
                }
                
            }
        
        std::cout << "corda: ";
        for (size_t i = 0; i < rope.size(); i++)
        {
            std::cout << i << ": " << rope.at(i).at(0) << " " << rope.at(i).at(1) << ", ";
        }
        std::cout << "coda: " << pos_tail[0] << " " << pos_tail[i] << std::endl;
        }
    }
    int max_rows = 0;
    int max_cols = 0;
    int count = 0;
    for (auto [key,value] : matrix)
    {
        if (key.at(0) > max_rows)
            max_rows = key.at(0);
        if (key.at(1) > max_cols)
            max_cols = key.at(1);
        if(value)
            count++;
    }
    max_rows++;
    max_cols++;
    int pos = 0;
    for (int i = 30; i >= -30; i--) 
    {
        for (int j = -30; j < 30; j++)  
        {
            int count = 0;
            auto it = matrix.find({i,j});
                if (it != matrix.end()){
                        std::cout << it->second << " ";
                        pos++;
                }
                else{
                    std::cout << "- ";
                }
            }
            std::cout <<std::endl;

        }
    
    
    std::cout << count << std::endl;
    return 0;
}