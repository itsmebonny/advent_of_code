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
    std::vector<std::string> signal;
    std::vector<std::vector<int>> matrix;
    while (std::getline(f, line, '\n'))
    {   
        signal.push_back(line);
    }
    for (size_t i = 0; i < signal.size(); i++)
    {
        matrix.push_back(std::vector<int>());
        for (size_t j = 0; j < signal.at(i).length(); j++)
        {
            matrix.at(i).push_back(std::stoi(signal.at(i).substr(j,1)));
        }
        
    }

    int visible = matrix.size()*4 - 4;
    std::vector<int> scenic_score;
    for (size_t i = 1; i < matrix.size()-1; i++)
    {
        for (size_t j = 1; j < matrix.at(i).size()-1; j++)
        {
            int tree = matrix.at(i).at(j);
            bool top = false;
            bool bottom = false;
            bool right = false;
            bool left = false;
            int count = 0;
            int scenic = 1;
            std::cout << "Albero in posizione " << i << " " << j << std::endl;
            for (int k = i-1; k >= 0; k--)
            {
                if (tree > matrix.at(k).at(j))
                    count++;
                else if (tree == matrix.at(k).at(j)){
                    count++;
                    k = 0;}
                else if (tree < matrix.at(k).at(j)){
                    count++;
                    k = 0;}
                else
                    k = 0;
            }
            if(count == 0)
                count++;
            std::cout << "Top: " << count << std::endl;
            scenic *= count;
            count = 0;
            for (size_t k = i+1; k < matrix.size(); k++)
            {
                if (tree > matrix.at(k).at(j))
                    count++;
                else if (tree == matrix.at(k).at(j)){
                    count++;
                    k = matrix.size();}
                else if (tree < matrix.at(k).at(j)){
                    count++;
                    k = matrix.size();}
                else
                    k = matrix.size();
            }
            if(count == 0)
                count++;
            std::cout << "Bottom: " << count << std::endl;
            scenic *= count;
            count = 0;
            for (int k = j-1; k >= 0; k--)
            {
                if (tree > matrix.at(i).at(k))
                    count++;
                else if (tree == matrix.at(k).at(j)){
                    count++;
                    k = 0;}
                else if (tree < matrix.at(k).at(j)){
                    count++;
                    k = 0;}
                else
                    k = 0;
            }
            if(count == 0)
                count++;
            std::cout << "Left: " << count << std::endl;
            scenic *= count;
            count = 0;
            for (size_t k = j+1; k < matrix.at(i).size(); k++)
            {
                if (tree > matrix.at(i).at(k))
                    count++;
                else if (tree == matrix.at(k).at(j)){
                    count++;
                    k = matrix.at(i).size();}
                else if (tree > matrix.at(k).at(j)){
                    count++;
                    k = matrix.at(i).size();}
                else
                    k = matrix.at(i).size();      
            }
            if(count == 0)
                count++;
            std::cout << "Right: " << count << std::endl;
            scenic *= count;
            scenic_score.push_back(scenic);
            std::cout << scenic << std::endl;
            std::cout << "=================" << std::endl;
        }
    }
    for (auto k:scenic_score)
    std::cout << k << std::endl;
    std::cout <<*std::max_element(scenic_score.begin(), scenic_score.end()) << std::endl;
    return 0;
}