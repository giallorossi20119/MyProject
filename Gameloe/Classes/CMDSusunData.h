//
//  CMDSusunData.h
//  IndoGame
//
//  Created by Rainy on 10/7/14.
//
//

#ifndef __IndoGame__CMDSusunData__
#define __IndoGame__CMDSusunData__

#include <iostream>
#include "cocos2d.h"
#include "PlayerData.h"

class SSCMDGameData
{
public:
    SSCMDGameData();
    ~SSCMDGameData();
	long   m_iIndex;
    long   m_dStartSFSID;
    long   m_iNOPlayers;
    long   m_iTime;
    long   m_iTimeRemain;
    bool   m_bPlaying;
    bool   m_bMod;
    bool   m_bSpec;
    bool   m_bReconnect;
    std::vector<int> m_vSortedSfsIds;
};

class SSCMDStartData
{
public:
    SSCMDStartData();
    ~SSCMDStartData();
    double m_dStartId;
    long   m_iTime;
    int    m_aCards[13];
};

class SSCMDSortedFinishData
{
public:
    SSCMDSortedFinishData();
    ~SSCMDSortedFinishData();
    double m_dUId;
    bool   m_bSortFinish;
    bool   m_bBinhlung;
};

class SSCMDMaubinhData
{
public:
    SSCMDMaubinhData();
    ~SSCMDMaubinhData();
    double m_dSFSId;
    long   m_iType;
};

class SSCMDUserEndData
{
public:
    SSCMDUserEndData();
    ~SSCMDUserEndData();
    double m_dSFSId;
    long   m_iIndex;
    long   m_iCardListType;
    int    m_aTypesCard[3];
    int    m_aCards[13];
	int	   m_iMauBinh;
};

class SSCMDUserEndViewData
{
public:
    SSCMDUserEndViewData();
    ~SSCMDUserEndViewData();
    string m_sName;
    string m_sDes;
    double m_dMoneyReal;
    double m_dUid;
    double m_dMoneyChanged;
    long   m_iIndex;
};

class SSCMDUserResumeData
{
public:
    SSCMDUserResumeData();
    ~SSCMDUserResumeData();
    SSCMDGameData* m_cGameData;
    PlayerData* m_pUserReconnect;
    vector<double> m_vFinishSortedUsers;
    double m_dUserStartId;
    double m_dMoneyGa;
    long m_iBet;
    long m_iTime;
    long m_iTimeRemain;
    long m_iNumGa;
    bool m_bAt;
    bool m_bSpec;
    bool m_bPlaying;
};

class SSCMDRenewData
{
public:
    SSCMDRenewData();
    ~SSCMDRenewData();
    long m_iOldSFSId;
    long m_iNewSFSId;
};

class SSCMDConfigData
{
public:
    SSCMDConfigData();
    ~SSCMDConfigData();
    long m_iTime;
    long m_iStake;
};

class SSCMDCompareEndData
{
public:
	SSCMDCompareEndData(){};
	~SSCMDCompareEndData(){};
	long idx1;
	long idx2;
	vector<long> m_vSoChi;
};

class SSCMDSapEndData
{
public:
	SSCMDSapEndData(){};
	~SSCMDSapEndData(){};
	long sfsID;
	bool xinthuacalang;
	bool thangcalang;
	bool thuacalang;
};

class SSCMDEndGameData
{
public:
	SSCMDEndGameData(){};
	~SSCMDEndGameData(){};
	vector<SSCMDUserEndData*>* m_vUsersEndData;
	vector<SSCMDCompareEndData*>* m_vCompareEndData;
	vector<SSCMDSapEndData*>* m_vSapEndData;
};
#endif /* defined(__IndoGame__CMDSusunData__) */