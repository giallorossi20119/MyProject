#include "SFSResponse.h"

void SFSResponse::parse(int pGameId, const char* cmd,
                        boost::shared_ptr<ByteArray> btrd,
                        boost::shared_ptr<ByteArray> btrt,
                        boost::shared_ptr<ByteArray> btrc,
                        boost::shared_ptr<ByteArray> btrg,
                        boost::shared_ptr<ByteArray> btrn)
{
    if(strcmp(cmd, C_CLIENT_ERROR) == 0)
    {
        CMDErrorData* cmdErrorData = new CMDErrorData();
        btrd->ReadUTF(cmdErrorData->m_sCommand);
        btrd->ReadUTF(cmdErrorData->m_sMessage);
        CCLOG("OnExtensionResponse cmd%s msg%s: C_CLIENT_ERROR", cmdErrorData->m_sCommand.c_str(), cmdErrorData->m_sMessage.c_str());
        NotificationCenter::getInstance()->postNotification(C_CLIENT_ERROR, (Ref*)cmdErrorData);
        CC_SAFE_DELETE(cmdErrorData);
    }
    else if(strcmp(cmd, C_COMMAND_KICK_USER) == 0)
    {
        GlobalVariable::m_bWasKicked = true;
    }
    else if(strcmp(cmd, C_CLIENT_LEVELUP) == 0)
    {
        int m_iplusmoney;
        std::string m_splusmoney;
        NotificationCenter::getInstance()->postNotification(C_CLIENT_LEVELUP,NULL);
    }
    else if(strcmp(cmd, C_CHECK_RECONNECT) == 0)
    {
        if(pGameId==2)
        {
            CMDReconnectDataT* cmdReconnectData = new CMDReconnectDataT();
            btrd->ReadUTF(cmdReconnectData->m_sMsg);
            btrd->ReadUTF(cmdReconnectData->m_sTableName);
            CCLOG("OnExtensionResponse: C_CHECK_RECONNECT");
            NotificationCenter::getInstance()->postNotification(C_CHECK_RECONNECT, (Ref*)cmdReconnectData);
            CC_SAFE_DELETE(cmdReconnectData);
        }
        else
        {
            CMDReconnectData* cmdReconnectData = new CMDReconnectData();
            btrd->ReadUTF(cmdReconnectData->m_sMsg);
            btrd->ReadUTF(cmdReconnectData->m_sTableName);
            CCLOG("OnExtensionResponse: C_CHECK_RECONNECT");
            NotificationCenter::getInstance()->postNotification(C_CHECK_RECONNECT, (Ref*)cmdReconnectData);
            CC_SAFE_DELETE(cmdReconnectData);
        }
    }
    else if (strcmp(cmd, C_CLIENT_RANK_RS) == 0)
    {
        SFSResponse::proc_Rank(btrd);
        CCLOG("OnExtensionResponse: C_CLIENT_RANK_RS");
    }
    else if (strcmp(cmd, C_INFO_USER) == 0)
    {
        //parse user infor
        GlobalVariable::m_pUser->parseFromByteData(btrd);
        CCLOG("OnExtensionResponse: C_INFO_USER");
        NotificationCenter::getInstance()->postNotification(EVENT_NETWORK_USER_INFO, NULL);
    }
    else if(strcmp(cmd, C_CLIENT_BONUS_DAILY) == 0)
    {
        CMDDailyBonusData* data = new CMDDailyBonusData();
        btrd->ReadShort(data->m_sDay);
        btrd->ReadInt(data->m_iBonus);
        GlobalVariable::m_bWasDailyBonus = true;
        CC_SAFE_DELETE(GlobalVariable::m_cmdDailyBonusData);
        GlobalVariable::m_cmdDailyBonusData = data;
        CCLOG("OnExtensionResponse: C_CLIENT_BONUS_DAILY");
    }
    else if (strcmp(cmd, C_UPDATE_INFO_USER) == 0)
    {
        PlayerData* player = new PlayerData();
        btrd->ReadUTF(player->m_sName);
        btrd->ReadDouble(player->m_dMoney);
        btrd->ReadDouble(player->m_dId);
        btrd->ReadInt(player->m_iExp);
        btrd->ReadInt(player->m_iLevel);
        btrd->ReadInt(player->m_iTotal);
        btrd->ReadInt(player->m_iWin);
        CCLOG("OnExtensionResponse: C_UPDATE_INFO_USER");
        if(player->m_dId == GlobalVariable::m_pUser->m_dId)
        {
            GlobalVariable::m_pUser->m_sName = player->m_sName;
            GlobalVariable::m_pUser->m_dMoney = player->m_dMoney;
            GlobalVariable::m_pUser->m_dId = player->m_dId;
            GlobalVariable::m_pUser->m_iExp = player->m_iExp;
            GlobalVariable::m_pUser->m_iLevel = player->m_iLevel;
            GlobalVariable::m_pUser->m_iTotal = player->m_iTotal;
            GlobalVariable::m_pUser->m_iWin = player->m_iWin;
            CC_SAFE_DELETE(player);
            NotificationCenter::getInstance()->postNotification(C_UPDATE_INFO_USER, nullptr);
        }
        else
        {
            for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
            {
                if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId == player->m_dId)
                {
                    GlobalVariable::m_vPlayersSorted->at(i)->m_sName = player->m_sName;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_dMoney = player->m_dMoney;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_dId = player->m_dId;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iExp = player->m_iExp;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iLevel = player->m_iLevel;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iTotal = player->m_iTotal;
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iWin = player->m_iWin;
                }
            }
            
            for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
            {
                if(GlobalVariable::m_vPlayers->at(i)->m_dId == player->m_dId)
                {
                    GlobalVariable::m_vPlayers->at(i)->m_sName = player->m_sName;
                    GlobalVariable::m_vPlayers->at(i)->m_dMoney = player->m_dMoney;
                    GlobalVariable::m_vPlayers->at(i)->m_dId = player->m_dId;
                    GlobalVariable::m_vPlayers->at(i)->m_iExp = player->m_iExp;
                    GlobalVariable::m_vPlayers->at(i)->m_iLevel = player->m_iLevel;
                    GlobalVariable::m_vPlayers->at(i)->m_iTotal = player->m_iTotal;
                    GlobalVariable::m_vPlayers->at(i)->m_iWin = player->m_iWin;
                    NotificationCenter::getInstance()->postNotification(C_UPDATE_INFO_USER, (Ref*)GlobalVariable::m_vPlayers->at(i));
                }
            }
            CC_SAFE_DELETE(player);
        }
    }
    else if (strcmp(cmd, C_CLIENT_PLAYNOW_RS) == 0)
    {
        string l_sTableName;
        btrd->ReadUTF(l_sTableName);
        GlobalVariable::m_iCurrentTable = atoi(l_sTableName.substr(3, l_sTableName.length() - 3).c_str());
        CCLOG("OnExtensionResponse: C_CLIENT_PLAYNOW_RS");
        SFSConnection::getInstance()->joinRoom(l_sTableName);
    }
    else if (strcmp(cmd, C_COMMAND_GET_LISTWAITING) == 0)
    {
        if (pGameId==2)
        {
            vector<CMDWaitingDataT*>* vWaitingData = new vector<CMDWaitingDataT*>();
            while(btrd->Position() < btrd->Length())
            {
                CMDWaitingDataT* cmdWaitingData = new CMDWaitingDataT();
                btrd->ReadUTF(cmdWaitingData->m_sName);
                btrd->ReadDouble(cmdWaitingData->m_dMoney);
                btrd->ReadInt(cmdWaitingData->m_iSfsId);
                btrd->ReadDouble(cmdWaitingData->m_dId);
                btrd->ReadInt(cmdWaitingData->m_iLevel);
                bool bCheck;
                btrd->ReadBool(bCheck);
                if(!bCheck)
                {
                    btrd->ReadInt(cmdWaitingData->m_iTotal);
                    btrd->ReadInt(cmdWaitingData->m_iWin);
                }
                vWaitingData->push_back(cmdWaitingData);
            }
            CCLOG("OnExtensionResponse: C_COMMAND_GET_LISTWAITING");
            NotificationCenter::getInstance()->postNotification(C_COMMAND_GET_LISTWAITING, (Ref*)vWaitingData);
            CC_SAFE_DELETE(vWaitingData);
        }
        else
        {
            vector<CMDWaitingData*>* vWaitingData = new vector<CMDWaitingData*>();
            while(btrd->Position() < btrd->Length())
            {
                CMDWaitingData* cmdWaitingData = new CMDWaitingData();
                btrd->ReadUTF(cmdWaitingData->m_sName);
                btrd->ReadDouble(cmdWaitingData->m_dMoney);
                btrd->ReadInt(cmdWaitingData->m_iSfsId);
                btrd->ReadDouble(cmdWaitingData->m_dId);
                btrd->ReadInt(cmdWaitingData->m_iLevel);
                bool bCheck;
                btrd->ReadBool(bCheck);
                if(!bCheck)
                {
                    btrd->ReadInt(cmdWaitingData->m_iTotal);
                    btrd->ReadInt(cmdWaitingData->m_iWin);
                }
                vWaitingData->push_back(cmdWaitingData);
            }
            CCLOG("OnExtensionResponse: C_COMMAND_GET_LISTWAITING");
            NotificationCenter::getInstance()->postNotification(C_COMMAND_GET_LISTWAITING, (Ref*)vWaitingData);
            CC_SAFE_DELETE(vWaitingData);
        }
    }
    else if (strcmp(cmd, C_COMMAND_INVITE) == 0)
    {
        if(pGameId==2)
        {
            CMDInvitationDataT* cmdInvitationData = new CMDInvitationDataT();
            btrd->ReadInt(cmdInvitationData->m_iLevel);
            btrd->ReadDouble(cmdInvitationData->m_dMoney);
            btrd->ReadDouble(cmdInvitationData->m_dId);
            btrd->ReadUTF(cmdInvitationData->m_sName);
            btrd->ReadUTF(cmdInvitationData->m_sTableName);
            btrd->ReadInt(cmdInvitationData->m_iCuoc);
            btrd->ReadInt(cmdInvitationData->m_iTime);
            CCLOG("OnExtensionResponse: C_COMMAND_INVITE");
            NotificationCenter::getInstance()->postNotification(C_COMMAND_INVITE, (Ref*)cmdInvitationData);
        }
        else
        {
            CMDInvitationData* cmdInvitationData = new CMDInvitationData();
            btrd->ReadInt(cmdInvitationData->m_iLevel);
            btrd->ReadDouble(cmdInvitationData->m_dMoney);
            btrd->ReadDouble(cmdInvitationData->m_dId);
            btrd->ReadUTF(cmdInvitationData->m_sName);
            btrd->ReadUTF(cmdInvitationData->m_sTableName);
            btrd->ReadInt(cmdInvitationData->m_iCuoc);
            btrd->ReadInt(cmdInvitationData->m_iTime);
            CCLOG("OnExtensionResponse: C_COMMAND_INVITE");
            NotificationCenter::getInstance()->postNotification(C_COMMAND_INVITE, (Ref*)cmdInvitationData);
        }
    }
    else if (strcmp(cmd, S_CLIENT_CHANGE_SETTING_GAME) == 0)
    {
        CMDSettingInGame* obj = new CMDSettingInGame();
        btrd->ReadInt(obj->stake);
        btrd->ReadInt(obj->times);
        CCLOG("OnExtensionResponse: S_CLIENT_CHANGE_SETTING_GAME");
        NotificationCenter::getInstance()->postNotification(S_CLIENT_CHANGE_SETTING_GAME, (Ref*)obj);
    }
    else if(strcmp(cmd, C_CLIENT_PLAYER_INFO) == 0)
    {
        PlayerData* pPlayerData = new PlayerData();
        btrd->ReadUTF(pPlayerData->m_sName);
        btrd->ReadDouble(pPlayerData->m_dMoney);
        btrd->ReadInt(pPlayerData->m_iSfsId);
        btrd->ReadInt(pPlayerData->m_iWin);
        btrd->ReadInt(pPlayerData->m_iTotal);
        btrd->ReadInt(pPlayerData->m_iLevel);
        btrd->ReadDouble(pPlayerData->m_dId);
        btrd->ReadInt(pPlayerData->m_iExp);
        CCLOG("OnExtensionResponse: C_CLIENT_PLAYER_INFO");
        NotificationCenter::getInstance()->postNotification(C_CLIENT_PLAYER_INFO, (Ref*)pPlayerData);
        CC_SAFE_DELETE(pPlayerData);
    }
    //response to game
    if(pGameId == 0)
    {
        if(strcmp(cmd, SC_CLIENT_PING) == 0)
        {
            CCLOG("ping");
            SFSConnection::getInstance()->ping();
        }
        else if (strcmp(cmd, C_CLIENT_POSITION_DATA) == 0)
        {
            CMDSetData* cmdSetData = new CMDSetData();
            
            btrd->ReadInt(cmdSetData->m_iCuoc);
            btrd->ReadInt(cmdSetData->m_iTime);
            btrd->ReadInt(cmdSetData->m_iType);
            btrd->ReadBool(cmdSetData->m_bPlaying);
            GlobalVariable::m_vPlayers->clear();
            if(!cmdSetData->m_bPlaying)
            {
                while( btrd->Position() < btrd->Length())
                {
                    PlayerData* pPlayerData = new PlayerData();
                    pPlayerData->parseFromByteData2(btrd);
                    if(pPlayerData->m_dId == GlobalVariable::m_pUser->m_dId)
                    {
                        GlobalVariable::m_pUser->m_iSfsId = pPlayerData->m_iSfsId;
                        CCLOG("OnSmartFoxLogin SFSID2 %ld", GlobalVariable::m_pUser->m_iSfsId);
                    }
                    //if(GlobalVariable::m_vPlayers->size() == 0)
                    //{
                    //pPlayerData->m_bHost = true;
                    //}
                    GlobalVariable::m_vPlayers->push_back(pPlayerData);
                }
            }
            else
            {
                btrd->ReadBool(cmdSetData->m_bReconnect);
                long lengCard;
                btrd->ReadInt(lengCard);//do dai mang byte card dang danh tren ban
                if(lengCard > 0)
                {
                    for(int i = 0; i < lengCard / 2; i++)
                    {
                        short c;
                        btrd->ReadShort(c);
                        cmdSetData->m_vCardId->push_back(c);
                    }
                }
                //user
                while(btrd->Position() < btrd->Length())
                {
                    PlayerData* pPlayerData = new PlayerData();
                    pPlayerData->parseFromByteData2(btrd);
                    //GlobalVariable::m_pUser->m_iSfsId = pPlayerData->m_iSfsId;
                    CCLOG("OnSmartFoxLogin SFSID3 %ld", GlobalVariable::m_pUser->m_iSfsId);
                    //player in turn ?
                    bool isPlayerturn;
                    btrd->ReadBool(isPlayerturn);
                    if(isPlayerturn)
                    {
                        btrd->ReadInt(cmdSetData->m_iTimeTurnRemain);
                        cmdSetData->m_dNextTurnId = pPlayerData->m_dId;
                    }
                    btrd->ReadShort(pPlayerData->m_iRemainCards);
                    //neu co reconnect thi lay card in hand
                    if(cmdSetData->m_bReconnect)
                    {
                        if(pPlayerData->m_dId == GlobalVariable::m_pUser->m_dId)
                        {
                            GlobalVariable::m_pUser->m_vCardId->clear();
                            for(int i = 0; i < pPlayerData->m_iRemainCards; i++)
                            {
                                short c;
                                btrd->ReadShort(c);
                                GlobalVariable::m_pUser->m_vCardId->push_back(c);
                            }
                        }
                    }
                    else
                    {
                        cmdSetData->m_bSpectator = true;
                    }
                    GlobalVariable::m_vPlayers->push_back(pPlayerData);
                }
            }
            sortPlayers();
            if(!GlobalVariable::m_pUser->m_bPlaying)
            {
                cmdSetData->m_bSpectator = true;
            }
            if(GlobalVariable::m_cSetData)
            {
                CC_SAFE_DELETE(GlobalVariable::m_cSetData);
            }
            GlobalVariable::m_cSetData = cmdSetData;
            CCLOG("OnExtensionResponse: C_CLIENT_POSITION_DATA");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_POSITION_DATA, NULL);
        }
        else if(strcmp(cmd, C_CLIENT_USER_JOIN_ROOM) == 0)
        {
            PlayerData* pPlayerData = new PlayerData();
            pPlayerData->parseFromByteData2(btrd);
            GlobalVariable::m_vPlayers->push_back(pPlayerData);
            sortPlayers();
            CCLOG("OnExtensionResponse: C_CLIENT_USER_JOIN_ROOM");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_USER_JOIN_ROOM, nullptr);
        }
        else if(strcmp(cmd, C_CLIENT_USER_OUT_ROOM) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
            {
                if(GlobalVariable::m_vPlayers->at(i)->m_dId == userData->m_dUID)
                {
                    GlobalVariable::m_vPlayers->erase(GlobalVariable::m_vPlayers->begin() + i);
                }
            }
            sortPlayers();
            CCLOG("OnExtensionResponse: C_CLIENT_USER_OUT_ROOM");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_USER_OUT_ROOM, (Ref*)userData);
            CC_SAFE_DELETE(userData);
        }
        else if(strcmp(cmd, SC_CLIENT_START_GAME) == 0)
        {
            GlobalVariable::m_pUser->m_vCardId->clear();
            CMDIgnoreCardData* cmdIgnoreCardData = new CMDIgnoreCardData();
            btrd->ReadDouble(cmdIgnoreCardData->m_dNextTurnId);
            while(btrd->Position() < btrd->Length())
            {
                short c;
                btrd->ReadShort(c);
                GlobalVariable::m_pUser->m_vCardId->push_back(c);
            }
            auto sortInccreaseFunc = [](const int &a, const int &b){ return a < b;};
            std::sort(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), sortInccreaseFunc);
            CCLOG("OnExtensionResponse: SC_CLIENT_START_GAME");
            NotificationCenter::getInstance()->postNotification(SC_CLIENT_START_GAME, (Ref*)cmdIgnoreCardData);
            CC_SAFE_DELETE(cmdIgnoreCardData);
        }
        else if(strcmp(cmd, SC_CLIENT_DANH_BAI) == 0)
        {
            CMDFireCardData* fireCardData = new CMDFireCardData();
            btrd->ReadDouble(fireCardData->m_dNextTurnId);
            btrd->ReadDouble(fireCardData->m_dUserFireId);
            
            btrd->ReadShort(fireCardData->m_sNOCards);
            for(int i = 0; i < fireCardData->m_sNOCards; i++)
            {
                short c;
                btrd->ReadShort(c);
                fireCardData->m_vCardId->push_back(c);
            }
            btrd->ReadShort(fireCardData->m_iCardType);
            CCLOG("OnExtensionResponse: SC_CLIENT_DANH_BAI");
            if(fireCardData->m_dUserFireId == GlobalVariable::m_pUser->m_dId)
            {
                for(int i = 0; i < fireCardData->m_vCardId->size(); i++)
                {
                    int cardId = fireCardData->m_vCardId->at(i);
                    // Remove fired card from card list
                    vector<int>::iterator iterator = std::find(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), cardId);
                    if (iterator != GlobalVariable::m_pUser->m_vCardId->end())
                    {
                        GlobalVariable::m_pUser->m_vCardId->erase(iterator);
                    }
                }
            }
            
            NotificationCenter::getInstance()->postNotification(SC_CLIENT_DANH_BAI, (Ref*)fireCardData);
            CC_SAFE_DELETE(fireCardData);
        }
        else if(strcmp(cmd, SC_CLIENT_BO_LUOT) == 0)
        {
            CMDIgnoreCardData* cmdIgnoreCardData = new CMDIgnoreCardData();
            btrd->ReadDouble(cmdIgnoreCardData->m_dNextTurnId);
            btrd->ReadDouble(cmdIgnoreCardData->m_dIgnoreTurnId);
            CCLOG("OnExtensionResponse: SC_CLIENT_BO_LUOT");
            NotificationCenter::getInstance()->postNotification(SC_CLIENT_BO_LUOT, (Ref*)cmdIgnoreCardData);
            CC_SAFE_DELETE(cmdIgnoreCardData);
        }
        else if(strcmp(cmd, C_CLIENT_CHANGE_ROUND) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            CCLOG("OnExtensionResponse: C_CLIENT_CHANGE_ROUND");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_CHANGE_ROUND, (Ref*)userData);
        }
        else if(strcmp(cmd, C_CLIENT_FINISH) == 0)
        {
            vector<CMDFinishData*>* vCMDFinishData = new vector<CMDFinishData*>();
            while(btrd->Position() < btrd->Length())
            {
                CMDFinishData* cmdFinishData = new CMDFinishData();
                btrd->ReadUTF(cmdFinishData->m_sName);
                btrd->ReadDouble(cmdFinishData->m_dId);
                btrd->ReadUTF(cmdFinishData->m_sDesc);
                btrd->ReadDouble(cmdFinishData->m_dMoney);
                btrd->ReadShort(cmdFinishData->m_sLevel);
                btrd->ReadDouble(cmdFinishData->m_dChangeMoney);
                btrd->ReadShort(cmdFinishData->m_sCardsRemain);
                
                for(int i = 0; i < cmdFinishData->m_sCardsRemain; i++)
                {
                    short cardId;
                    btrd->ReadShort(cardId);
                    cmdFinishData->m_vCardsIdRemain->push_back(cardId);
                }
                bool isWin = false;
                btrd->ReadBool(isWin);
                if(isWin)
                {
                    btrd->ReadShort(cmdFinishData->m_sRank);
                    if(cmdFinishData->m_sRank == FN_TOI_NHAT
                       || cmdFinishData->m_sRank == FN_RONG
                       || cmdFinishData->m_sRank == FN_DONG_HOA
                       || cmdFinishData->m_sRank == FN_RONG_DONG_HOA)
                    {
                        cmdFinishData->m_bwin = true;
                    }
                }
                else
                {
                    cmdFinishData->m_sRank = FN_TOI_CHOT;
                    cmdFinishData->m_bwin = false;
                }
                vCMDFinishData->push_back(cmdFinishData);
            }
            CCLOG("OnExtensionResponse: C_CLIENT_FINISH");
            GlobalVariable::m_vCMDFinishData = vCMDFinishData;
            NotificationCenter::getInstance()->postNotification(C_CLIENT_FINISH, (Ref*)vCMDFinishData);
        }
        else if(strcmp(cmd, C_CLIENT_END_SHOW_RESULT) == 0)
        {
            CCLOG("OnExtensionResponse: C_CLIENT_END_SHOW_RESULT");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_END_SHOW_RESULT, nullptr);
        }
        else if(strcmp(cmd, C_CLIENT_STARTID) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            CCLOG("User co nut Start la %f",userData->m_dUID);
            CCLOG("OnExtensionResponse: C_CLIENT_STARTID");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_STARTID, (Ref*)userData);
        }
        else if(strcmp(cmd, C_CLIENT_LOBBY) == 0)
        {
            SFSResponse::proc_ClientLobby(btrd);
            CCLOG("OnExtensionResponse: C_CLIENT_LOBBY");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_LOBBY, NULL);
        }
        else if(strcmp(cmd, SC_COMMAND_AUTO) == 0)
        {
            bool bAuto;
            btrd->ReadBool(bAuto);
            CCLOG("OnExtensionResponse: SC_COMMAND_AUTO");
            NotificationCenter::getInstance()->postNotification(SC_COMMAND_AUTO, (Ref*)bAuto);
        }
        else if (strcmp(cmd, C_COMMAND_CHATCHEM) == 0)
        {
            CMDKillData* cmdKillData = new CMDKillData();
            btrd->ReadDouble(cmdKillData->m_dKillId);
            btrd->ReadDouble(cmdKillData->m_dDeadId);
            btrd->ReadInt(cmdKillData->m_iMoneyChanged);
            CCLOG("OnExtensionResponse: C_COMMAND_CHATCHEM");
            NotificationCenter::getInstance()->postNotification(C_COMMAND_CHATCHEM, (Ref*)cmdKillData);
        }
        else if (strcmp(cmd, C_CLIENT_DEAD_2) == 0)
        {
            NotificationCenter::getInstance()->postNotification(C_CLIENT_DEAD_2, NULL);
            CCLOG("OnExtensionResponse: C_CLIENT_DEAD_2");
        }
        else if (strcmp(cmd, C_CLIENT_RESET_GAME) == 0)
        {
            NotificationCenter::getInstance()->postNotification(C_CLIENT_RESET_GAME, NULL);
            CCLOG("OnExtensionResponse: C_CLIENT_RESET_GAME");
        }
        else if (strcmp(cmd, C_COMMAND_REMINDS) == 0)
        {
            //var o:Object = new Object();
            //o.msg=b.readUTF();
            //return o;
            NotificationCenter::getInstance()->postNotification(C_COMMAND_REMINDS, NULL);
            CCLOG("OnExtensionResponse: C_COMMAND_REMINDS");
        }
        else if (strcmp(cmd, C_GET_MIN_MAX_STAKE) == 0)
        {
            CMDMinMaxStake* cmdMinMaxStake = new CMDMinMaxStake();
            btrd->ReadInt(cmdMinMaxStake->minStake);
            btrd->ReadInt(cmdMinMaxStake->maxStake);
            GlobalVariable::m_pDataMinMaxStake = cmdMinMaxStake;
            CCLOG("OnExtensionResponse: C_GET_MIN_MAX_STAKE");
            NotificationCenter::getInstance()->postNotification(C_GET_MIN_MAX_STAKE, (Ref*)cmdMinMaxStake);
        }
    }
    else if(pGameId == 1)
    {
        if (strcmp(cmd, SS_R_ERROR) == 0)
        {
            CMDErrorData* cmdErrorData = new CMDErrorData();
            btrd->ReadBool(cmdErrorData->m_bStatus);
            btrd->ReadUTF(cmdErrorData->m_sCommand);
            btrd->ReadUTF(cmdErrorData->m_sMessage);
            CCLOG("OnExtensionResponse: SS_R_ERROR");
            NotificationCenter::getInstance()->postNotification(SS_R_ERROR, (Ref*)cmdErrorData);
            CC_SAFE_DELETE(cmdErrorData);
        }
        else if(strcmp(cmd, C_CLIENT_USER_OUT_ROOM) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
            {
                if(GlobalVariable::m_vPlayers->at(i)->m_dId == userData->m_dUID)
                {
                    GlobalVariable::m_vPlayers->erase(GlobalVariable::m_vPlayers->begin() + i);
                }
            }
            sortPlayers();
            CCLOG("OnExtensionResponse: C_CLIENT_USER_OUT_ROOM");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_USER_OUT_ROOM, (Ref*)userData);
            CC_SAFE_DELETE(userData);
        }
        else if(strcmp(cmd, C_CLIENT_LOBBY) == 0)
        {
            SFSResponse::proc_ClientLobby(btrd);
            CCLOG("OnExtensionResponse: C_CLIENT_LOBBY");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_LOBBY, NULL);
        }
        else if(strcmp(cmd, SS_R_CONFIG) == 0)
        {
            SSCMDConfigData* ssCMDConfigData = new SSCMDConfigData();
            btrd->ReadInt(ssCMDConfigData->m_iTime);
            btrd->ReadInt(ssCMDConfigData->m_iStake);
            GlobalVariable::m_cSetData->m_iTime = ssCMDConfigData->m_iTime;
            GlobalVariable::m_cSetData->m_iCuoc = ssCMDConfigData->m_iStake;
            CCLOG("OnExtensionResponse: SS_R_CONFIG");
            NotificationCenter::getInstance()->postNotification(SS_R_CONFIG, (Ref*)ssCMDConfigData);
            CC_SAFE_DELETE(ssCMDConfigData);
        }
        else if(strcmp(cmd, SS_R_RENEW_SFS_ID) == 0)
        {
            SSCMDRenewData* renewData = new SSCMDRenewData();
            btrd->ReadInt(renewData->m_iOldSFSId);
            btrd->ReadInt(renewData->m_iNewSFSId);
            for (int i = 0, l = GlobalVariable::m_vPlayersSorted->size(); i < l; i++)
            {
                if (GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId == renewData->m_iOldSFSId)
                {
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId = renewData->m_iNewSFSId;
                }
            }
            for (int i = 0, l = GlobalVariable::m_vPlayers->size(); i < l; i++)
            {
                if (GlobalVariable::m_vPlayers->at(i)->m_iSfsId == renewData->m_iOldSFSId)
                {
                    GlobalVariable::m_vPlayers->at(i)->m_iSfsId = renewData->m_iNewSFSId;
                }
            }
            CCLOG("OnExtensionResponse: SS_R_RENEW_SFS_ID");
            NotificationCenter::getInstance()->postNotification(SS_R_RENEW_SFS_ID, nullptr);
            CC_SAFE_DELETE(renewData);
        }
        else if(strcmp(cmd, SS_R_USER_DATA) == 0)
        {
            SSCMDGameData* ssCMDGameData = new SSCMDGameData();
            GlobalVariable::m_vPlayers->clear();
            ssCMDGameData->m_bSpec = true;
            ssCMDGameData->m_bPlaying = true;
            if(btrg != NULL)
            {
                ssCMDGameData->m_bSpec = false;
                if(btrg->Length() > 0)
                {
                    btrg->ReadInt(ssCMDGameData->m_dStartSFSID);
                    btrg->ReadBool(ssCMDGameData->m_bPlaying);
                }
            }
            btrd->ReadInt(ssCMDGameData->m_iNOPlayers);
            int index = 0;
            while(index < ssCMDGameData->m_iNOPlayers)
            {
                PlayerData* playerData = new PlayerData();
                long lenghtUserData;
                btrd->ReadInt(lenghtUserData);
                btrd->ReadInt(playerData->m_iIndex);
                if(playerData->m_iIndex == 0)
                {
                    playerData->m_bHost = true;
                }
                btrd->ReadInt(playerData->m_iExp);
                btrd->ReadInt(playerData->m_iSfsId);
                btrd->ReadUTF(playerData->m_sName);
                btrd->ReadDouble(playerData->m_dId);
                btrd->ReadDouble(playerData->m_dMoney);
                btrd->ReadDouble(playerData->m_dMoneyTour);
                btrd->ReadInt(playerData->m_iType);
                btrd->ReadInt(playerData->m_iPlatform);
                if(playerData->m_dId == GlobalVariable::m_pUser->m_dId)
                {
                    GlobalVariable::m_pUser->m_iSfsId = playerData->m_iSfsId;
                    if(playerData->m_iIndex == 0)
                    {
                        GlobalVariable::m_pUser->m_bHost = true;
                    }
                    else
                    {
                        GlobalVariable::m_pUser->m_bHost = false;
                    }
                }
                //ssCMDGameData->m_vPlayers->push_back(playerData);
                GlobalVariable::m_vPlayers->push_back(playerData);
                index++;
            }
            sortPlayers();
            int indexSpec = 0;
            if(GlobalVariable::m_vPlayersSorted->size() == 4)
            {
                for(indexSpec = 0; indexSpec < GlobalVariable::m_vPlayersSorted->size(); indexSpec++)
                {
                    if(GlobalVariable::m_pUser->m_iSfsId == GlobalVariable::m_vPlayersSorted->at(indexSpec)->m_iSfsId)
                    {
                        break;
                    }
                }
            }
            if(indexSpec >= 4)
            {
                ssCMDGameData->m_bSpec = true;
            }
            GlobalVariable::m_startGameData = ssCMDGameData;
            CCLOG("OnExtensionResponse: SS_R_USER_DATA");
            NotificationCenter::getInstance()->postNotification(SS_R_USER_DATA, nullptr);
        }
        else if(strcmp(cmd, SS_R_SPECTATOR) == 0)
        {
            long iNOSpec;
            btrd->ReadInt(iNOSpec);
            GlobalVariable::m_bSpectator = iNOSpec;
            CCLOG("OnExtensionResponse: SS_R_SPECTATOR");
            NotificationCenter::getInstance()->postNotification(SS_R_SPECTATOR, NULL);
        }
        else if(strcmp(cmd, SS_R_MOD) == 0)
        {
            long iNOMod;
            SSCMDGameData* ssCMDGameData = new SSCMDGameData();
            ssCMDGameData->m_bMod = true;
            btrd->ReadInt(iNOMod);
            CCLOG("OnExtensionResponse: SS_R_MOD");
            NotificationCenter::getInstance()->postNotification(SS_R_MOD, (Ref*)ssCMDGameData);
            CC_SAFE_DELETE(ssCMDGameData);
        }
        else if(strcmp(cmd, SS_R_CARDLIST) == 0)
        {
            SSCMDStartData* startData = new SSCMDStartData();
            long startID;
            btrd->ReadInt(startID);
            startData->m_dStartId = startID;
            btrd->ReadInt(startData->m_iTime);
            string str;
            btrd->ReadUTF(str);
            sscanf(str.c_str(), "[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d]",
                   &startData->m_aCards[0],
                   &startData->m_aCards[1],
                   &startData->m_aCards[2],
                   &startData->m_aCards[3],
                   &startData->m_aCards[4],
                   &startData->m_aCards[5],
                   &startData->m_aCards[6],
                   &startData->m_aCards[7],
                   &startData->m_aCards[8],
                   &startData->m_aCards[9],
                   &startData->m_aCards[10],
                   &startData->m_aCards[11],
                   &startData->m_aCards[12]);
            CCLOG("OnExtensionResponse: SS_R_CARDLIST");
            NotificationCenter::getInstance()->postNotification(SS_R_CARDLIST, (Ref*)startData);
            CC_SAFE_DELETE(startData);
        }
        else if(strcmp(cmd, SS_R_FULLTIME) == 0)
        {
            CCLOG("OnExtensionResponse: SS_R_FULLTIME");
            NotificationCenter::getInstance()->postNotification(SS_R_FULLTIME, (Ref*)NULL);
        }
        else if(strcmp(cmd, SS_R_USER_DATA_END) == 0)
        {
            string sPlayersData;
            string sCompareData;
            string sSapData;
            btrd->ReadUTF(sPlayersData);
            btrd->ReadUTF(sCompareData);
            btrd->ReadUTF(sSapData);
            CCLOG("OnExtensionResponse: sPlayersData %s", sPlayersData.c_str());
            CCLOG("OnExtensionResponse: sCompareData %s", sCompareData.c_str());
            CCLOG("OnExtensionResponse: sSapData     %s", sSapData.c_str());
            rapidjson::Document document;
            
            // Parse user end data
            document.Parse<0>(sPlayersData.c_str());
            vector<SSCMDUserEndData*>* m_vUsersEndData = new vector<SSCMDUserEndData*>();
            for(int i = 0; i < document.Size(); i++)
            {
                SSCMDUserEndData* userEndData = new SSCMDUserEndData();
                userEndData->m_dSFSId        = document[i]["sfsId"].GetInt();
                userEndData->m_iIndex        = document[i]["index"].GetInt();
                userEndData->m_iCardListType = document[i]["cardListType"].GetInt();
                if(userEndData->m_iCardListType != 0 && userEndData->m_iCardListType != 1)
                {
                    string str = document[i]["typeCard"].GetString();
                    sscanf(str.c_str(), "%d,%d,%d",
                           &userEndData->m_aTypesCard[0],
                           &userEndData->m_aTypesCard[1],
                           &userEndData->m_aTypesCard[2]);
                }
                if (userEndData->m_iCardListType == 1) {
                    userEndData->m_iMauBinh = document[i]["maubinh"].GetInt();
                }
                string str = document[i]["cardlist"].GetString();
                sscanf(str.c_str(), "%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d",
                       &userEndData->m_aCards[0],
                       &userEndData->m_aCards[1],
                       &userEndData->m_aCards[2],
                       &userEndData->m_aCards[3],
                       &userEndData->m_aCards[4],
                       &userEndData->m_aCards[5],
                       &userEndData->m_aCards[6],
                       &userEndData->m_aCards[7],
                       &userEndData->m_aCards[8],
                       &userEndData->m_aCards[9],
                       &userEndData->m_aCards[10],
                       &userEndData->m_aCards[11],
                       &userEndData->m_aCards[12]);
                m_vUsersEndData->push_back(userEndData);
            }
            
            // Parse compare end data
            document.Clear();
            vector<SSCMDCompareEndData*>* m_vCompareData = new vector<SSCMDCompareEndData*>();
            if (sCompareData.size() > 0) {
                document.Parse<0>(sCompareData.c_str());
                for (int i = 0, l = document.Size(); i < l; i++) {
                    SSCMDCompareEndData* data = new SSCMDCompareEndData();
                    data->idx1 = document[i]["idx1"].GetInt();
                    data->idx2 = document[i]["idx2"].GetInt();
                    std::string soChi = document[i]["soChi"].GetString();
                    data->m_vSoChi = { 0, 0, 0 };
                    sscanf(soChi.c_str(), "%d, %d, %d",
                           &data->m_vSoChi[0],
                           &data->m_vSoChi[1],
                           &data->m_vSoChi[2]);
                    m_vCompareData->push_back(data);
                }
            }
            
            // Parse sap data
            document.Clear();
            vector<SSCMDSapEndData*>* m_vSapData = new vector<SSCMDSapEndData*>();
            if (sSapData.size() > 0) {
                document.Parse<0>(sSapData.c_str());
                for (int i = 0, l = document.Size(); i < l; i++) {
                    SSCMDSapEndData* data = new SSCMDSapEndData();
                    if (document[i].HasMember("sfsId")) {
                        data->sfsID = document[i]["sfsId"].GetInt();
                    }
                    if (document[i].HasMember("thuacalang")) {
                        data->thuacalang = document[i]["thuacalang"].GetBool();
                    }
                    if (document[i].HasMember("thangcalang")) {
                        data->thangcalang = document[i]["thangcalang"].GetBool();
                    }
                    if (document[i].HasMember("xinthuacalang")) {
                        data->xinthuacalang = document[i]["xinthuacalang"].GetBool();
                    }
                    m_vSapData->push_back(data);
                }
            }
            
            CCLOG("OnExtensionResponse: SS_R_USER_DATA_END");
            SSCMDEndGameData* endGameData = new SSCMDEndGameData();
            endGameData->m_vUsersEndData = m_vUsersEndData;
            endGameData->m_vCompareEndData = m_vCompareData;
            endGameData->m_vSapEndData = m_vSapData;
            NotificationCenter::getInstance()->postNotification(SS_R_USER_DATA_END, (Ref*)endGameData);
        }
        else if(strcmp(cmd, SS_R_USER_DATA_END_VIEW) == 0)
        {
            string str;
            btrd->ReadUTF(str);
            CCLOG("OnExtensionResponse: %s", str.c_str());
            rapidjson::Document document;
            document.Parse<0>(str.c_str());
            vector<SSCMDUserEndViewData*>* m_vUsersEndViewData = new vector<SSCMDUserEndViewData*>();
            for(int i = 0; i < document.Size(); i++)
            {
                SSCMDUserEndViewData* userEndViewData = new SSCMDUserEndViewData();
                
                userEndViewData->m_sName         = document[i]["name"].GetString();
                userEndViewData->m_dUid          = document[i]["tamtayId"].GetDouble();
                userEndViewData->m_dMoneyChanged = document[i]["moneyChange"].GetDouble();
                userEndViewData->m_dMoneyReal    = document[i]["moneyReal"].GetDouble();
                userEndViewData->m_sDes          = document[i]["desc"].GetString();
                m_vUsersEndViewData->push_back(userEndViewData);
                
                if (userEndViewData->m_dUid == GlobalVariable::m_pUser->m_dId)
                {
                    if (userEndViewData->m_dMoneyChanged > 0)
                    {
                        GlobalVariable::m_bSusunWin=true;
                    }
                    GlobalVariable::m_pUser->m_dMoney = userEndViewData->m_dMoneyReal;
                    NotificationCenter::getInstance()->postNotification(EVENT_UPDATE_USER_INFO, nullptr);
                    continue;
                }
            }
            CCLOG("OnExtensionResponse: SS_R_USER_DATA_END_VIEW");
            NotificationCenter::getInstance()->postNotification(SS_R_USER_DATA_END_VIEW, (Ref*)m_vUsersEndViewData);
        }
        else if(strcmp(cmd, SS_R_UPDATE_END_GAME) == 0)
        {
            btrd->ReadDouble(GlobalVariable::m_pUser->m_dMoney);
            btrd->ReadDouble(GlobalVariable::m_pUser->m_dMoneyTour);
            btrd->ReadInt(GlobalVariable::m_pUser->m_iTotal);
            btrd->ReadInt(GlobalVariable::m_pUser->m_iWin);
            btrd->ReadInt(GlobalVariable::m_pUser->m_iExp);
            CCLOG("OnExtensionResponse: SS_R_UPDATE_END_GAME");
            NotificationCenter::getInstance()->postNotification(SS_R_UPDATE_END_GAME, nullptr);
            NotificationCenter::getInstance()->postNotification(EVENT_UPDATE_USER_INFO, nullptr);
        }
        else if(strcmp(cmd, SS_R_RESTART) == 0)
        {
            CCLOG("OnExtensionResponse: SS_R_RESTART");
            NotificationCenter::getInstance()->postNotification(SS_R_RESTART, (Ref*)NULL);
        }
        else if(strcmp(cmd, SS_R_PING) == 0)
        {
            SFSConnection::getInstance()->ping();
        }
        else if(strcmp(cmd, SS_R_XEPXONG) == 0)
        {
            SSCMDSortedFinishData* sortedFinishData = new SSCMDSortedFinishData();
            long uid;
            btrd->ReadInt(uid);
            sortedFinishData->m_dUId = uid;
            btrd->ReadBool(sortedFinishData->m_bSortFinish);
            if(btrd->Position() < btrd->Length())
            {
                btrd->ReadBool(sortedFinishData->m_bBinhlung);
            }
            CCLOG("OnExtensionResponse: SS_R_XEPXONG");
            NotificationCenter::getInstance()->postNotification(SS_R_XEPXONG, (Ref*)sortedFinishData);
        }
        else if(strcmp(cmd, SS_R_MAU_BINH) == 0)
        {
            SSCMDMaubinhData* maubinhData = new SSCMDMaubinhData();
            long sid;
            btrd->ReadInt(sid);
            maubinhData->m_dSFSId = sid;
            btrd->ReadInt(maubinhData->m_iType);
            CCLOG("OnExtensionResponse: SS_R_MAU_BINH");
            NotificationCenter::getInstance()->postNotification(SS_R_MAU_BINH, (Ref*)maubinhData);
        }
        else if(strcmp(cmd, SS_R_USER_DATA_RESUME) == 0)
        {
            SSCMDGameData* ssCMDGameData = new SSCMDGameData();
            GlobalVariable::m_vPlayers->clear();
            ssCMDGameData->m_bReconnect = true;
            ssCMDGameData->m_bSpec = false;
            //btr key "g"
            btrg->ReadInt(ssCMDGameData->m_iTimeRemain); //time remain
            string lstFinishSortedUsers;
            btrg->ReadUTF(lstFinishSortedUsers);
            CCLOG("lstFinishSortedUsers %s", lstFinishSortedUsers.c_str());
            //[1234,4567]
            if(lstFinishSortedUsers.length() > 0)
            {
                size_t n = std::count(lstFinishSortedUsers.begin(), lstFinishSortedUsers.end(), ',');
                int arr[4] = {0, 0, 0, 0};
                string format = "";
                if(n == 0)
                {
                    format = "[%d]";
                    sscanf(lstFinishSortedUsers.c_str(), format.c_str(), &arr[0]);
                }
                else if(n == 1)
                {
                    format = "[%d,%d]";
                    sscanf(lstFinishSortedUsers.c_str(), format.c_str(), &arr[0], &arr[1]);
                }
                else if(n == 2)
                {
                    format = "[%d,%d,%d]";
                    sscanf(lstFinishSortedUsers.c_str(), format.c_str(), &arr[0], &arr[1], &arr[2]);
                }
                else if(n == 3)
                {
                    format = "[%d,%d,%d,%d]";
                    sscanf(lstFinishSortedUsers.c_str(), format.c_str(), &arr[0], &arr[1], &arr[2], &arr[3]);
                }
                
                for(int i = 0; i < 4; i++)
                {
                    if(arr[i] != 0)
                    {
                        ssCMDGameData->m_vSortedSfsIds.push_back(arr[i]);
                        CCLOG("Sorted Player sfsID: %d", arr[i]);
                    }
                }
            }
            //while
            
            //btr key "d"
            //user in table
            
            btrd->ReadInt(ssCMDGameData->m_iNOPlayers);
            int index = 0;
            while(index < ssCMDGameData->m_iNOPlayers)
            {
                PlayerData* playerData = new PlayerData();
                long lenghtUserData;
                btrd->ReadInt(lenghtUserData);
                btrd->ReadInt(playerData->m_iIndex);
                if(playerData->m_iIndex == 0)
                {
                    playerData->m_bHost = true;
                }
                btrd->ReadInt(playerData->m_iExp);
                btrd->ReadInt(playerData->m_iSfsId);
                btrd->ReadUTF(playerData->m_sName);
                btrd->ReadDouble(playerData->m_dId);
                btrd->ReadDouble(playerData->m_dMoney);
                btrd->ReadDouble(playerData->m_dMoneyTour);
                btrd->ReadInt(playerData->m_iType);
                btrd->ReadInt(playerData->m_iPlatform);
                //ssCMDGameData->m_vPlayers->push_back(playerData);
                GlobalVariable::m_vPlayers->push_back(playerData);
                index++;
            }
            
            //btr key "n"
            //user reconnect
            PlayerData* playerData = new PlayerData();
            btrn->ReadInt(playerData->m_iIndex);
            if(playerData->m_iIndex == 0)
            {
                playerData->m_bHost = true;
                GlobalVariable::m_pUser->m_bHost = true;
            }
            else
            {
                GlobalVariable::m_pUser->m_bHost = false;
            }
            btrn->ReadInt(playerData->m_iExp);
            btrn->ReadInt(playerData->m_iSfsId);
            btrn->ReadUTF(playerData->m_sName);
            btrn->ReadDouble(playerData->m_dId);
            btrn->ReadDouble(playerData->m_dMoney);
            btrn->ReadDouble(playerData->m_dMoneyTour);
            btrn->ReadInt(playerData->m_iType);
            string lstCards;
            btrn->ReadUTF(lstCards);
            sscanf(lstCards.c_str(), "[%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d]",
                   &playerData->m_aCards[0],
                   &playerData->m_aCards[1],
                   &playerData->m_aCards[2],
                   &playerData->m_aCards[3],
                   &playerData->m_aCards[4],
                   &playerData->m_aCards[5],
                   &playerData->m_aCards[6],
                   &playerData->m_aCards[7],
                   &playerData->m_aCards[8],
                   &playerData->m_aCards[9],
                   &playerData->m_aCards[10],
                   &playerData->m_aCards[11],
                   &playerData->m_aCards[12]);
            btrn->ReadInt(playerData->m_iTypeMB);
            btrn->ReadInt(playerData->m_iPlatform);
            //ssCMDGameData->m_vPlayers->push_back(playerData);
            GlobalVariable::m_vPlayers->push_back(playerData);
            sortPlayers();
            GlobalVariable::m_startGameData = ssCMDGameData;
            CCLOG("OnExtensionResponse: SS_R_USER_DATA_RESUME");
            NotificationCenter::getInstance()->postNotification(SS_R_USER_DATA, nullptr);
        }
        else if (strcmp(cmd, SS_R_MIN_MAX_STAKE) == 0)
        {
            CMDMinMaxStake* cmdMinMaxStake = new CMDMinMaxStake();
            btrd->ReadInt(cmdMinMaxStake->minStake);
            btrd->ReadInt(cmdMinMaxStake->maxStake);
            GlobalVariable::m_pDataMinMaxStake = cmdMinMaxStake;
            CCLOG("OnExtensionResponse: SS_R_MIN_MAX_STAKE");
            NotificationCenter::getInstance()->postNotification(SS_R_MIN_MAX_STAKE, (Ref*)cmdMinMaxStake);
        }
    }
    else if(pGameId == 2)
    {
        if(strcmp(cmd, T_CHANGEPOT) == 0)
        {
            double player;
            btrd->ReadDouble(player);
            short setpot;
            btrd->ReadShort(setpot);
            GlobalVariable::getInstance()->m_sPot=setpot;
            CCLOG("OnExtensionResponse: T_CHANGEPOT");
            NotificationCenter::getInstance()->postNotification(T_CHANGEPOT,NULL);
        }
        else if(strcmp(cmd, C_CLIENT_LOBBY) == 0)
        {
            SFSResponse::proc_ClientLobby(btrd);
            CCLOG("OnExtensionResponse: C_CLIENT_LOBBY");
            NotificationCenter::getInstance()->postNotification(C_CLIENT_LOBBY, NULL);
        }
        else if (strcmp(cmd, T_JOIN_TABLE) == 0)
        {
            CCLOG("%ld",btrd->Length());
            
            CMDSetDataT* cmdSetData = new CMDSetDataT();
            vector<CMDDropCardDataT*>* vCMDDropCardData=new vector<CMDDropCardDataT*>();
            
            btrd->ReadInt(cmdSetData->m_iCuoc);
            btrd->ReadInt(cmdSetData->m_iTime);
            
            //            GlobalVariable::m_iGameTime=cmdSetData->m_iTime;
            
            btrd->ReadInt(cmdSetData->m_iType);
            btrd->ReadBool(cmdSetData->m_bPlaying);
            GlobalVariable::m_vPlayers->clear();
            
            CCLOG("Phase1");
            //choi roi nen reconnect
            if(cmdSetData->m_bPlaying)
            {
                btrd->ReadDouble(cmdSetData->m_dNextTurnId);
                btrd->ReadShort(cmdSetData->m_sState);
                btrd->ReadBool(cmdSetData->m_bReconnect);
                CCLOG("Phase2");
                if(cmdSetData->m_bReconnect==true)
                {
                    if(cmdSetData->m_dNextTurnId==GlobalVariable::m_pUser->m_dId)
                    {
                        bool CanU;
                        btrd->ReadBool(CanU);
                        if (cmdSetData->m_sState==1)
                        {
                            bool CanEat;
                            btrd->ReadBool(CanEat);
                            GlobalVariable::m_bCanEat=CanEat;
                        }
                        else
                        {
                            
                        }
                    }
                }
            }
            
            //chua choi nen ko reconnect
            if(!cmdSetData->m_bPlaying)
            {
                while( btrd->Position() < btrd->Length())
                {
                    PlayerData* pPlayerData = new PlayerData();
                    pPlayerData->parseFromByteData2(btrd);
                    if(GlobalVariable::m_vPlayers->size() == 0)
                    {
                        pPlayerData->m_bHost = true;
                    }
                    GlobalVariable::m_vPlayers->push_back(pPlayerData);
                }
                CCLOG("Phase31");
            }
            //choi r nen reconnect
            else
            {
                GlobalVariable::m_iDeckNo=52;
                CCLOG("Phase32");
                for(int i=0;i<3;i++)
                {
                    CMDDropCardDataT* dropCardData=new CMDDropCardDataT();
                    
                    PlayerData* pPlayerData=new PlayerData();
                    pPlayerData->parseFromByteData2(btrd);
                    
                    //lay data cho dropcard
                    dropCardData->m_dIdPlayerDrop=pPlayerData->m_dId;
                    
                    //lay phom
                    btrd->ReadShort(dropCardData->m_sTotalPhom);
                    
                    CCLOG("Phase33");
                    for(int j=0;j<dropCardData->m_sTotalPhom;j++)
                    {
                        short numbercarddrop=0;
                        //so dau tien la phom,moi phom cach nhau "-1"
                        short m_sPhom;
                        btrd->ReadShort(m_sPhom);
                        
                        //cards in phom
                        short iTemp;
                        btrd->ReadShort(iTemp);
                        if(j==0)
                        {
                            while(iTemp!=-1)
                            {
                                numbercarddrop+=1;
                                dropCardData->m_vCardIdPhom1->push_back(iTemp);
                                btrd->ReadShort(iTemp);
                            }
                        }
                        if(j==1)
                        {
                            while(iTemp!=-1)
                            {
                                numbercarddrop+=1;
                                dropCardData->m_vCardIdPhom2->push_back(iTemp);
                                btrd->ReadShort(iTemp);
                            }
                        }
                        if(j==2)
                        {
                            while(iTemp!=-1)
                            {
                                numbercarddrop+=1;
                                dropCardData->m_vCardIdPhom3->push_back(iTemp);
                                btrd->ReadShort(iTemp);
                            }
                        }
                        if(j==3)
                        {
                            while(iTemp!=-1)
                            {
                                numbercarddrop+=1;
                                dropCardData->m_vCardIdPhom4->push_back(iTemp);
                                btrd->ReadShort(iTemp);
                            }
                        }
                        CCLOG("Bai nguoi choi so %d da ha %hd",i,numbercarddrop);
                        dropCardData->m_sNumberCardDrop=numbercarddrop;
                        GlobalVariable::m_iDeckNo-=numbercarddrop;
                        CCLOG("Tong so bai con lai %d",GlobalVariable::m_iDeckNo);
                    }
                    CCLOG("Phase4");
                    //lay bai tren tay
                    short lCards;
                    btrd->ReadShort(lCards);
                    CCLOG("Bai tren tay nguoi choi so %d %hd",i,lCards);
                    GlobalVariable::m_iDeckNo-=lCards;
                    CCLOG("Tong so bai con lai %d",GlobalVariable::m_iDeckNo);
                    dropCardData->m_sTotalCardInHand=lCards;
                    if(cmdSetData->m_bReconnect)
                    {
                        if(pPlayerData->m_dId==GlobalVariable::m_pUser->m_dId)
                        {
                            GlobalVariable::m_iTotalCardinHand=(int)dropCardData->m_sTotalCardInHand-1;
                            GlobalVariable::m_pUser->m_vCardId->clear();
                            for(int i = 0; i < lCards; i++)
                            {
                                short c;
                                btrd->ReadShort(c);
                                GlobalVariable::m_pUser->m_vCardId->push_back(c);
                            }
                        }
                    }
                    else
                    {
                        cmdSetData->m_bSpectator = true;
                    }
                    CCLOG("Phase5");
                    GlobalVariable::m_vPlayers->push_back(pPlayerData);
                    vCMDDropCardData->push_back(dropCardData);
                }
                while (btrd->Position() < btrd->Length())
                {
                    short a;
                    btrd->ReadShort(a);
                    cmdSetData->m_vCardId->push_back(a);
                }
                
                CCLOG("Tong so quan bai da danh %lu",cmdSetData->m_vCardId->size());
                CCLOG("%i",GlobalVariable::m_iDeckNo);
                GlobalVariable::m_iDeckNo-=cmdSetData->m_vCardId->size();
                CCLOG("%i",GlobalVariable::m_iDeckNo);
            }
            
            sortPlayers();
            if(!GlobalVariable::m_pUser->m_bPlaying)
            {
                cmdSetData->m_bSpectator = true;
            }
            if(GlobalVariable::m_cSetDataT)
            {
                CC_SAFE_DELETE(GlobalVariable::m_cSetDataT);
            }
            GlobalVariable::m_cSetDataT = cmdSetData;
            GlobalVariable::m_vCMDDropCardData=vCMDDropCardData;
            
            CCLOG("OnExtensionResponse: User join in one table");
            NotificationCenter::getInstance()->postNotification(T_JOIN_TABLE, NULL);
            
        }
        else if(strcmp(cmd, T_USER_JOIN_ROOM) == 0)
        {
            PlayerData* pPlayerData = new PlayerData();
            pPlayerData->parseFromByteData2(btrd);
            GlobalVariable::m_vPlayers->push_back(pPlayerData);
            sortPlayers();
            CCLOG("OnExtensionResponse: C_CLIENT_USER_JOIN_ROOM");
            NotificationCenter::getInstance()->postNotification(T_USER_JOIN_ROOM, nullptr);
        }
        else if(strcmp(cmd, T_USER_OUT_ROOM) == 0)
        {
            CMDUserDataT* userData = new CMDUserDataT();
            btrd->ReadDouble(userData->m_dUID);
            for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
            {
                if(GlobalVariable::m_vPlayers->at(i)->m_dId == userData->m_dUID)
                {
                    GlobalVariable::m_vPlayers->erase(GlobalVariable::m_vPlayers->begin() + i);
                }
            }
            sortPlayers();
            CCLOG("OnExtensionResponse: T_USER_OUT_ROOM");
            NotificationCenter::getInstance()->postNotification(T_USER_OUT_ROOM, (Ref*)userData);
            CC_SAFE_DELETE(userData);
        }
        else if (strcmp(cmd, T_GET_MIN_MAX) == 0)
        {
            CMDMinMaxStakeT* cmdMinMaxStake = new CMDMinMaxStakeT();
            btrd->ReadInt(cmdMinMaxStake->minStake);
            btrd->ReadInt(cmdMinMaxStake->maxStake);
            GlobalVariable::m_pDataMinMaxStakeT = cmdMinMaxStake;
            CCLOG("OnExtensionResponse: C_GET_MIN_MAX_STAKE");
            NotificationCenter::getInstance()->postNotification(T_GET_MIN_MAX, (Ref*)cmdMinMaxStake);
        }
        else if(strcmp(cmd, T_START_GAME) == 0)
        {
            GlobalVariable::m_pUser->m_vCardId->clear();
            CMDStartGameDataT* cmdStartGameData = new CMDStartGameDataT();
            //player danh
            double hitter;
            btrd->ReadDouble(hitter);
            //id den turn
            btrd->ReadDouble(cmdStartGameData->m_dNextTurnId);
            if(cmdStartGameData->m_dNextTurnId==GlobalVariable::m_pUser->m_dId)
            {
                GlobalVariable::m_iTotalCardinHand=12;
            }
            else
            {
                GlobalVariable::m_iTotalCardinHand=11;
            }
            GlobalVariable::m_dIdPlayerStart=cmdStartGameData->m_dNextTurnId;
            //so cuoc trong pot
            short m_sPot;
            btrd->ReadShort(m_sPot);
            GlobalVariable::getInstance()->m_sPot=m_sPot;
            
            if(btrd->Position()<btrd->Length())
            {
                //so quan bai trong tay
                short numbercard;
                btrd->ReadShort(numbercard);
                
                for(int i=0;i<numbercard;i++)
                {
                    short c;
                    btrd->ReadShort(c);
                    GlobalVariable::m_pUser->m_vCardId->push_back(c);
                }
                
                if(btrd->Position()<btrd->Length())
                {
                    bool canU=false;
                    btrd->ReadBool(canU);
                }
            }
            
            auto sortInccreaseFunc = [](const int &a, const int &b){ return a < b;};
            std::sort(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), sortInccreaseFunc);
            CCLOG("OnExtensionResponse: T_START_GAME");
            NotificationCenter::getInstance()->postNotification(T_START_GAME, (Ref*)cmdStartGameData);
            CC_SAFE_DELETE(cmdStartGameData);
        }
        else if(strcmp(cmd, T_DANH_BAI) == 0)
        {
            CMDFireCardData* fireCardData = new CMDFireCardData();
            btrd->ReadDouble(fireCardData->m_dUserFireId);
            btrd->ReadDouble(fireCardData->m_dNextTurnId);
            
            bool canDraw,canEat;
            
            if(fireCardData->m_dNextTurnId==GlobalVariable::m_pUser->m_dId)
            {
                if(GlobalVariable::m_cSetDataT->m_bSpectator==false)
                {
                    btrd->ReadBool(canDraw);
                    btrd->ReadBool(canEat);
                    GlobalVariable::m_bCanDraw=canDraw;
                    GlobalVariable::m_bCanEat=canEat;
                }
            }
            
            //quan bai danh ra
            short firedcard;
            btrd->ReadShort(firedcard);
            fireCardData->m_vCardId->push_back(firedcard);
            
            CCLOG("OnExtensionResponse: T_DANH_BAI");
            if(fireCardData->m_dUserFireId == GlobalVariable::m_pUser->m_dId)
            {
                for(int i = 0; i < fireCardData->m_vCardId->size(); i++)
                {
                    int cardId = fireCardData->m_vCardId->at(i);
                    // Remove fired card from card list
                    vector<int>::iterator iterator = std::find(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), cardId);
                    if (iterator != GlobalVariable::m_pUser->m_vCardId->end())
                    {
                        GlobalVariable::m_pUser->m_vCardId->erase(iterator);
                    }
                }
            }
            
            NotificationCenter::getInstance()->postNotification(T_DANH_BAI, (Ref*)fireCardData);
            CC_SAFE_DELETE(fireCardData);
        }
        else if(strcmp(cmd, T_AN_BAI) == 0)
        {
            NotificationCenter::getInstance()->postNotification(T_AN_BAI,NULL);
            CCLOG("OnExtensionResponse: Player an bai");
        }
        else if(strcmp(cmd, T_CLIENT_PING) == 0)
        {
            CCLOG("TOngits ping");
            SFSConnection::getInstance()->ping();
            GlobalVariable::m_bPing=true;
        }
        else if(strcmp(cmd, T_GET_START_ID) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            
            CCLOG("OnExtensionResponse: T_GET_START_ID");
            NotificationCenter::getInstance()->postNotification(T_GET_START_ID, (Ref*)userData);
        }
        else if(strcmp(cmd, T_GET_CARD_FROM_DECK) == 0)
        {
            CMDUserData* userData = new CMDUserData();
            btrd->ReadDouble(userData->m_dUID);
            bool canU=false;
            bool canDraw=false;
            short iCard=-1;
            
            if(GlobalVariable::m_pUser->m_dId==userData->m_dUID)
            {
                if(GlobalVariable::m_cSetDataT->m_bSpectator==false)
                {
                    if(GlobalVariable::m_bPing==true)
                    {
                        GlobalVariable::getInstance()->m_bDebug=true;
                        GlobalVariable::m_bPing=false;
                    }
                    else
                    {
                        btrd->ReadBool(canDraw);
                        GlobalVariable::m_bCanDraw=canDraw;
                        btrd->ReadShort(iCard);
                        btrd->ReadBool(canU);
                        GlobalVariable::m_pUser->m_vCardId->push_back(iCard);
                    }
                }
            }
            GlobalVariable::m_bPing=false;
            CCLOG("OnExtensionResponse: Get card from deck");
            NotificationCenter::getInstance()->postNotification(T_GET_CARD_FROM_DECK, (Ref*)userData);
            CC_SAFE_DELETE(userData);
        }
        else if (strcmp(cmd, T_CHANGE_SETTING_GAME) == 0)
        {
            CMDSettingInGame* obj = new CMDSettingInGame();
            btrd->ReadInt(obj->stake);
            btrd->ReadInt(obj->times);
            CCLOG("OnExtensionResponse: T_CHANGE_SETTING_GAME");
            NotificationCenter::getInstance()->postNotification(T_CHANGE_SETTING_GAME, (Ref*)obj);
        }
        else if(strcmp(cmd, T_GUI_BAI) == 0)
        {
            CMDSendCardDataT* sendCardData=new CMDSendCardDataT();
            btrd->ReadDouble(sendCardData->m_dIdGui);
            btrd->ReadDouble(sendCardData->m_dIdNhan);
            btrd->ReadShort(sendCardData->m_sidCard);
            btrd->ReadShort(sendCardData->m_sidPhom);
            bool canU=false;
            
            //remove card
            if(sendCardData->m_dIdGui==GlobalVariable::m_pUser->m_dId)
            {
                int cardId=sendCardData->m_sidCard;
                //Remove fired card from card list
                vector<int>::iterator iterator=std::find(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), cardId);
                if (iterator!=GlobalVariable::m_pUser->m_vCardId->end())
                {
                    GlobalVariable::m_pUser->m_vCardId->erase(iterator);
                }
            }
            
            //check data con sot ko
            if (btrd->Position() == btrd->Length())
            {
                CCLOG("Have no data");
            }
            
            else //is remain byte data
            {
                btrd->ReadBool(canU);
                GlobalVariable::m_bCanU=canU;
            }
            NotificationCenter::getInstance()->postNotification(T_GUI_BAI,(Ref*)sendCardData);
            CCLOG("OnExtensionResponse: Player gui bai");
            CC_SAFE_DELETE(sendCardData);
        }
        else if(strcmp(cmd, T_XACTHUC_BAO_BAI) == 0)
        {
            std::string msg;
            short time;
            btrd->ReadUTF(msg);
            btrd->ReadShort(time);
            GlobalVariable::getInstance()->m_sPopupMessage=msg;
            NotificationCenter::getInstance()->postNotification(T_XACTHUC_BAO_BAI,NULL);
        }
        else if(strcmp(cmd, T_HA_BAI) == 0)
        {
            CMDDropCardDataT* dropCardData=new CMDDropCardDataT();
            vector<CMDDropCardDataT*>* vCMDDropCardData = new vector<CMDDropCardDataT*>();
            
            btrd->ReadDouble(dropCardData->m_dIdPlayerDrop);
            btrd->ReadShort(dropCardData->m_sPhom);
            
            if(dropCardData->m_dIdPlayerDrop==GlobalVariable::m_pUser->m_dId)
            {
                if(dropCardData->m_sPhom==1)
                {
                    GlobalVariable::m_iTotalPhom=2;
                }
                else if (dropCardData->m_sPhom==2)
                {
                    GlobalVariable::m_iTotalPhom=3;
                }
                else
                {
                    GlobalVariable::m_iTotalPhom=0;
                }
            }
            
            btrd->ReadShort(dropCardData->m_sNumberCardDrop);
            
            bool canU=false;
            
            for(int i=0;i<dropCardData->m_sNumberCardDrop;i++)
            {
                short droppedcard;
                btrd->ReadShort(droppedcard);
                dropCardData->m_vCardIdDrop->push_back(droppedcard);
            }
            
            while(btrd->Position()<btrd->Length())
            {
                btrd->ReadBool(canU);
                GlobalVariable::m_bCanU=canU;
            }
            
            if(dropCardData->m_dIdPlayerDrop==GlobalVariable::m_pUser->m_dId)
            {
                GlobalVariable::m_bCanDraw=false;
                GlobalVariable::m_iTotalCardinHand-=(int)dropCardData->m_sNumberCardDrop;
                for(int i=0;i<dropCardData->m_vCardIdDrop->size();i++)
                {
                    int cardId=dropCardData->m_vCardIdDrop->at(i);
                    //Remove dropped card from card list
                    vector<int>::iterator iterator=std::find(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), cardId);
                    if (iterator!=GlobalVariable::m_pUser->m_vCardId->end())
                    {
                        GlobalVariable::m_pUser->m_vCardId->erase(iterator);
                    }
                }
            }
            vCMDDropCardData->push_back(dropCardData);
            GlobalVariable::m_vCMDDropCardData = vCMDDropCardData;
            
            CCLOG("OnExtensionResponse: Player ha bai");
            NotificationCenter::getInstance()->postNotification(T_HA_BAI,(Ref*)dropCardData);
            CC_SAFE_DELETE(dropCardData);
        }
        else if(strcmp(cmd, T_CHANGE_POSITION) == 0)
        {
            double id1,id2;
            btrd->ReadDouble(id1);
            btrd->ReadDouble(id2);
            
            bool check=true;
            for(int i=0;i<GlobalVariable::m_vPlayers->size();i++)
            {
                if(GlobalVariable::m_vPlayers->at(i)->m_dId==id2)
                {
                    for(int j=0;j<GlobalVariable::m_vPlayers->size();j++)
                    {
                        if(GlobalVariable::m_vPlayers->at(j)->m_dId==id1)
                        {
                            if(check==true)
                            {
                                PlayerData* dataTmp = GlobalVariable::m_vPlayers->at(i);
                                GlobalVariable::m_vPlayers->at(i)=GlobalVariable::m_vPlayers->at(j);
                                GlobalVariable::m_vPlayers->at(j)=dataTmp;
                                check=false;
                            }
                        }
                    }
                }
            }
            sortPlayers();
            CCLOG("OnExtensionResponse: T_CLIENT_CHANGE_ROUND");
            NotificationCenter::getInstance()->postNotification(T_CHANGE_POSITION,NULL);
        }
        else if(strcmp(cmd, T_CLIENT_FINISH) == 0)
        {
            CMDFinishDataT* cmdFinishData = new CMDFinishDataT();
            vector<CMDFinishDataT*>* vCMDFinishData = new vector<CMDFinishDataT*>();
            while(btrd->Position() < btrd->Length())
            {
                CMDFinishDataT* cmdFinishData = new CMDFinishDataT();
                btrd->ReadUTF(cmdFinishData->m_sName);
                btrd->ReadBool(cmdFinishData->m_bU);
                btrd->ReadBool(cmdFinishData->m_bBao);
                btrd->ReadDouble(cmdFinishData->m_dMoney);
                btrd->ReadShort(cmdFinishData->m_sPoint);
                
                //neu la nguoi choi
                btrd->ReadShort(cmdFinishData->m_sRangePhom);
                for(int i=0;i<cmdFinishData->m_sRangePhom;i++)
                {
                    short phom;
                    btrd->ReadShort(phom);
                    cmdFinishData->m_vPhom->push_back(phom);
                }
                btrd->ReadShort(cmdFinishData->m_sRangeQue);
                for(int i=0;i<cmdFinishData->m_sRangeQue;i++)
                {
                    short que;
                    btrd->ReadShort(que);
                    cmdFinishData->m_vQue->push_back(que);
                }
                
                btrd->ReadShort(cmdFinishData->m_sRangeMes);
                for(int i=0;i<cmdFinishData->m_sRangeMes;i++)
                {
                    std::string logs;
                    short points;
                    btrd->ReadUTF(logs);
                    cmdFinishData->m_vLogs->push_back(logs);
                    btrd->ReadShort(points);
                    cmdFinishData->m_vPoints->push_back(points);
                }
                vCMDFinishData->push_back(cmdFinishData);
            }
            
            CCLOG("OnExtensionResponse: T_CLIENT_FINISH");
            GlobalVariable::m_vCMDFinishDataT = vCMDFinishData;
            NotificationCenter::getInstance()->postNotification(T_CLIENT_FINISH, (Ref*)cmdFinishData);
            CC_SAFE_DELETE(cmdFinishData);
        }
    }
}

//*******************************
// star process response
//*******************************
void SFSResponse::proc_Rank(boost::shared_ptr<ByteArray> btrd)
{
    vector<CMDRankData*>* rankM = new vector<CMDRankData*>();
    vector<CMDRankData*>* rankE = new vector<CMDRankData*>();
    
    long length;
    btrd->ReadInt(length);
    /*btrd->ReadBytes(length, vByteMoney);
     for (int i = 0; i < vByteMoney.size(); i++)
     {
     CCLOG("vByteMoney[%d]: %c",i,vByteMoney.at(i));
     }*/
    CCLOG("length %ld",length);
    
    while (btrd->Position() < length) //get rank money
    {
        CMDRankData* d1 = new CMDRankData();
        btrd->ReadUTF(d1->m_uName);
        btrd->ReadDouble(d1->m_dId);
        btrd->ReadInt(d1->m_uLevel);
        btrd->ReadDouble(d1->m_uMoney);
        CCLOG("bytesMoney:%ld-%s-%f", btrd->Position(), d1->m_uName.c_str(), d1->m_uMoney);
        rankM->push_back(d1);
    }
    CCLOG("length(2) %ld", btrd->Position());
    
    btrd->ReadInt(length);
    int startPos = btrd->Position();
    CCLOG("length(3) %ld - %ld - %ld", btrd->Position(), length, btrd->Position() + length - 10);
    
    while (btrd->Position() < startPos + length) //get rank exp
    {
        
        CMDRankData* d2 = new CMDRankData();
        btrd->ReadUTF(d2->m_uName);
        CCLOG("bytesMoney:%ld - %s", btrd->Position(), d2->m_uName.c_str());
        btrd->ReadDouble(d2->m_dId);
        btrd->ReadInt(d2->m_uLevel);
        btrd->ReadDouble(d2->m_uMoney);
        rankE->push_back(d2);
    }
    
    CMD2Rank* cmd2Rank = new CMD2Rank();
    cmd2Rank->m_pVecE = rankE;
    cmd2Rank->m_pVecM = rankM;
    
    NotificationCenter::getInstance()->postNotification("SHOW_RANK_POPUP", (Ref*)cmd2Rank);
}

void SFSResponse::proc_ClientLobby(boost::shared_ptr<ByteArray> btrd)
{
    //parse tables infor
    long l_iLength;
    btrd->ReadInt(l_iLength);
    //
    TableData* defaultTableData = new TableData();
    short l_iNumDefaultTables;
    btrd->ReadShort(l_iNumDefaultTables);
    btrd->ReadUTF(defaultTableData->m_sName);//table default name
    btrd->ReadInt(defaultTableData->m_iCuoc);//cuoc
    btrd->ReadBool(defaultTableData->m_bGa); //ga
    btrd->ReadShort(defaultTableData->m_iTotalTime);
    btrd->ReadUTF(defaultTableData->m_sTitle);
    defaultTableData->m_sTitle = "Enjoy the game";
    GlobalVariable::m_vTableData->clear();
    for (int i = 0; i < l_iNumDefaultTables; i++)
    {
        TableData* tableData = new TableData(defaultTableData);
        GlobalVariable::m_vTableData->push_back(tableData);
    }
    if (btrd->Position() == btrd->Length())
    {
        CCLOG("Have no Player");
    }
    else //is remain byte data
    {
        long l_iNumTableHasPlayer, l_iLenghtOfTableHasPlayerData;
        btrd->ReadInt(l_iNumTableHasPlayer);
        btrd->ReadInt(l_iLenghtOfTableHasPlayerData);
        int index = 0;
        while (index < l_iNumTableHasPlayer)
        {
            std::string sMethod;
            long  lengthOfTableData, indexTableInDefault, iCuoc, iTotalTime;
            bool  bGa, bPlaying;
            btrd->ReadInt(lengthOfTableData);
            btrd->ReadInt(indexTableInDefault);
            btrd->ReadInt(iCuoc);
            btrd->ReadBool(bGa);
            btrd->ReadInt(iTotalTime);
            btrd->ReadUTF(sMethod);
            sMethod = "Enjoy the game";
            btrd->ReadBool(bPlaying);
            //get number of players in table
            indexTableInDefault = indexTableInDefault - 1;
            long l_sNOPlayers;
            btrd->ReadInt(l_sNOPlayers);
            
            if(indexTableInDefault >= l_iNumDefaultTables)
            {
                TableData* tableData     = new TableData();
                std::string str          = defaultTableData->m_sName;
                tableData->m_sName       = str.substr(0, 3);
                tableData->m_sTitle      = sMethod;
                tableData->m_iCuoc       = iCuoc;
                tableData->m_bGa         = bGa;
                tableData->m_sMethod     = sMethod;
                tableData->m_bPlaying    = bPlaying;
                tableData->m_iNumPlayers = l_sNOPlayers;
                
                GlobalVariable::m_vTableData->push_back(tableData);
            }
            else
            {
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_iCuoc       = iCuoc;
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_bGa         = bGa;
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_sMethod     = sMethod;
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_sTitle      = sMethod;
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_bPlaying    = bPlaying;
                GlobalVariable::m_vTableData->at(indexTableInDefault)->m_iNumPlayers = l_sNOPlayers;
            }
            
            index++;
        }
    }
}

void SFSResponse::sortPlayers()
{
    CCLOG("Number of Players: %lu", GlobalVariable::m_vPlayers->size());
    for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
    {
        if(GlobalVariable::m_vPlayers->at(i)->m_bHost)
        {
            CCLOG("Host Name: %s", GlobalVariable::m_vPlayers->at(i)->m_sName.c_str());
        }
    }
    if(GlobalVariable::m_vPlayers->size() == 0)
    {
        return;
    }
    vector<PlayerData*>* tmpPlayerData = new vector<PlayerData*>();
    tmpPlayerData->clear();
    int iMe = -1;
    GlobalVariable::m_vPlayersSorted->clear();
    if(GlobalVariable::m_iCurrentGame==2)
    {
        for(int i = 0; i < 3; i++)
        {
            if(i < GlobalVariable::m_vPlayers->size())
            {
                if( GlobalVariable::m_vPlayers->at(i)->m_dId == GlobalVariable::m_pUser->m_dId)
                {
                    iMe = i;
                    GlobalVariable::m_pUser->m_bPlaying = false;
                    if(iMe < 4)
                    {
                        GlobalVariable::m_vPlayers->at(iMe)->m_bPlaying = true;
                        GlobalVariable::m_pUser->m_bPlaying = true;
                    }
                    if(iMe == 0)
                    {
                        GlobalVariable::m_pUser->m_bHost = true;
                    }
                }
                tmpPlayerData->push_back(GlobalVariable::m_vPlayers->at(i));
            }
        }
    }
    else
    {
        for(int i = 0; i < 4; i++)
        {
            if(i < GlobalVariable::m_vPlayers->size())
            {
                if( GlobalVariable::m_vPlayers->at(i)->m_dId == GlobalVariable::m_pUser->m_dId)
                {
                    iMe = i;
                    GlobalVariable::m_pUser->m_bPlaying = false;
                    if(iMe < 4)
                    {
                        GlobalVariable::m_vPlayers->at(iMe)->m_bPlaying = true;
                        GlobalVariable::m_pUser->m_bPlaying = true;
                    }
                    if(iMe == 0)
                    {
                        GlobalVariable::m_pUser->m_bHost = true;
                    }
                }
                tmpPlayerData->push_back(GlobalVariable::m_vPlayers->at(i));
            }
        }
        
    }
    
    if(iMe == -1)
    {
        for(int i = 0; i < tmpPlayerData->size(); i++)
        {
            GlobalVariable::m_vPlayersSorted->push_back(tmpPlayerData->at(i));
        }
    }
    else
    {
        for(int i = iMe; i < tmpPlayerData->size(); i++)
        {
            GlobalVariable::m_vPlayersSorted->push_back(tmpPlayerData->at(i));
        }
        for(int i = 0; i < iMe; i++)
        {
            GlobalVariable::m_vPlayersSorted->push_back(tmpPlayerData->at(i));
        }
    }
}
/* end process response */
