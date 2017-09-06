//
//  IAPItem.h
//  IndoGame
//
//  Created by Rainy on 3/21/15.
//
//

#ifndef __IndoGame__IAPItem__
#define __IndoGame__IAPItem__

#include <iostream>
#include "cocos2d.h"
#include "Constant.h"

USING_NS_CC;
USING_NS_STD;
class IAPItem : public Ref
{
public:
    IAPItem(){m_sID = ""; m_dCash = 0; m_dMoney = 0; m_dBonus = 0;};
    ~IAPItem(){};
    string m_sID;
    double m_dCash;
    double m_dMoney;
    double m_dBonus;
};
#endif /* defined(__IndoGame__IAPItem__) */
