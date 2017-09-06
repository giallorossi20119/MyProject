//
//  MsgConst.h
//  IndoGame
//
//  Created by longnh on 9/24/14.
//
//

#ifndef IndoGame_MsgConst_h
#define IndoGame_MsgConst_h

#include <iostream>
#include <vector>
#include "cocos2d.h"
#include "Constant.h"
#include "CMDErrorData.h"
class MsgConst
{
public:
	MsgConst();
	~MsgConst();

	std::string getMsg(const char* key, std::vector<std::string>*  params);
    void getMsgParams(CMDErrorData* pCMDErrorData, std::string& key, std::vector<std::string>*& params);
	std::string getCurMsg(const char* key);

};

#endif
