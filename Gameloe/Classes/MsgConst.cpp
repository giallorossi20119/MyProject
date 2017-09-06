//
//  MsgConst.cpp
//  IndoGame
//
//  Created by longnh on 9/24/14.
//
//


#include "MsgConst.h"
#include "GlobalVariable.h"
#include "TextMessage.h"
#include "ResourceManager.h"

using namespace std;

MsgConst::MsgConst()
{

}
MsgConst::~MsgConst()
{
}

string MsgConst::getCurMsg(const char* key)
{
	string str = "";
    str = ResourceManager::getInstance()->m_jTextMessage[GlobalVariable::m_iCurrentLanguage]["TEXTS"][key].GetString();
    return str;
}

string MsgConst::getMsg(const char* key, std::vector<string>*  params)
{
	int ikey = atoi(key);

	string str = "";

	switch (ikey)
	{
        case LOGIN_NOT_VALID:
        {
            str = getCurMsg(MSG_LOGIN_NOT_VALID);
            break;
        }
        case MAINTAIN_GAME:
        {
            str = getCurMsg(MSG_MAINTAIN_GAME);
            break;
        }
        case DOMAIN_NOT_VALID:
        {
            str = getCurMsg(MSG_DOMAIN_NOT_VALID);
            break;
        }
        case LOGIN_INFO_NOT_ENOUGHT:
        {
            str = getCurMsg(MSG_LOGIN_INFO_NOT_ENOUGHT);
            break;
        }
        case CANNOT_GET_INFO_USER:
        {
            str = getCurMsg(MSG_CANNOT_GET_INFO_USER);
            break;
        }
        case DISCONNECT_DOUBLE_LOGIN:
        {
            str = getCurMsg(MSG_DISCONNECT_DOUBLE_LOGIN);
            break;
        }
        case KICK_DOUBLE_LOGIN:
        {
            str = getCurMsg(MSG_KICK_DOUBLE_LOGIN);
            break;
        }
        case CANNOT_CONNECT_SV:
        {
            str = getCurMsg(MSG_CANNOT_CONNECT_SV);
            break;
        }
        case BANNED_WHEN_LOGIN:
        {
            str = getCurMsg(MSG_BANNED_WHEN_LOGIN);
            break;
        }
        case LOGIN_NOTENOUGHT_MONEY:
        {
            str = getCurMsg(MSG_LOGIN_NOTENOUGHT_MONEY);
            break;
        }
        case LOGIN_NOTENOUGHT_EXP:
        {
            str = getCurMsg(MSG_LOGIN_NOTENOUGHT_EXP);
            break;
        }
        case LOGIN_NOTENOUGHT_VIP:
        {
            str = getCurMsg(MSG_LOGIN_NOTENOUGHT_VIP);
            break;
        }
        case LOGIN_NOTI_TOUR:
        {
            str = getCurMsg(MSG_LOGIN_NOTI_TOUR);
            break;
        }
        case LOGIN_NOTI_TOUR2:
        {
            str = getCurMsg(MSG_LOGIN_NOTI_TOUR2);
            break;
        }

        case NOT_HAVE_TOUR:
        {
            str = getCurMsg(MSG_NOT_HAVE_TOUR);
            break;
        }
        case NOT_BELONG_TOUR:
        {
            str = getCurMsg(MSG_NOT_BELONG_TOUR);
            break;
        }
        case MONEY_DAYLY:
        {
            str = getCurMsg(MSG_MONEY_DAYLY);
            break;
        }
        case DEMO_GAME:
        {
            str = getCurMsg(MSG_DEMO_GAME);
            break;
        }
        case RELOAD_PLEASE:
        {
            str = getCurMsg(MSG_RELOAD_PLEASE);
            break;
        }
        case REMINDSTABLE:
        {
            str = getCurMsg(MSG_REMINDSTABLE);
            break;
        }
        case RELOAD_EXT:
        {
            str = getCurMsg(MSG_RELOAD_EXT);
            break;
        }
        case MINIGAME_MAINTAIN:
        {
            str = getCurMsg(MSG_MINIGAME_MAINTAIN);
            break;
        }
        case CANNOT_PLAY_MINI_GAME:
        {
            str = getCurMsg(MSG_CANNOT_PLAY_MINI_GAME);
            break;
        }
        case ADDCHIP_ERROS:
        {
            str = getCurMsg(MSG_ADDCHIP_ERROS);
            break;
        }
        case ADDCHIP_ERROS_2:
        {
            str = getCurMsg(MSG_ADDCHIP_ERROS_2);
            break;
        }
        case ADDCHIP_ERROS_3:
        {
            str = getCurMsg(MSG_ADDCHIP_ERROS_3);
            break;
        }
        case ADDCHIP_ERROS_4:
        {
            str = getCurMsg(MSG_ADDCHIP_ERROS_4);
            break;
        }
        case ADDCHIP_SUCCESS:
        {
            str = getCurMsg(MSG_ADDCHIP_SUCCESS);
            break;
        }
        case CHOINHANH_ERROS:
        {
            str = getCurMsg(MSG_CHOINHANH_ERROS);
            break;
        }
        case FRIENDSLIST_ERROS:
        {
            str = getCurMsg(MSG_FRIENDSLIST_ERROS);
            break;
        }
        case REPLAY_ERROS:
        {
            str = getCurMsg(MSG_REPLAY_ERROS);
            break;
        }
        case GETTCOIN_ERROS:
        {
            str = getCurMsg(MSG_GETTCOIN_ERROS);
            break;
        }
        case BANNICK:
        {
            str = getCurMsg(MSG_BANNICK);
            break;
        }
        case ADMINKICK:
        {
            str = getCurMsg(MSG_ADMINKICK);
            break;
        }
        case INVITE_ERROR:
        {
            str = getCurMsg(MSG_INVITE_ERROR);
            break;
        }
        case INVITE_MYSELF_ERROR:
        {
            str = getCurMsg(MSG_INVITE_MYSELF_ERROR);
            break;
        }
        case NOT_HAVE_ROOM:
        {
            str = getCurMsg(MSG_NOT_HAVE_ROOM);
            break;
        }
        case END_OF_TOUR:
        {
            str = getCurMsg(MSG_END_OF_TOUR);
            break;
        }
        case WRONG_ROOM_IN_TOUR:
        {
            str = getCurMsg(MSG_WRONG_ROOM_IN_TOUR);
            break;
        }
        case DUPLICATE_IP_JOIN_ROOM:
        {
            str = getCurMsg(MSG_DUPLICATE_IP_JOIN_ROOM);
            break;
        }
        case CANNOT_JOIN_ROOM:
        {
            str = getCurMsg(MSG_CANNOT_JOIN_ROOM);
            break;
        }
        case CHECK_REPLAY:
        {
            str = getCurMsg(MSG_CHECK_REPLAY);
            break;
        }

            //	In Game
        case NOT_ENOUGHT_MONEY:
        {
            str = getCurMsg(MSG_NOT_ENOUGHT_MONEY);
            break;
        }
        case NOT_IN_ROOM:
        {
            str = getCurMsg(MSG_NOT_IN_ROOM);
            break;
        }
        case CANNOT_START_BECAUSE_END_TOUR:
        {
            str = getCurMsg(MSG_CANNOT_START_BECAUSE_END_TOUR);
            break;
        }
        case ISNOT_PLAYING_ERROS:
        {
            str = getCurMsg(MSG_ISNOT_PLAYING_ERROS);
            break;
        }
        case IS_PLAYING_ERROS:
        {
            str = getCurMsg(MSG_IS_PLAYING_ERROS);
            break;
        }
        case ROOM_NOT_GAME:
        {
            str = getCurMsg(MSG_ROOM_NOT_GAME);
            break;
        }
        case CANNOT_START_BECAUSE_DELAY:
        {
            str = getCurMsg(MSG_CANNOT_START_BECAUSE_DELAY);
            break;
        }
        case DA_CHOI_KHONG_THE_BAT_DAU:
        {
            str = getCurMsg(MSG_DA_CHOI_KHONG_THE_BAT_DAU);
            break;
        }
        case THIEU_NGUOI_KHONG_THE_BAT_DAU:
        {
            str = getCurMsg(MSG_THIEU_NGUOI_KHONG_THE_BAT_DAU);
            break;
        }
        case BAD_REQUESTS:
        {
            str = getCurMsg(MSG_BAD_REQUESTS);
            break;
        }
        case KO_CO_QUYEN_START:
        {
            str = getCurMsg(MSG_KO_CO_QUYEN_START);
            break;
        }
        case BAD_ACTION_BECAUSE_IS_VIEWER:
        {
            str = getCurMsg(MSG_BAD_ACTION_BECAUSE_IS_VIEWER);
            break;
        }
        case BAD_ACTION_BECAUSE_NOT_TURN:
        {
            str = getCurMsg(MSG_BAD_ACTION_BECAUSE_NOT_TURN);
            break;
        }
        case NOT_CONTAIN_CARDS:
        {
            str = getCurMsg(MSG_NOT_CONTAIN_CARDS);
            break;
        }
        case CANNOT_ACTION_WHEN_PLAYING:
        {
            str = getCurMsg(MSG_CANNOT_ACTION_WHEN_PLAYING);
            break;
        }
        case ONLY_MOD_CAN_CHANGE:
        {
            str = getCurMsg(MSG_ONLY_MOD_CAN_CHANGE);
            break;
        }
        case CANNOT_CHANGE_CUOC_MIN:
        {
            str = getCurMsg(MSG_CANNOT_CHANGE_CUOC_MIN);
            break;
        }
        case ACTION_NOT_VALID:
        {
            str = getCurMsg(MSG_ACTION_NOT_VALID);
            break;
        }
        case CANNOT_BO_LUOT_IN_FIRST:
        {
            str = getCurMsg(MSG_CANNOT_BO_LUOT_IN_FIRST);
            break;
        }
        case NOT_CONTAIN_MAX_INDEXCARD:
        {
            str = getCurMsg(MSG_NOT_CONTAIN_MAX_INDEXCARD);
            break;
        }
        case ERROR_CHANGE_CUOC:
        {
            str = getCurMsg(MSG_ERROR_CHANGE_CUOC);
            break;
        }
        case ERROR_CHANGE_CUOC1:
        {
            str = getCurMsg(MSG_ERROR_CHANGE_CUOC1);
            break;
        }
        case ERROR_CHANGE_CUOC2:
        {
            str = getCurMsg(MSG_ERROR_CHANGE_CUOC2);
            break;
        }
        case ON_AUTOPLAY:
        {
            str = getCurMsg(MSG_ON_AUTOPLAY);
            break;
        }
        case OFF_AUTOPLAY:
        {
            str = getCurMsg(MSG_OFF_AUTOPLAY);
            break;
        }
        case IDS_INVALID_CREDENTIAL_ID:
        {
            str = getCurMsg(IDS_INVALID_CREDENTIAL);
            break;
        }
        case IDS_ACCOUNT_NOT_EXIST_OR_EMAIL_ID:
        {
            str = getCurMsg(IDS_ACCOUNT_NOT_EXIST_OR_EMAIL);
            break;
        }
        case BONUS_GOLD_STARTUP:
        {
            str = getCurMsg(MSG_BONUS_GOLD_STARTUP);
            break;
        }
        default:
        {
            char str[100] = "MSG CODE NOT VALID: ";
            strcat(str,key);
            return str;
        }
	}
    CCLOG("Message: %s", str.c_str());
    string format = str;
    size_t pos = 0;
    int i = 0;
    while((pos = str.find("%", pos)) != std::string::npos)
    {
        str.replace(pos, 1, params->at(i));
        pos += params->at(i).length();
        i++;
    }
    CCLOG("Format: %s", str.c_str());

	return str;
}

void MsgConst::getMsgParams(CMDErrorData* pCMDErrorData, std::string& key, std::vector<std::string>*&  params)
{
    string str = pCMDErrorData->m_sMessage;

	key = str.substr(0, str.find_first_of(","));
	str.erase(0, key.size() + 1);

	if (str.size() > 0)
	{
		while (str.find_first_of(",") != -1)
		{
			string a = str.substr(0, str.find_first_of(","));
			params->push_back(a);
			str.erase(0, a.size() + 1);
		}
        if(str.length() > 0)
        {
            params->push_back(str);
        }
	}

}
