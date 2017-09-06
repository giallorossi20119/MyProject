#include "CMDSusunData.h"

SSCMDGameData::SSCMDGameData()
{
	m_iIndex = -1;
    m_dStartSFSID   = 0;
    m_bPlaying = 0;
    m_iNOPlayers = 0;
    m_iTime = 0;
    m_iTimeRemain = 0;
    m_bMod     = false;
    m_bSpec    = false;
    m_bReconnect = false;
}

SSCMDGameData::~SSCMDGameData()
{
}

SSCMDStartData::SSCMDStartData()
{
    m_dStartId = 0;
    m_iTime    = 0;
    for(int i = 0; i < 13; i++)
    {
        m_aCards[i] = 0;
    }
}

SSCMDStartData::~SSCMDStartData()
{
}

SSCMDSortedFinishData::SSCMDSortedFinishData()
{
    m_dUId = 0;
    m_bSortFinish = false;
    m_bBinhlung = false;
}

SSCMDSortedFinishData::~SSCMDSortedFinishData()
{
}

SSCMDMaubinhData::SSCMDMaubinhData()
{
    m_dSFSId = 0;
    m_iType = 0;
}

SSCMDMaubinhData::~SSCMDMaubinhData()
{
}

SSCMDUserEndData::SSCMDUserEndData()
{
    m_dSFSId = 0;
    m_iIndex = 0;
    m_iCardListType = 0;
    m_aTypesCard[3] = {};
    m_aCards[13] = {};
}

SSCMDUserEndData::~SSCMDUserEndData()
{
}

SSCMDUserEndViewData::SSCMDUserEndViewData()
{
    m_sName = "";
    m_sDes = "";
    m_dUid = 0;
    m_dMoneyChanged = 0;
    m_dMoneyReal = 0;
}

SSCMDUserEndViewData::~SSCMDUserEndViewData()
{
}

SSCMDUserResumeData::SSCMDUserResumeData()
{
    m_pUserReconnect = new PlayerData();
}

SSCMDUserResumeData::~SSCMDUserResumeData()
{
}

SSCMDRenewData::SSCMDRenewData()
{
    m_iOldSFSId = 0;
    m_iNewSFSId = 0;
}

SSCMDRenewData::~SSCMDRenewData()
{
}

SSCMDConfigData::SSCMDConfigData()
{
    m_iTime = 0;
    m_iStake = 0;
}

SSCMDConfigData::~SSCMDConfigData()
{
}

