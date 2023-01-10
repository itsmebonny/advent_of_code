#include <vector>
#include <map>
#include <string>
#include <set>
#include <iostream>
#include <array>
#include <algorithm>
#include <cmath>
#include <deque>
class Monkey
{
private:
    int id;
    std::deque<int> items;
    std::string operation;
    int test;
    int test_true;
    int test_false;
public:
    Monkey() = default;
    Monkey(int i,std::deque<int> it,  std::string op,int t, int t_true, int t_false):id(i), items(it), operation(op), test(t), test_true(t_true), test_false(t_false){};
    void pop_front(){
        items.pop_front();
    }
    std::string get_operation(){return operation;}
    int get_test(){return test;}
    int get_id(void){
        return id;
    }
    void push_back(int item){
        items.push_back(item);
    }

    void update_holding (void){
        if (operation.substr(0,3) == "mul"){
            if(operation.substr(4,3) == "old")
                items.at(0) *= items.at(0);
            else
                items.at(0) *= std::stoi(operation.substr(4));
        }
        else{
            if(operation.substr(4,3) == "old")
                items.at(0) += items.at(0);
            else
                items.at(0) += std::stoi(operation.substr(4));
        }
        items.at(0)/3;
    }
    int yes(){return test_true;}
    int no(){return test_false;}
    void throw_item(int item, Monkey m){
        pop_front();
        m.push_back(item);
    }
    int get_size(){
        return items.size();
    }
    int get_item(int id){
        return items.at(id);
    }
    bool check(){
        int item = items.at(0);
        return item % test == 0;
    }
    void print(void){
        std::cout <<"Monkey: " << id << std::endl;
        std::cout << "Items: ";
        for(auto k: this->items)
            std::cout << k << " ";
        std::cout << std::endl;
        std::cout <<"Operation: " << operation << std::endl;
        std::cout <<"Check divisible by: " << test << std::endl;
        std::cout <<"if true -> " << test_true << std::endl;
        std::cout <<"if false -> " << test_false << std::endl;
    }
    std::deque<int> get_deque(){return items;}
    bool operator<(Monkey &rhs){
        return id < rhs.get_id();
    }
    Monkey operator=(Monkey &rhs){
        id = rhs.get_id();
        items = rhs.get_deque();
        operation = rhs.get_operation();
        test=rhs.get_test();
        test_true = rhs.yes();
        test_false=rhs.no();
        return *this;

    }
};
    Monkey& get_monkey(std::vector<Monkey> jungle, int id){
        Monkey res;
        for (auto i : jungle){
            if (id == i.get_id())
                res = i;
        }
        return res;
    }