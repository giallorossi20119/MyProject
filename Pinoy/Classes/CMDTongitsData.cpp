#include "CMDTongitsData.h"

CMDWaitingDataT::CMDWaitingDataT()
{
    m_sName = "";
    m_dId    = 0u;
    m_dMoney = 0u;
    m_iSfsId = 0;;
    m_iLevel = 0;
    m_iTotal = 0;
    m_iWin = 0;
}
CMDWaitingDataT::~CMDWaitingDataT()
{}

CMDKillDataT::CMDKillDataT()
{
    m_dKillId = 0;;
    m_dDeadId = 0;
    m_iMoneyChanged = 0;
}

CMDKillDataT::~CMDKillDataT()
{
}

CMDInvitationDataT::CMDInvitationDataT()
{
    m_sName = "";
    m_sTableName = "";
    m_dMoney = 0u;
    m_iLevel = 0;
    m_dId = 0;
    m_iCuoc = 0;
    m_iTime = 0;
}

CMDInvitationDataT::~CMDInvitationDataT()
{
}

CMDFinishDataT::CMDFinishDataT()
{
    m_sName         = "";
    m_sDesc         = "";
    m_vPhom         = new  std::vector<short>();
    m_vQue          = new  std::vector<short>();
    m_vMes          = new  std::vector<short>();
    m_vLogs         = new  std::vector<std::string>();
    m_vPoints       = new std::vector<short>();
    m_vCardId       = new std::vector<int>();
    m_bU            = false;
    m_bBao          = false;
    m_bWin          = false;
    m_dMoney        = 0;
    m_sPoint        = 0;
    m_sCalculate    = 0;
    
    m_sRangePhom    = 0;
    m_sRangeQue     = 0;
    m_sRangeMes     = 0;
}

CMDFinishDataT::~CMDFinishDataT()
{
}

CMDSetDataT::CMDSetDataT()
{
    m_dNextTurnId = 0;
    m_iCuoc = 0;
    m_iTime = 0;
    m_iType = 0;
    m_sState = 0;
    m_iTimeTurnRemain = 0;
    m_bPlaying   = false;
    m_bReconnect = false;
    m_bSpectator = false;
    m_vCardId    = new std::vector<short>();
}

CMDSetDataT::~CMDSetDataT()
{
    m_vCardId->clear();
    CC_SAFE_DELETE(m_vCardId);
}

CMDStartGameDataT::CMDStartGameDataT()
{
    m_dNextTurnId   = 0;
    m_dIgnoreTurnId = 0;
}

CMDStartGameDataT::~CMDStartGameDataT()
{
    
}

CMDReconnectDataT::CMDReconnectDataT()
{
    m_sMsg = "";
    m_sTableName = "";
}

CMDReconnectDataT::~CMDReconnectDataT()
{
}

CMDSettingInGameT::CMDSettingInGameT()
{
    stake = 0;
    times = 0;
}


CMDSettingInGameT::~CMDSettingInGameT()
{
}

CMDRankDataT::CMDRankDataT()
{
    m_uExp = 0;
    m_uMoney = 0;
    m_dId = 0;
    m_uLevel = 0;
    m_uName = "";
}


CMDRankDataT::~CMDRankDataT()
{
}

CMDMinMaxStakeT::CMDMinMaxStakeT()
{
    minStake = 0;
    maxStake = 0;
}


CMDMinMaxStakeT::~CMDMinMaxStakeT()
{
}

CMDDataStringT::CMDDataStringT()
{
    str = "";
}


CMDDataStringT::~CMDDataStringT()
{
}

CMD2RankT::CMD2RankT()
{
}

CMDFireCardDataT::CMDFireCardDataT()
{
    m_dNextTurnId      = 0;
    m_dUserFireId      = 0;
    m_sNOCards         = 0;
    m_iCardType        = 0;
    m_sNORemainCards   = 0;
    m_vCardId          = new std::vector<int>();
}

CMDFireCardDataT::~CMDFireCardDataT()
{
    m_vCardId->clear();
    CC_SAFE_DELETE(m_vCardId);
}

CMDDropCardDataT::CMDDropCardDataT()
{
    m_vCardIdDrop       = new std::vector<int>();
    m_vCardIdPhom1      = new std::vector<int>();
    m_vCardIdPhom2      = new std::vector<int>();
    m_vCardIdPhom3      = new std::vector<int>();
    m_vCardIdPhom4      = new std::vector<int>();
    
    m_iIdPlayerDropInt  = 0;
    m_dIdPlayerDrop     = 0;
    m_sPhom             = 0;
    m_sTotalPhom        = 0;
    m_sNumberCardDrop   = 0;
    m_sTotalCardInHand  = 0;
}

CMDDropCardDataT::~CMDDropCardDataT()
{
    
}

CMDSendCardDataT::CMDSendCardDataT()
{
    m_dIdGui            = 0;
    m_dIdNhan           = 0;
    m_sidCard           = 0;
    m_sidPhom           = 0;
}

CMDSendCardDataT::~CMDSendCardDataT()
{
    
}

CMD2RankT::~CMD2RankT()
{
}

CMDUserDataT::CMDUserDataT()
{
    m_dUID = 0;
}

CMDUserDataT::~CMDUserDataT()
{
}
