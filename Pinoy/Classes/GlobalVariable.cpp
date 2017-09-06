//
//  GlobalVariable.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "GlobalVariable.h"

int                      GlobalVariable::m_iGameWidth       = 960;
int                      GlobalVariable::m_iGameHeight      = 640;
int                      GlobalVariable::m_iCurrentLanguage = 1;
int                      GlobalVariable::m_iCurrentGame     = 0;
int                      GlobalVariable::m_iCurrentZone     = 0;
int                      GlobalVariable::m_iCurrentRoom     = 0;
int                      GlobalVariable::m_iCurrentTable    = 0;
int                      GlobalVariable::m_iTotalFiredCard  = 0;
int                      GlobalVariable::m_iTotalPhom       = 0;
int                      GlobalVariable::m_iTotalCardinHand = 0;
int                      GlobalVariable::m_iDeckNo          = 0;
short                    GlobalVariable::m_sPhomDistance    = 0;
bool                     GlobalVariable::m_bResourceLoaded  = false;
bool                     GlobalVariable::m_bCanEat          = false;
bool                     GlobalVariable::m_bAlreadyGetCard  = false;
bool                     GlobalVariable::m_bCanDraw         = false;
std::string              GlobalVariable::m_sSID             = "";
std::string              GlobalVariable::m_sPopupMessage    = "";
PlayerData*              GlobalVariable::m_pUser      		= new PlayerData();
vector<PlayerData*>*     GlobalVariable::m_vPlayers         = new std::vector<PlayerData*>();
vector<PlayerData*>*	 GlobalVariable::m_vPlayersSorted   = new std::vector<PlayerData*>();
vector<TableData*>*      GlobalVariable::m_vTableData       = new std::vector<TableData*>();
vector<GameServerData*>* GlobalVariable::m_vGameServerData  = new std::vector<GameServerData*>();
vector<Card*>*           GlobalVariable::m_vFiredCards      = new std::vector<Card*>();
AdBar*                   GlobalVariable::m_pAdBar           = nullptr;
UserInfo*                GlobalVariable::m_pUserInfo        = nullptr;
SettingCom*              GlobalVariable::m_pSettingCom      = nullptr;
CMDSetData*              GlobalVariable::m_cSetData         = new CMDSetData();
SSCMDGameData*           GlobalVariable::m_startGameData    = new SSCMDGameData();
bool                     GlobalVariable::m_bMute            = false;
bool					 GlobalVariable::m_bLogout			= false;
bool					 GlobalVariable::m_bBackToLobby		= false;
bool					 GlobalVariable::m_bBackToChooseGame = false;
string                   GlobalVariable::m_sWaitRoomName	= "";
bool                     GlobalVariable::m_bFirstLoad       = false;
bool                     GlobalVariable::m_bCanU            = false;
double                   GlobalVariable::m_dIdPlayerStart   = 0;
std::string              GlobalVariable::m_sDomain          = "thapthanh";
std::string GlobalVariable::m_sRegisterUrl				    = "";
std::string GlobalVariable::m_sProxyLoginUrl                = "";
std::string GlobalVariable::m_sLoginUrl					    = "";
std::string GlobalVariable::m_sFacebookLogin			    = "";
std::string GlobalVariable::m_sLanguagesData			    = "http://gcdn.gameloe.com/susun/Languages.txt";
std::string GlobalVariable::m_sAppPackage 				    = "com.Pinoy.CapsaSusun.AppActivity";
std::string GlobalVariable::m_sFacebookToken                = "";
rapidjson::Document		GlobalVariable::langData			= NULL;
MsgConst*				GlobalVariable::msgConst			= new MsgConst();
vector<CMDFinishData*>*  GlobalVariable::m_vCMDFinishData   = nullptr;
vector<SSCMDUserEndViewData*>*  GlobalVariable::m_vSSCMDUserEndViewData     = nullptr;
int                      GlobalVariable::m_iReconnectCount  = 0;
std::string GlobalVariable::m_sTableName                    = "";
int                      GlobalVariable::m_iPingCount       = 0;
int                      GlobalVariable::m_bSpectator       = false;
CMDMinMaxStake*          GlobalVariable::m_pDataMinMaxStake = nullptr;
bool                     GlobalVariable::m_bInviteOn        = true;
bool                     GlobalVariable::m_bGameRestarted   = false;
bool                     GlobalVariable::m_bWasKicked       = false;
bool                     GlobalVariable::m_bWasKickedIdle   = false;
double                   GlobalVariable::m_dLastSecond      = 0;
double                   GlobalVariable::m_dCurrentSecond   = 0;
spine::SkeletonAnimation* GlobalVariable::m_skeletonNode    = nullptr;
short                    GlobalVariable::m_sDevice          = 0;
short                      GlobalVariable::m_sPot           = 0;
std::string              GlobalVariable::m_sCurrentVersion  = "100";
bool                     GlobalVariable::m_bHasNewVersion   = false;
bool                     GlobalVariable::m_bRequestLogout   = false;
std::string              GlobalVariable::m_sMessageId       = "";
std::string              GlobalVariable::m_sInreview        = "1";
std::string              GlobalVariable::m_sUserFacebookID  = "";
int                      GlobalVariable::m_bMe              = false;
bool                     GlobalVariable::m_bMaubinhCheck    = false;
bool                     GlobalVariable::m_bDontShowMsg     = false;
std::string              GlobalVariable::m_sDeviceID        = "";
int                      GlobalVariable::m_iAccountMode     = kAccountModeOther;
bool                     GlobalVariable::m_bPing            = false;
bool                     GlobalVariable::m_bDebug           = false;
CMDMinMaxStakeT*         GlobalVariable::m_pDataMinMaxStakeT= nullptr;
vector<CMDFinishDataT*>* GlobalVariable::m_vCMDFinishDataT  = nullptr;
CMDSetDataT*             GlobalVariable::m_cSetDataT         = new CMDSetDataT();
vector<CMDDropCardDataT*>*GlobalVariable::m_vCMDDropCardData = nullptr;
bool                     GlobalVariable::m_bDoubleLogin         = false;
std::string              GlobalVariable::m_sAppIDPurchase   = "";
std::string              GlobalVariable::m_sMoneyPurchase   = "";
bool                     GlobalVariable::m_bWasBonusStarup  = false;
std::string              GlobalVariable::m_sMessage         = "";
bool                     GlobalVariable::m_bWasDailyBonus   = false;
CMDDailyBonusData*       GlobalVariable::m_cmdDailyBonusData = new CMDDailyBonusData();
bool                     GlobalVariable::m_bOutofMoney       = false;
bool                     GlobalVariable::m_bSusunWin         = false;