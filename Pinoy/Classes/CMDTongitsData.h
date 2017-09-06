#ifndef __IndoGame__CMDTongitsData__
#define __IndoGame__CMDTongitsData__

#include <iostream>
#include <vector>
#include "cocos2d.h"
class CMDWaitingDataT
{
public:
    CMDWaitingDataT();
    ~CMDWaitingDataT();
    std::string m_sName;
    double m_dId;
    double m_dMoney;
    long m_iSfsId;
    long m_iLevel;
    long m_iTotal;
    long m_iWin;
};

class CMDKillDataT
{
public:
    CMDKillDataT();
    ~CMDKillDataT();
    double m_dKillId;
    double m_dDeadId;
    long m_iMoneyChanged;
};

class CMDInvitationDataT
{
public:
    CMDInvitationDataT();
    ~CMDInvitationDataT();
    std::string m_sName;
    std::string m_sTableName;
    double m_dId;
    double m_dMoney;
    long m_iLevel;
    long m_iCuoc;
    long m_iTime;
};

class CMDFinishDataT
{
public:
    CMDFinishDataT();
    ~CMDFinishDataT();
    std::string     m_sName;
    std::string     m_sDesc;
    std::vector<short>*   m_vPhom;
    std::vector<short>*   m_vQue;
    std::vector<short>*   m_vMes;
    std::vector<std::string>* m_vLogs;
    std::vector<short>* m_vPoints;
    std::vector<int>* m_vCardId;
    bool            m_bU;
    bool            m_bBao;
    bool            m_bWin;
    double          m_dMoney;
    short           m_sPoint;
    short           m_sRangePhom;
    short           m_sRangeQue;
    short           m_sRangeMes;
    short           m_sCalculate;
};

class CMDSetDataT
{
public:
    CMDSetDataT();
    ~CMDSetDataT();
    std::vector<short>*        m_vCardId;
    double m_dNextTurnId;
    short m_sState;
    long m_iCuoc;
    long m_iTime;
    long m_iType;
    long m_iTimeTurnRemain;
    bool m_bPlaying;
    bool m_bReconnect;
    bool m_bSpectator;
};

class CMDStartGameDataT
{
public:
    CMDStartGameDataT();
    ~CMDStartGameDataT();
    double m_dNextTurnId;
    double m_dIgnoreTurnId;
};

class CMDFireCardDataT
{
public:
    CMDFireCardDataT();
    ~CMDFireCardDataT();
    std::vector<int>*        m_vCardId;
    double                   m_dNextTurnId;
    double                   m_dUserFireId;
    short                    m_iCardType;
    short                    m_sNOCards;
    short                    m_sNORemainCards;
    
};

class CMDDropCardDataT
{
public:
    CMDDropCardDataT();
    ~CMDDropCardDataT();
    std::vector<int>*       m_vCardIdDrop;
    std::vector<int>*       m_vCardIdPhom1;
    std::vector<int>*       m_vCardIdPhom2;
    std::vector<int>*       m_vCardIdPhom3;
    std::vector<int>*       m_vCardIdPhom4;
    int                     m_iIdPlayerDropInt;
    double                  m_dIdPlayerDrop;
    short                   m_sPhom;
    short                   m_sTotalPhom;
    short                   m_sNumberCardDrop;
    short                   m_sTotalCardInHand;
};

class CMDSendCardDataT
{
public:
    CMDSendCardDataT();
    ~CMDSendCardDataT();
    double                  m_dIdGui;
    double                  m_dIdNhan;
    short                   m_sidCard;
    short                   m_sidPhom;
};

class CMDReconnectDataT
{
public:
    CMDReconnectDataT();
    ~CMDReconnectDataT();
    std::string m_sMsg;
    std::string m_sTableName;
};

class CMDSettingInGameT
{
public:
    CMDSettingInGameT();
    ~CMDSettingInGameT();
    
    long stake;
    long times;
};

class CMDRankDataT
{
public:
    CMDRankDataT();
    ~CMDRankDataT();
    
    std::string m_uName;
    double m_dId;
    long m_uLevel;
    double m_uMoney;
    long m_uExp;
};


class CMDMinMaxStakeT
{
public:
    CMDMinMaxStakeT();
    ~CMDMinMaxStakeT();
    
    long minStake;
    long maxStake;
};

class CMDDataStringT
{
public:
    CMDDataStringT();
    ~CMDDataStringT();
    
    std::string str;
};

class CMD2RankT
{
public:
    CMD2RankT();
    ~CMD2RankT();
    
    std::vector<CMDRankDataT*>* m_pVecM;
    std::vector<CMDRankDataT*>* m_pVecE;
};

class CMDUserDataT
{
public:
    CMDUserDataT();
    ~CMDUserDataT();
    double m_dUID;
};
#endif /*

defined(__IndoGame__CMDTongitsData__) */
