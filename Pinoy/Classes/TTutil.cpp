#include "TTutil.h"
#include "AlertPopup.h"
#include "Constant.h"

namespace TTutil
{
    bool isCharacter(const char Character)
    {
        return ((Character >= 'a' && Character <= 'z') || (Character >= 'A' && Character <= 'Z'));
        //Checks if a Character is a Valid A-Z, a-z Character, based on the ascii value
    }
    bool isNumber(const char Character)
    {
        return (Character >= '0' && Character <= '9');
        //Checks if a Character is a Valid 0-9 Number, based on the ascii value
    }
    bool isValidEmailAddress(const char * EmailAddress)
    {
        if (!EmailAddress) // If cannot read the Email Address...
            return 0;
        if (!isCharacter(EmailAddress[0])) // If the First character is not A-Z, a-z
            return 0;
        int AtOffset = -1;
        int DotOffset = -1;
        unsigned int Length = strlen(EmailAddress); // Length = StringLength (strlen) of EmailAddress
        for (unsigned int i = 0; i < Length; i++)
        {
            if (EmailAddress[i] == '@') // If one of the characters is @, store it's position in AtOffset
                AtOffset = (int)i;
            else if (EmailAddress[i] == '.') // Same, but with the dot
                DotOffset = (int)i;
        }
        if (AtOffset == -1 || DotOffset == -1) // If cannot find a Dot or a @
            return 0;
        if (AtOffset > DotOffset) // If the @ is after the Dot
            return 0;
        return !(DotOffset >= ((int)Length - 1)); //Chech there is some other letters after the Dot
    }
    
    bool saveUserPassword (std::string name, std::string password)
    {
        // Try open and write file
        // Get file data path
        std::string fullFilePath = FileUtils::getInstance()->getWritablePath() + "username.json";
        
        if (!FileUtils::getInstance()->isFileExist(fullFilePath))
        {
            ofstream ofile;
            ofile.open(fullFilePath.c_str());
            ofile << "{}";
            ofile.close();
            log("file is not exist, we have to create new one");
        }
        else
        {
            log("file exist, continue");
        }
        
        // Read and get data
        std::string l_s_data = FileUtils::getInstance()->getStringFromFile(fullFilePath);
        
        // Format file data to json
        rapidjson::Document document;
        document.Parse<0>(l_s_data.c_str());
        
        // Save passed key/value pair
        if (!document.HasMember(name.c_str()))
        {
            //			document.AddMember(password.c_str(), name.c_str(), document.GetAllocator());
            document.AddMember(name.c_str(), password.c_str(), document.GetAllocator());
        }
        else
        {
            document[name.c_str()].SetString(password.c_str());
        }
        
        // Write to file again
        std::ofstream file;
        file.open(fullFilePath.c_str());
        file << "{";
        
        std::string str;
        for (rapidjson::Value::ConstMemberIterator itr = document.MemberonBegin(); itr != document.MemberonEnd(); ++itr)
        {
            str = itr->name.GetString();
            if (itr!=document.MemberonBegin())
            {
                file << ",";
            }
            file << "\"";
            file << str.c_str();
            file << "\"";
            file << ":";
            str = itr->value.GetString();
            file << "\"";
            file << str.c_str();
            file << "\"";
        }
        file << "}";
        file.close();
        return true;
    }
    
    std::string getUserPassword (std::string name)
    {
        //Try open and write file
        //Get file data path
        std::string fullFilePath = FileUtils::getInstance()->getWritablePath() + "username.json";
        if (!FileUtils::getInstance()->isFileExist(fullFilePath))
        {
            ofstream ofile;
            ofile.open(fullFilePath.c_str());
            ofile << "{}";
            ofile.close();
            log("file is not exist, we have to create new one");
        }
        else
        {
            log("file exist, continue");
        }
        
        // Read and get data
        std::string l_s_data = FileUtils::getInstance()->getStringFromFile(fullFilePath);
        
        // Format file data to json
        rapidjson::Document document;
        document.Parse<0>(l_s_data.c_str());
        
        // return username if has
        const char* key = name.c_str();
        if (document.HasMember(key))
        {
            return document[key].GetString();
        }
        return "";
    }
    
    std::string getLastUserLogin()
    {
        // Try open and write file
        // Get file data path
        std::string fullFilePath = FileUtils::getInstance()->getWritablePath() + "username.json";
        if (!FileUtils::getInstance()->isFileExist(fullFilePath))
        {
            ofstream ofile;
            ofile.open(fullFilePath.c_str());
            ofile << "{}";
            ofile.close();
            log("file is not exist, we have to create new one");
        }
        else
        {
            log("file exist, continue");
        }
        
        // Read and get data
        
        std::string l_s_data = FileUtils::getInstance()->getStringFromFile(fullFilePath);
        
        // Format file data to json
        rapidjson::Document document;
        document.Parse<0>(l_s_data.c_str());
        
        // return username if has
        const char* key = "the_last_name";
        if (document.HasMember(key))
        {
            return document[key].GetString();
        }
        return "";
    }
    
    void saveLastUserLogin(std::string name)
    {
        //Try open and write file
        //Get file data path
        std::string fullFilePath = FileUtils::getInstance()->getWritablePath() + "username.json";
        if (!FileUtils::getInstance()->isFileExist(fullFilePath))
        {
            ofstream ofile;
            ofile.open(fullFilePath.c_str());
            ofile << "{}";
            ofile.close();
            log("file is not exist, we have to create new one");
        }
        else
        {
            log("file exist, continue");
        }
        
        //Read and get data
        std::string l_s_data = FileUtils::getInstance()->getStringFromFile(fullFilePath);
        
        //Format file data to json
        rapidjson::Document document;
        document.Parse<0>(l_s_data.c_str());
        
        //return username if has
        const char* key = "the_last_name";
        //Save passed key/value pair
        if (!document.HasMember(key))
        {
            document.AddMember(key, name.c_str(), document.GetAllocator());
        }
        else
        {
            document[key].SetString(name.c_str());
        }
        
        //Write to file again
        std::ofstream file;
        file.open(fullFilePath.c_str());
        file << "{";
        
        std::string str;
        for (rapidjson::Value::ConstMemberIterator itr = document.MemberonBegin(); itr != document.MemberonEnd(); ++itr)
        {
            str = itr->name.GetString();
            if (itr!=document.MemberonBegin())
            {
                file << ",";
            }
            file << "\"";
            file << str.c_str();
            file << "\"";
            file << ":";
            str = itr->value.GetString();
            file << "\"";
            file << str.c_str();
            file << "\"";
        }
        file << "}";
        file.close();
    }
    
    string addDot(string str)
    {
        string tmp = str;
        int i = 3;
        while(i < tmp.length())
        {
            tmp.insert(tmp.length() - i, ".");
            i = i + 3 + 1;
        }
        return tmp;
    }
    
    string addSemi(string str)
    {
        string tmp = str;
        int i = 3;
        while(i < tmp.length())
        {
            tmp.insert(tmp.length() - i, ",");
            i = i + 3 + 1;
        }
        return tmp;
    }
    
    const int EXP_BOUNDS[] = {-1, 20, 100, 200, 500, 1000, 2000, 4000, 8000, 13000, 20000, 30000, 45000, 60000, 80000, 100000, 130000, 160000, 200000, 250000, 300000, 360000, 440000, 540000, 660000, 800000, 960000, 1140000, 1340000, 1560000, 1800000, 2100000, 2500000, 3100000, 3800000, 4800000, 6300000, 8000000, 10000000, 13000000, 17000000, 23000000, 30000000, 40000000, 55000000, 72000000, 92000000, 122000000, 222000000, 292000000};
    
    int getPercentFormExp(int _exp)
    {
        for  (int i = 1; i < 50; i++)
        {
            if  ((EXP_BOUNDS[i-1] <= _exp) && (_exp < EXP_BOUNDS[i]))
            {
                int percent = round((float)(_exp - EXP_BOUNDS[i-1]) / (EXP_BOUNDS[i] - EXP_BOUNDS[i-1]) * 100);;
                return percent;
            }
        }
        return 0;
    }
    
    double getCurrentSecond()
    {
        struct timeval tp;
        gettimeofday(&tp, NULL);
        long long mslong = (long long) tp.tv_sec * 1000L + tp.tv_usec / 1000; //get current timestamp in milliseconds
        //std::cout << mslong << std::endl;
        return mslong;
    }
    
    string convertKMB(double dMoney)
    {
        string str = addDot(ccsf("%1.0f", dMoney));
        double hight = 0;
        int low = 0;
        if(dMoney < 1000) //999
        {
            str = ccsf("%1.0f", dMoney);
        }
        else if(dMoney >= 1000 && dMoney < 1000000)//999.999
        {
            hight = dMoney / 1000;
            low = (long long)dMoney % 1000;
            if( low / 10 == 0)
            {
                str = ccsf("%1.0fK", hight);
            }
            else
            {
                str = ccsf("%1.0f.%dK", hight, low / 10);
            }
        }
        else if(dMoney >= 1000000 && dMoney < 1000000000)//999.999.999
        {
            hight = dMoney / 1000000;
            low = (long long)dMoney % 1000000;
            if( low / 10000 == 0)
            {
                str = ccsf("%1.0fM", hight);
            }
            else
            {
                str = ccsf("%1.0f.%dM", hight, low / 10000);
            }
        }
        else if(dMoney >= 1000000000 && dMoney < 1000000000000)//999.999.999.999
        {
            hight = dMoney / 1000000000;
            low = (long long)dMoney % 1000000000;
            if( low / 10000000 == 0)
            {
                str = ccsf("%1.0fB", hight);
            }
            else
            {
                str = ccsf("%1.0f.%dB", hight, low / 10000000);
            }
        }
        
        return str;
    }
};


