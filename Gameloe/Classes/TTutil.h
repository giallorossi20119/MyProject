#include "json/document.h"
#include "cocos2d.h"
#include <iostream>
#include <fstream>
#include <istream>
#include <string>
#include "rapidjson.h"

USING_NS_CC;
using namespace std;

namespace TTutil
{
	bool isCharacter(const char Character);
	bool isNumber(const char Character);
	bool isValidEmailAddress(const char * EmailAddress);
	bool saveUserPassword (std::string name, std::string password);
	std::string getUserPassword (std::string key);
	std::string getLastUserLogin();
	void saveLastUserLogin(std::string name);
    string addDot(string str);
    string addSemi(string str);
    string convertKMB(double dMoney);
    int getPercentFormExp(int _exp);
    double getCurrentSecond();
};
