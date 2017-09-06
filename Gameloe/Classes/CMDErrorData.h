//
//  CMDErrorData.h
//  IndoGame
//
//  Created by Rainy on 8/27/14.
//
//

#ifndef __IndoGame__CMDErrorData__
#define __IndoGame__CMDErrorData__

#include <iostream>
#include "cocos2d.h"

class CMDDoubleData : public cocos2d::Ref
{
public:
    CMDDoubleData(){m_dValue = 0;};
    CMDDoubleData(double value):m_dValue(value){};
    ~CMDDoubleData(){};
    double m_dValue;
};

class CMDErrorData
{
public:
    CMDErrorData();
    ~CMDErrorData();
    std::string m_sCommand;
    std::string m_sMessage;
    bool        m_bStatus;
};

class CMDDailyBonusData
{
public:
    CMDDailyBonusData(){m_sDay = 0; m_iBonus = 0;};
    ~CMDDailyBonusData(){};
    long  m_iBonus;
    short m_sDay;
};

class CMDQuestBonusData
{
public:
    CMDQuestBonusData(){m_sNextTimeIndex = 0; m_bACP = false;};
    ~CMDQuestBonusData(){};
    short m_sNextTimeIndex;
    bool  m_bACP;
};
#endif /* defined(__IndoGame__CMDErrorData__) */
