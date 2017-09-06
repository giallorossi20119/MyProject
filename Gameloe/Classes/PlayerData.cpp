//
//  PlayerData.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "PlayerData.h"

PlayerData::PlayerData()
{
    m_sName = "";
    m_iSfsId = 0;
    m_dId    = 0;
    m_dMoney = 0u;
    m_iLevel = 0;
    m_iExp   = 0;
    m_iWin   = 0;
    m_iLose  = 0;
    m_iTotal = 0;
    m_iType  = 0;
    m_iRank  = 0;
    m_bMobile = false;
    m_bTurn   = false;
    m_sChairId= 0;
    m_bHost   = false;
    m_sType2  = 0;
    m_sLevel2 = 0;
    m_bPlaying = false;
    m_iPlayerArea = 0;
    m_iRemainCards = 13;
    m_vCard   = new vector<Card*>();
    m_vCardId = new vector<int>();
    m_iIndex = 0;
    m_sDevice = 0;
}
PlayerData::~PlayerData()
{
}
void PlayerData::parseFromByteData(boost::shared_ptr<ByteArray> btr)
{
    btr->ReadUTF(m_sName);
    CCLOG("parseFromByteData %s", m_sName.c_str());
    btr->ReadDouble(m_dMoney);
    btr->ReadDouble(m_dId);
    btr->ReadInt(m_iExp);
    btr->ReadInt(m_iLevel);
    btr->ReadInt(m_iTotal);
    btr->ReadInt(m_iWin);
    btr->ReadInt(m_iType);
}

void PlayerData::parseFromByteData2(boost::shared_ptr<ByteArray> btr)
{
    btr->ReadUTF(m_sName);
    btr->ReadInt(m_iSfsId);
    btr->ReadDouble(m_dId);
    btr->ReadDouble(m_dMoney);
    btr->ReadShort(m_sChairId);
    if(m_sChairId == 0)
    {
        m_bHost = true;
    }
    btr->ReadUTF(m_sIP);
    btr->ReadShort(m_sLevel2);
    btr->ReadBool(m_bMobile);
    if(m_bMobile)
    {
        btr->ReadShort(m_sDevice);
    }
    btr->ReadShort(m_sType2);
}
