//
//  GlobalVariable.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__GlobalVariable__
#define __IndoGame__GlobalVariable__

#include <iostream>
#include "PlayerData.h"
#include <vector>
#include "GameServerData.h"
#include "Constant.h"
#include "Singleton.h"
#include "AdBar.h"
#include "UserInfo.h"
#include "SettingCom.h"
#include "TableData.h"
#include "MsgConst.h"
#include "CMDBantingData.h"
#include "CMDSusunData.h"
#include "CMDTongitsData.h"
#include "spine/skeletonAnimation.h"

class SettingCom;
USING_NS_STD;

class GlobalVariable :public Singleton<GlobalVariable>
{
public:
    static vector<GameServerData*>* m_vGameServerData;
    static vector<TableData*>*      m_vTableData;
    static vector<PlayerData*>*     m_vPlayers;
    static vector<PlayerData*>*		m_vPlayersSorted;
    static vector<Card*>*           m_vFiredCards;
    static vector<CMDDropCardDataT*>*m_vCMDDropCardData;
    static PlayerData*              m_pUser;
    static AdBar* 					m_pAdBar;
	static UserInfo*				m_pUserInfo;
	static SettingCom*		        m_pSettingCom;
    static CMDSetData*              m_cSetData;
    static CMDSetDataT*             m_cSetDataT;
    static SSCMDGameData*           m_startGameData;
    static string                   m_sSID;
    static string                   m_sDomain;
    static string                   m_sWaitRoomName;
    static int                      m_iGameWidth;
    static int                      m_iGameHeight;
    static int                      m_iCurrentLanguage;
    static int                      m_iCurrentGame;
    static int                      m_iCurrentZone;
    static int                      m_iCurrentRoom;
    static int                      m_iCurrentTable;
    static int                      m_iTotalFiredCard;
    static int                      m_iTotalPhom;
    static int                      m_iTotalCardinHand;
    static int                      m_iDeckNo;
    static bool                     m_bResourceLoaded;
	static bool						m_bMute;
	static bool						m_bLogout;
	static bool						m_bBackToLobby;
    static bool						m_bBackToChooseGame;
	static bool					    m_bFirstLoad;
    static bool                     m_bCanU;
    static bool                     m_bAlreadyGetCard;
    static bool                     m_bCanEat;
    static bool                     m_bCanDraw;
    static short                    m_sPhomDistance;
    static double                   m_dIdPlayerStart;
    static int                      m_bMe;
    //const
	static std::string				m_sRegisterUrl;
	static std::string				m_sLoginUrl;
	static std::string 				m_sProxyLoginUrl;
	static std::string				m_sFacebookLogin;
	static std::string				m_sAppPackage;
	static std::string				m_sLanguagesData;
    static std::string              m_sPopupMessage;
    //social
    static std::string              m_sFacebookToken;
	//static CMDMinMaxStake*			m_MinMaxStake;

	static rapidjson::Document		langData;
	static MsgConst*				msgConst;
	static vector<CMDFinishData*>*  m_vCMDFinishData;
    static vector<CMDFinishDataT*>* m_vCMDFinishDataT;
    static int                      m_iReconnectCount;
    static std::string              m_sTableName;
    static int                      m_iPingCount;
    static int                      m_bSpectator;
    static CMDMinMaxStake*          m_pDataMinMaxStake;
    static vector<SSCMDUserEndViewData*>*  m_vSSCMDUserEndViewData;
    static bool                     m_bInviteOn;
    static bool                     m_bGameRestarted;
    static bool                     m_bWasKicked;
    static bool                     m_bWasKickedIdle;
    static double                   m_dLastSecond;
    static double                   m_dCurrentSecond;
    static spine::SkeletonAnimation* m_skeletonNode;
    static short                    m_sDevice;
    static short                    m_sPot;
    static std::string              m_sCurrentVersion;
    static bool                     m_bHasNewVersion;
    static bool                     m_bRequestLogout;
    static std::string              m_sMessageId;
    static std::string              m_sInreview;
    static std::string              m_sUserFacebookID;
    static std::string              m_sDeviceID;
    static int                      m_iAccountMode;
    
    static bool                     m_bMaubinhCheck;
    static bool                     m_bDontShowMsg;
    
    static bool                     m_bPing;
    static bool                     m_bDebug;
    static bool                     m_bDoubleLogin;
    static CMDMinMaxStakeT*         m_pDataMinMaxStakeT;
    static std::string              m_sAppIDPurchase;
    static std::string              m_sMoneyPurchase;
    static bool                     m_bWasBonusStarup;
    static std::string              m_sMessage;
    static bool                     m_bWasDailyBonus;
    static CMDDailyBonusData*       m_cmdDailyBonusData;
    static bool                     m_bOutofMoney;
    static bool                     m_bSusunWin;
};
#endif /* defined(__IndoGame__GlobalVariable__) */
