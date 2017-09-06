#include "CMDBantingData.h"

CMDWaitingData::CMDWaitingData()
{
    m_sName = "";
    m_dId    = 0u;
    m_dMoney = 0u;
    m_iSfsId = 0;;
    m_iLevel = 0;
    m_iTotal = 0;
    m_iWin = 0;
}
CMDWaitingData::~CMDWaitingData()
{}

CMDKillData::CMDKillData()
{
    m_dKillId = 0;;
    m_dDeadId = 0;
    m_iMoneyChanged = 0;
}

CMDKillData::~CMDKillData()
{
}

CMDInvitationData::CMDInvitationData()
{
    m_sName = "";
    m_sTableName = "";
    m_dMoney = 0u;
    m_iLevel = 0;
    m_dId = 0;
    m_iCuoc = 0;
    m_iTime = 0;
}

CMDInvitationData::~CMDInvitationData()
{
}

CMDFinishData::CMDFinishData()
{
    m_sName         = "";
    m_sDesc         = "";
    m_vCardsIdRemain = new  std::vector<short>();
    m_dId           = 0;
    m_dMoney        = 0;
    m_sLevel        = 0;
    m_dChangeMoney  = 0;
    m_sCardsRemain  = 0;
    m_sRank         = 0;
    m_bTypeEnd      = false;
    m_bwin          = false;
}

CMDFinishData::~CMDFinishData()
{
}

CMDSetData::CMDSetData()
{
    m_dNextTurnId = 0;
    m_iCuoc = 0;
    m_iTime = 0;
    m_iType = 0;
    m_iTimeTurnRemain = 0;
    m_bPlaying   = false;
    m_bReconnect = false;
    m_bSpectator = false;
    m_vCardId    = new std::vector<short>();
}

CMDSetData::~CMDSetData()
{
    m_vCardId->clear();
    CC_SAFE_DELETE(m_vCardId);
}

CMDIgnoreCardData::CMDIgnoreCardData()
{
    m_dNextTurnId   = 0;
    m_dIgnoreTurnId = 0;
}
CMDIgnoreCardData::~CMDIgnoreCardData()
{
}

CMDReconnectData::CMDReconnectData()
{
    m_sMsg = "";
    m_sTableName = "";
}

CMDReconnectData::~CMDReconnectData()
{
}

CMDSettingInGame::CMDSettingInGame()
{
	stake = 0;
	times = 0;
}


CMDSettingInGame::~CMDSettingInGame()
{
}

CMDRankData::CMDRankData()
{
	m_uExp = 0;
	m_uMoney = 0;
	m_dId = 0;
	m_uLevel = 0;
	m_uName = "";
}


CMDRankData::~CMDRankData()
{
}

CMDMinMaxStake::CMDMinMaxStake()
{
	minStake = 0;
	maxStake = 0;
}


CMDMinMaxStake::~CMDMinMaxStake()
{
}

CMDDataString::CMDDataString()
{
	str = "";
}


CMDDataString::~CMDDataString()
{
}

CMD2Rank::CMD2Rank()
{
}

CMDFireCardData::CMDFireCardData()
{
    m_dNextTurnId      = 0;
    m_dUserFireId      = 0;
    m_sNOCards         = 0;
    m_iCardType        = 0;
    m_sNORemainCards   = 0;
    m_vCardId          = new std::vector<int>();
}

CMDFireCardData::~CMDFireCardData()
{
    m_vCardId->clear();
    CC_SAFE_DELETE(m_vCardId);
}

CMD2Rank::~CMD2Rank()
{
}

CMDUserData::CMDUserData()
{
    m_dUID = 0;
}

CMDUserData::~CMDUserData()
{
}