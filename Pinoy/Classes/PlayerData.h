//
//  PlayerData.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__PlayerData__
#define __IndoGame__PlayerData__

#include <iostream>
#include "cocos2d.h"
#include "SmartFox.h"
#include "Card.h"

class PlayerData
{
public:
    PlayerData();
    ~PlayerData();
    
    std::string  m_sName;
    double       m_dMoney;
    double       m_dMoneyTour;
    double       m_dId;
    long         m_iIndex;
    long         m_iSfsId;
    long         m_iLevel;
    long         m_iExp;
    long         m_iWin;
    long         m_iLose;
    long         m_iTotal;
    long         m_iType;
    long         m_iRank;
    long         m_iPlatform;
    bool         m_bMobile;
    short        m_sDevice;
    //susun
    long m_iTypeMB;
    int m_aCards[13];
    // play
    vector<Card*>* m_vCard;
    vector<int>*   m_vCardId;
    std::string    m_sIP;
    int            m_iPlayerArea;
    short          m_sChairId;
    short          m_sType2;
    short          m_sLevel2;
    short          m_iRemainCards;
    bool           m_bHost;
    bool           m_bTurn;
    bool           m_bPlaying;

    void parseFromByteData(boost::shared_ptr<ByteArray> btr);
    void parseFromByteData2(boost::shared_ptr<ByteArray> btr);
};
#endif /* defined(__IndoGame__PlayerData__) */
