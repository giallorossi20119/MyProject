//
//  Constant.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//


#ifndef __IndoGame__Constant__
#define __IndoGame__Constant__

#include <iostream>

#define kBaseGameWidth  960
#define kBaseGameHeight 640

//device type
#define kDeviceIOS       0
#define kDeviceAndroid   1
#define kDeviceOther     2

#define kAccountModeGuest    0
#define kAccountModePersonal 1
#define kAccountModeOther    2
//
#define kLoginTypeDeviceID     0
#define kLoginTypeAccount      1
#define kLoginTypeFacebook     2
#define kLoginTypeGooglePlus   3

//scene
#define kSceneLoading    0
#define kSceneLogin      1
#define kSceneChooseGame 2
#define kSceneChooseZone 3
#define kSceneLobby      4
#define kSceneInGame1    5
#define kSceneInGame2    6
#define kSceneInGame3    7
#define kSceneNO         8
//game
#define kGameBanting   0
#define kGameSusun     1
#define kGameTexas     2

//animation
#define kAnimGirl       0
#define kAnimLight      1
#define kAnimWin        2
#define kAnimLose       3
#define kAnimWait       4
#define kAnimGood       5
#define kAnimBad        6
#define kAnimNewSet     7
#define kAnimTimeLine   8
#define kAnimCardSwap   9
#define kAnimExp        10
#define kAnimDead2      11
#define kNOAnims        20

#define kBaseURL      "http://gcdn.gameloe.com/"
#define kBankURL      "http://bank.gameloe.com/webview?sid="
#define kConfigFile   "config.txt"
#define kLanguageURL  "http://gcdn.gameloe.com/susun/Languages1.txt"
#define kNewsURL      "http://gcdn.gameloe.com/news.txt"
#define kURLGameloeDeviceID "http://ids.gameloe.com/api/client"
#define kURLFanPage   "http://www.facebook.com/gameloedotcom"
#define kSupportNumber "082299169836"
#define USING_NS_STD using namespace std
#define USING_NS_UI  using namespace ui
#define USING_NS_NET using namespace cocos2d::network

//scene data
#define kSceneJsonLoading               "LoadingScene.json"
#define kSceneJsonLogin                 "LoginScene.json"
#define kSceneChooseGameJsonFile		"ChooseGameScene.json"
#define kComponentUserInfoFile			"UserInfoCom.json"
#define kComponentPlayerInfoFile		"PlayerInfoCom.json"
#define kSceneLobbyGameJsonFile			"LobbyScene.json"
#define kItemListRoom					"ItemListRooms.json"
#define kComponentSetting     			"SettingCom.json"
#define kSceneJsonCapsaBantingGame      "CapsaBantingScene.json"
#define kSceneJsonCapsaSusunGame        "CapsaSusunScene.json"
#define kSettingRoomPopup				"SettingBox.json"
#define kSettingLobbyPopup				"SettingLanguages.json"
#define kRankPopup						"RankPopup.json"
#define kItemRank						"ItemRank.json"
#define kEndGamePopup					"EndGamePopup.json"
#define kPlayerInfoPopup                "PlayerInfoPopup.json"
#define kIAPPopup                       "IAPPopup.json"
#define kIAPItem					    "IAPItem.json"
#define kDailyBonusPopup                "DailyBonusPopup.json"
#define kQuestBonusPopup                "QuestBonusPopup.json"
#define kBonusItem					    "BonusItem.json"
//languages
#define LANG_INDONESIA	0
#define LANG_ENGLISH		1
#define	LANG_VIETNAMESE	2

//sound data
#define kSoundMusicTitle			   "chooseGame.mp3"
#define kSoundMusicLose                "lose1.mp3"
#define kSoundMusicWin                 "win1.mp3"
#define kSoundMusicBinhLung            "BinhLungSS.mp3"
#define kSoundMusicMauBinh             "MauBinhSS.mp3"
#define kSoundMusicStart               "Start.mp3"

#define kSoundEffectButtonClick         "click.mp3"
#define kSoundEffectFire                "fire.mp3"
#define kSoundEffectSoBai               "SoBaiSS.mp3"
#define kSoundEffectDanhGui             "DanhGui.mp3"
#define kSoundEffectJoinTable           "joinTable.mp3"
#define kSoundEffectLeftTable           "leaveTable.mp3"
#define kSoundEffectXepBai              "XepBaiSS.mp3"
#define kSoundEffectCountDown           "CountDownSS.mp3"


//start smartfox command
//send
#define S_CLIENT_LOBBY					"client_listWaitingHandler"
#define S_CLIENT_PLAYNOW				"client_choinhanh"
#define S_CLIENT_JOIN_GAME				"client_joinroom"
#define S_COMMAND_KICK_USER             "105"
#define S_CLIENT_RANK					"client_rank"
#define S_CLIENT_CHANGE_SETTING_GAME	"110"
#define S_COMMAND_INVITE                "client_invite"
#define S_COMMAND_GET_LISTWAITING       "client_listWaitingHandler"
#define S_CLIENT_PLAYER_INFO            "info_player"

//recieve
#define C_INFO_USER             "1"
#define C_UPDATE_INFO_USER      "2"
#define C_CLIENT_USER_CREATE_ROOM "6"
#define C_CLIENT_ERROR		    "7"
#define C_CHECK_RECONNECT       "8"
#define C_CLIENT_BONUS_DAILY    "9"
#define C_CLIENT_BONUS_TIME     "10"
#define C_CLIENT_POSITION_DATA  "101"
#define C_CLIENT_USER_JOIN_ROOM "102"
#define C_CLIENT_USER_OUT_ROOM  "103"
#define C_CLIENT_RESET_GAME     "108"
#define C_CLIENT_STARTID        "126"
#define C_CLIENT_LOBBY          "client_lobbyHandler"
#define C_CLIENT_PLAYNOW_RS	    "client_choinhanh_rs"
#define C_CLIENT_CHANGE_ROUND   "123"
#define C_CLIENT_FINISH         "125"
#define C_CLIENT_STARTID        "126"
#define C_CLIENT_DEAD_2         "130"
#define C_CLIENT_END_SHOW_RESULT "131"
#define C_CLIENT_RANK_RS		"client_rankRS"
#define C_COMMAND_KICK_USER     "105"

#define C_GET_MIN_MAX_STAKE		"115"
#define C_COMMAND_INVITE        "client_inviteRS"
#define C_COMMAND_CHATCHEM      "124"
#define C_COMMAND_GET_LISTWAITING "client_listWaitingHandlerRs"
#define C_COMMAND_REMINDS       "client_reminds"
#define C_CLIENT_PLAYER_INFO    "info_player_rs"
//both send/recieve
#define SC_CLIENT_CHANGE_SETTING_GAME	"110"
#define SC_CLIENT_START_GAME    "120"
#define SC_CLIENT_DANH_BAI      "122"
#define SC_CLIENT_PING          "100"
#define SC_CLIENT_BO_LUOT       "121"
#define SC_COMMAND_AUTO         "cAuto"

//end smartfox command

//const finish game

#define NOWIN               50
#define FN_DONG_HOA         28
#define FN_RONG             29
#define FN_RONG_DONG_HOA    30
#define FN_TOI_NHAT         52
#define FN_TOI_NHI          53
#define FN_TOI_BA           54
#define FN_TOI_CHOT         55
#define FN_THUA_CONG        56

//both send/recieve
#define SC_CLIENT_CHANGE_SETTING_GAME	"110"
#define SC_CLIENT_START_GAME    "120"
#define SC_CLIENT_DANH_BAI      "122"
#define SC_CLIENT_PING          "100"
#define SC_CLIENT_BO_LUOT       "121"
#define SC_COMMAND_AUTO         "cAuto"
//end smartfox command

//Susun game Start
//send
#define SS_S_GAME_START           "201"
#define SS_S_CHANGE_POSITION      "202"
#define SS_S_KICK                 "203"
#define SS_S_NEW_CONFIG           "204"
#define SS_S_PING                 "207"
#define SS_S_XEP_XONG             "210"
#define SS_S_BAO_MAU_BINH         "223"
#define SS_S_MAU_BINH_3S3T        "224"
#define SS_S_EMOTICON             "232"
#define SS_S_MOD_START            "234"
//recive
#define SS_R_CONFIG               "205"
#define SS_R_SPECTATOR            "206"
#define SS_R_PING                 "208"
#define SS_R_RENEW_SFS_ID         "209"
#define SS_R_XEPXONG              "211"
#define SS_R_MIN_MAX_STAKE		  "215"
#define SS_R_USER_DATA            "216"
#define SS_R_USER_DATA_RESUME     "217"
#define SS_R_USER_DATA_END        "218"
#define SS_R_CARDLIST             "219"
#define SS_R_USER_DATA_END_VIEW   "220"
#define SS_R_FULLTIME             "221"
#define SS_R_RESTART              "222"
#define SS_R_MAU_BINH             "225"
#define SS_R_EMOTICON             "233"
#define SS_R_PLUS                 "236"
#define SS_R_SPEC                 "298"
#define SS_R_MOD                  "299"
#define SS_R_UPDATE_END_GAME      "eg"
#define SS_R_ERROR                "0"

//send/recive
//Susun game End

//macro to convert from int to string
#define ccsf(...) CCString::createWithFormat(__VA_ARGS__)->getCString()

#define kTransitionDurationInSec 0.8f
#define __LOG(...) CCLOG("File: %s, Function: %s, Line: %d", __FILE__, __FUNCTION__, __LINE__); CCLOG(__VA_ARGS__);

#endif /* defined(__IndoGame__Constant__) */
