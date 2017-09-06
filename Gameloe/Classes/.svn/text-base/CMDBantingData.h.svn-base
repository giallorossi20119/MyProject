//
//  CMDBantingData.h
//  IndoGame
//
//  Created by Rainy on 10/10/14.
//
//

#ifndef __IndoGame__CMDBantingData__
#define __IndoGame__CMDBantingData__

#include <iostream>
#include <vector>
#include "cocos2d.h"
class CMDWaitingData
{
public:
    CMDWaitingData();
    ~CMDWaitingData();
    std::string m_sName;
    double m_dId;
    double m_dMoney;
    long m_iSfsId;
    long m_iLevel;
    long m_iTotal;
    long m_iWin;
};

class CMDKillData
{
public:
    CMDKillData();
    ~CMDKillData();
    double m_dKillId;
    double m_dDeadId;
    long m_iMoneyChanged;
};

class CMDInvitationData
{
public:
    CMDInvitationData();
    ~CMDInvitationData();
    std::string m_sName;
    std::string m_sTableName;
    double m_dId;
    double m_dMoney;
    long m_iLevel;
    long m_iCuoc;
    long m_iTime;
};

class CMDFinishData
{
public:
    CMDFinishData();
    ~CMDFinishData();
    std::string     m_sName;
    std::string     m_sDesc;
    std::vector<short>*   m_vCardsIdRemain;
    double          m_dMoney;
    double          m_dChangeMoney;
    double          m_dId;
    short           m_sLevel;
    short           m_sRank;
    short           m_sCardsRemain;
    bool            m_bwin;
    bool            m_bTypeEnd;
};

class CMDSetData
{
public:
    CMDSetData();
    ~CMDSetData();
    std::vector<short>*        m_vCardId;
    double m_dNextTurnId;
    long m_iCuoc;
    long m_iTime;
    long m_iType;
    long m_iTimeTurnRemain;
    bool m_bPlaying;
    bool m_bReconnect;
    bool m_bSpectator;
};

class CMDIgnoreCardData
{
public:
    CMDIgnoreCardData();
    ~CMDIgnoreCardData();
    double m_dNextTurnId;
    double m_dIgnoreTurnId;
};

class CMDFireCardData
{
public:
    CMDFireCardData();
    ~CMDFireCardData();
    std::vector<int>*        m_vCardId;
    double                   m_dNextTurnId;
    double                   m_dUserFireId;
    short                    m_iCardType;
    short                    m_sNOCards;
    short                    m_sNORemainCards;

};

class CMDReconnectData
{
public:
    CMDReconnectData();
    ~CMDReconnectData();
    std::string m_sMsg;
    std::string m_sTableName;
};

class CMDSettingInGame
{
public:
	CMDSettingInGame();
	~CMDSettingInGame();

	long stake;
	long times;
};

class CMDRankData
{
public:
	CMDRankData();
	~CMDRankData();

	std::string m_uName;
	double m_dId;
	long m_uLevel;
	double m_uMoney;
	long m_uExp;
};


class CMDMinMaxStake
{
public:
	CMDMinMaxStake();
	~CMDMinMaxStake();

	long minStake;
	long maxStake;
};

class CMDDataString
{
public:
	CMDDataString();
	~CMDDataString();

	std::string str;
};

class CMD2Rank
{
public:
	CMD2Rank();
	~CMD2Rank();

	std::vector<CMDRankData*>* m_pVecM;
	std::vector<CMDRankData*>* m_pVecE;
};

class CMDUserData
{
public:
    CMDUserData();
    ~CMDUserData();
    double m_dUID;
};
#endif /* 

defined(__IndoGame__CMDBantingData__) */
