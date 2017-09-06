//
//  CapsaSusunScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "CapsaSusunScene.h"
#include "QuestBonusPopup.h"

const int CapsaSusunScene::SORT_RANK = 1;
const int CapsaSusunScene::SORT_SUIT = 2;
const int CapsaSusunScene::SORT_HAND = 3;

CapsaSusunScene::CapsaSusunScene()
{
	m_bJoinGame = false;
	m_bCansort = false;
	m_bCanTouchBtnSort = true;
    m_vChatToastPosition = vector<Vec2>();
	m_bHasEndGameResult = false;
	m_vMoneyResult = {};
	m_iSortState = 2;
	m_deck = nullptr;
	m_selectingCard = nullptr;
	m_targetCard = nullptr;
	m_bMovingCard = false;
    m_vUserInfoOthers = new vector<SSUserInfo*>();
	m_tfMauBinh = nullptr;
    m_iLastCount = 0;
    m_iCurrentCount = 0;
}

CapsaSusunScene::~CapsaSusunScene()
{
    m_vUserInfoOthers->clear();
    CC_SAFE_DELETE(m_vUserInfoOthers);
}

void CapsaSusunScene::onEnter()
{
	BaseScene::onEnter();
	// Game loop event
	schedule(schedule_selector(CapsaSusunScene::update));
	// Init UI
    AudioManager::getInstance()->stopSoundBackground();
	BaseScene::initUI(kSceneJsonCapsaSusunGame);

	for(int i = 0; i < 4; i++)
    {
        m_pnlPlayerAreas[i] = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, ccsf("pnlPlayerArea%d", i)));
        Button* btnInvite = static_cast<Button*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
        if(pnlInvite)
        {
            if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
            auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
            animCountDown->setName("sangvanmoi");
            animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
            animCountDown->addAnimation(0, "sangvanmoi", true);
            animCountDown->setPosition(pnlInvite->getContentSize().width / 2, pnlInvite->getContentSize().height / 2);
            pnlInvite->addChild(animCountDown);
        }

        if(btnInvite)
        {
            btnInvite->setScale(0.8f);
            btnInvite->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onBtnInviteClick, this));
        }
    }
    m_gamebarContainer = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "gamebarContainer"));
    m_btnStart         = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnStart"));
    m_btnFinish        = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnFinish"));
    m_btnChange        = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnChange"));
    m_btnSort          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSort"));
    m_btnSwap          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSwap"));
    m_btnHand          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnHand"));
    //m_btnBonus         = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnBonus"));
    //m_btnBonus->setVisible(false);
    m_btnHandActivate  = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnHandActivate"));
    m_btnDeck          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnDeck"));
    m_btnDeckActivate  = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnDeckActivate"));
    pnlInvite   = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlInvite"));
    Text* lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
    CCLOG("Game restart: %d", GlobalVariable::m_bGameRestarted);
    if(!GlobalVariable::m_bGameRestarted)
    {

        if(!(GlobalVariable::m_startGameData->m_iNOPlayers == 1))
        {
            if(!GlobalVariable::m_pUser->m_bHost)
            {
                lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_WAITING_HOST_START));
            }
        }
        else
        {
            lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITE_MORE));
        }
    }
    lblInvite->runAction(RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 255), FadeTo::create(0.5f, 0), NULL)));
    m_pnlCountDown = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlCountDown"));
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfCountDown"));
    m_bmfCountDown->setVisible(false);

    m_pnlTimer  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlTimer"));
    m_pnlUserInfo  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlUserInfo"));
    m_pnlSetting  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlSetting"));

    if (GlobalVariable::m_pUserInfo->getParent()) GlobalVariable::m_pUserInfo->removeFromParent();
	m_pnlUserInfo->addChild(GlobalVariable::m_pUserInfo);
	GlobalVariable::m_pUserInfo->setPosition(Vec2(0, 0));
    GlobalVariable::m_pUserInfo->fillDataUserInfo();

	if (GlobalVariable::m_pSettingCom->getParent()) GlobalVariable::m_pSettingCom->removeFromParent();
    m_pnlSetting->addChild(GlobalVariable::m_pSettingCom);
    GlobalVariable::m_pSettingCom->setVisiblePanelIAP(false);
    GlobalVariable::m_pSettingCom->setVisibleItems(false, false, true, true, true);

    m_prgTImer  = static_cast<LoadingBar*>(Helper::seekWidgetByName(m_pLayout, "prgTime"));
    m_imgLight  = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLight"));
    m_imgTimeBg = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgTimeBg"));
    m_bmfTimer  = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "txtClock"));
    m_bmRoomNo  = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "txtRoomNO"));
    m_bmfTime   = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime"));
    m_bmfBet    = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfBet"));
    TextBMFont* bmZoneName = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfZoneName"));
    bmZoneName->setString(ResourceManager::getInstance()->getTextByName(GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone)->m_sName.c_str()).c_str());

    m_bmfSortDone          = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_FINISH), "bf2-export.fnt");

    if(GlobalVariable::m_bGameRestarted)
    {
        GlobalVariable::m_bGameRestarted = false;
        showMessage(true, kTEXT_MSG_AUTO_DEAL_CARD);
        auto deviceSize = Director::getInstance()->getWinSize();
        m_pnlCountDown->setVisible(true);
        m_bmfCountDown->setVisible(true);
        if(m_pnlCountDown->getChildByName("sangvanmoi"))m_pnlCountDown->removeChildByName("sangvanmoi");
        auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
        animCountDown->setName("sangvanmoi");
        animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
        animCountDown->addAnimation(0, "sangvanmoi", true);
        m_pnlCountDown->addChild(animCountDown);
        m_fCountTimeLeft = 10.000f;
        schedule(schedule_selector(CapsaSusunScene::onCountDownTimer), 1.0f, kRepeatForever, 0.0f);
    }
    else
    {
        m_pnlCountDown->setVisible(false);
        m_bmfCountDown->setVisible(false);
    }

    m_bmRoomNo->setString(ccsf("%d", GlobalVariable::m_iCurrentTable));
    m_bmfBet   = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfBet"));
    m_bmfTime   = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime"));
    m_bmfBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetData->m_iCuoc));
    m_bmfTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetData->m_iTime)));
    m_btnStart->setVisible(false);
    m_btnStart->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnStart, this));
    m_gamebarContainer->setVisible(false);
    m_bmfSortDone->setVisible(false);

    m_pLayout->addChild(m_bmfSortDone);
    addNotification();

	relayout();
    changeLanguage(nullptr);

	m_btnFinish->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnFinish, this));
	m_btnChange->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnChange, this));
	m_btnSort->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnSort, this));
	m_btnSwap->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnSwap, this));
    //m_btnBonus->addTouchEventListener(CC_CALLBACK_2(CapsaSusunScene::onTouchBtnBonus, this));
    setTurnId(GlobalVariable::m_startGameData->m_dStartSFSID);
    placePlayers();
    m_bJoinGame = true;

    if(GlobalVariable::m_startGameData->m_bReconnect)
    {
        reconnect();
    }

	if(GlobalVariable::m_startGameData->m_bSpec)
    {
        spectator();
    }
	else
    {
		m_bJoinGame = true;
	}
    CCLOG("Playing: %i | Reconnect: %i | Spectator: %i", GlobalVariable::m_startGameData->m_bPlaying, GlobalVariable::m_startGameData->m_bReconnect, GlobalVariable::m_startGameData->m_bSpec);
    showInvite();
    showItemsRoom();

    if(!GlobalVariable::m_startGameData->m_bPlaying)
    {
        if(GlobalVariable::m_pUser->m_bHost && GlobalVariable::m_vPlayersSorted->size() == 1)
        {
            SettingRoomPopup* pu = new SettingRoomPopup(GlobalVariable::m_pDataMinMaxStake, GlobalVariable::m_cSetData->m_iCuoc, GlobalVariable::m_cSetData->m_iTime, true);
            openPopup(pu);
        }
    }
}

void CapsaSusunScene::reconnect()
{
    GlobalVariable::m_startGameData->m_bPlaying = true;
    m_btnStart->setVisible(false);
    showMessage(false);
    m_iTime = GlobalVariable::m_startGameData->m_iTimeRemain;
    m_v_vCard = {};
    m_v_vCard.push_back(vector<SSCard*>{});
    m_v_vCard.push_back(vector<SSCard*>{});
    m_v_vCard.push_back(vector<SSCard*>{});
    m_v_vCard.push_back(vector<SSCard*>{});
    int noPlayer = GlobalVariable::m_vPlayersSorted->size();

    for (int k = 0; k < noPlayer; k++)
    {
        int i = GlobalVariable::m_vPlayersSorted->at(k)->m_iPlayerArea;
        if(i != 0) continue;
        vector<Vec2> vPos = m_v_vCardPos.at(i);
        for (int j = 0; j < 13; j++)
        {
            int cardId = i == 0 ? GlobalVariable::m_vPlayersSorted->at(0)->m_aCards[j] : -1;
            SSCard* card = SSCard::create(cardId);
            if (i == 0)
            {
                setRotationCard(card, j);
            }
            card->m_fRotationOrigin = card->getRotation();
            m_pnlPlayerAreas[i]->addChild (card);
            m_v_vCard.at(i).push_back(card);

            Vec2 targetPos = vPos.at(j);
            card->setPosition(targetPos);
            card->m_posOrigin = targetPos;
            if (i == 0) card->setScale(0.5f);
            else card->setScale(0.5f);

            _eventDispatcher->removeEventListenersForTarget(card);
        }
    }
    onFinishDealingCards();

    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        for(int j = 0; j < GlobalVariable::m_startGameData->m_vSortedSfsIds.size(); j++)
        {
            if(GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId == GlobalVariable::m_startGameData->m_vSortedSfsIds.at(j))
            {
                m_vUserInfoOthers->at(i)->setSortState(true);
            }
        }
    }

    // Check maubinh
    bool bMauBinh = false;
    std::string strMauBinh;
    std::string font;

    if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 37) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON_SAME_SUIT);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 36) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 35) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_SAME_SUIT);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 34) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_FIVE_PAIR_ONE_TRIPLE);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 33) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_SIX_PAIRS);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 32) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_THREE_FLUSH);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }
    else if (GlobalVariable::m_vPlayersSorted->at(0)->m_iTypeMB == 31) {
        strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_THREE_STRAIGHT);
        font = "bf2-export.fnt";
        bMauBinh = true;
    }

    if (bMauBinh) {
        m_btnSort->setVisible(false);
        m_btnFinish->setVisible(false);
        m_btnChange->setVisible(false);
        m_btnSwap->setVisible(false);
        m_pnlPlayerAreas[0]->runAction(ScaleTo::create(0.2f, 1.0f));

        m_pUILayer->removeChildByName("tfMauBinh");
        Size deviceSize = Director::getInstance()->getWinSize();
        Vec2 pos = Vec2(deviceSize.width / 2, 120.0f);
        TextBMFont* bmFont = TextBMFont::create(strMauBinh.c_str(), font.c_str());
        bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
        bmFont->setPosition(pos);
        bmFont->setZOrder(4);
        bmFont->setName("tfMauBinh");
        this->m_pUILayer->addChild(bmFont);
        m_tfMauBinh = bmFont;
        m_pnlPlayerAreas[0]->stopAllActions();

        for (int i = 0; i < 13; i++) {
            _eventDispatcher->removeEventListenersForTarget(m_v_vCard.at(0).at(i));
        }
    }
    for (int i = 0, l = m_vUserInfoOthers->size(); i < l; i++)
    {
        SSUserInfo* userInfo = m_vUserInfoOthers->at(i);
        if (userInfo != nullptr)
        {
            userInfo->visibleSortStateBg(true);
            userInfo->setSortState(false);
        }
    }
}

void CapsaSusunScene::spectator()
{
    showMessage(true, kTEXT_MSG_WATCHING);
    m_bJoinGame = false;
    m_btnStart->setVisible(false);
    if (GlobalVariable::m_startGameData->m_bPlaying)
    {
        m_v_vCard = {};
        m_v_vCard.push_back(vector<SSCard*>{});
        m_v_vCard.push_back(vector<SSCard*>{});
        m_v_vCard.push_back(vector<SSCard*>{});
        m_v_vCard.push_back(vector<SSCard*>{});

        vector<Vec2> vCard;
        for (int i = 0; i < 13; i++)
        {
            if (i < 3) vCard.push_back(Vec2(38.0f + i * 25, 100.0f));
            else if (i < 8) vCard.push_back(Vec2(38.0f + (i - 3) * 25, 75.0f));
            else vCard.push_back(Vec2(38.0f + (i - 8) * 25, 50.0f));
        }
        stringstream ss;
        ss << m_iTime;
        m_bmfTimer->setString(ss.str());
        auto moveMuteReverse1 = MoveTo::create(m_iTime - 0.5f, Vec2(m_imgTimeBg->getPositionX() - m_imgTimeBg->getContentSize().width / 2, m_imgTimeBg->getPositionY() + 4));
        m_imgLight->runAction(Sequence::create(moveMuteReverse1, CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onEndPrgTimer, this)), nullptr));
        unschedule(schedule_selector(CapsaSusunScene::onPrgTimer));
        schedule(schedule_selector(CapsaSusunScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);
        for (int i = 0; i < m_vUserInfoOthers->size(); i++)
        {
            m_vUserInfoOthers->at(i)->visibleSortStateBg(false);
        }
    }
    for (int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->visibleBGState(false);
    }
}

void CapsaSusunScene::updateNewSetting(Ref* obj)
{
	SSCMDConfigData* cmdConfigData = (SSCMDConfigData*)obj;
    showToast(ccsf("Time: %lds Stake: %ld", cmdConfigData->m_iTime, cmdConfigData->m_iStake), 2.0f);
	GlobalVariable::m_cSetData->m_iCuoc = cmdConfigData->m_iStake;
	GlobalVariable::m_cSetData->m_iTime = cmdConfigData->m_iTime;
	m_bmfBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetData->m_iCuoc));
    m_bmfTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetData->m_iTime)));
}

void CapsaSusunScene::showSettingRoom(Ref* obj)
{
	SettingRoomPopup* pu = new SettingRoomPopup(GlobalVariable::m_pDataMinMaxStake, GlobalVariable::m_cSetData->m_iCuoc, GlobalVariable::m_cSetData->m_iTime);
	openPopup(pu);
}

void CapsaSusunScene::onExit()
{
	BaseScene::onExit();
    unschedule(schedule_selector(CapsaSusunScene::onCountDownTimer));
    unschedule(schedule_selector(CapsaSusunScene::onPrgTimer));
    removeAllChildrenWithCleanup(true);
}

void CapsaSusunScene::update(float dt)
{
	BaseScene::update(dt);
}

void CapsaSusunScene::placePlayers()
{
    for(int i = 0; i < 4; i++)
    {
        if (m_pnlPlayerAreas[i]->getChildByName("userInfoOther"))
        {
            m_pnlPlayerAreas[i]->removeChildByName("userInfoOther");
        }
    }
    m_vUserInfoOthers->clear();
    if (GlobalVariable::m_vPlayers->size() == 2)
    {
        // User
        SSUserInfo* pUserInfoOther0 = new SSUserInfo();
        pUserInfoOther0->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(0));
        m_pnlPlayerAreas[0]->addChild(pUserInfoOther0);
        pUserInfoOther0->setZOrder(14);
		pUserInfoOther0->setPosition(Vec2(m_pnlPlayerAreas[0]->getContentSize().width / 2 - pUserInfoOther0->getContentSize().width - 380, m_pnlPlayerAreas[0]->getPositionY()));
        GlobalVariable::m_vPlayersSorted->at(0)->m_iPlayerArea = 0;
        m_vUserInfoOthers->push_back(pUserInfoOther0);
		pUserInfoOther0->setVisibleKickBtn(m_bCanKick);
        // Opponent player
        SSUserInfo* pUserInfoOther1 = new SSUserInfo();
        pUserInfoOther1->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(1));
        pUserInfoOther1->setPosition(Vec2(-80, -150));
        pUserInfoOther1->setZOrder(14);
        m_pnlPlayerAreas[2]->addChild(pUserInfoOther1);
        GlobalVariable::m_vPlayersSorted->at(1)->m_iPlayerArea = 2;
        m_vUserInfoOthers->push_back(pUserInfoOther1);
        pUserInfoOther1->visibleSortStateBg(false);
		pUserInfoOther1->setVisibleKickBtn(m_bCanKick);
    }
    else
    {
        for(int i = 0; i < 4; i++)
        {
			if (i < GlobalVariable::m_vPlayers->size())
            {
                SSUserInfo* pUserInfoOther = new SSUserInfo();
                pUserInfoOther->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(i));
                pUserInfoOther->setZOrder(14);
                m_pnlPlayerAreas[i]->addChild(pUserInfoOther);
				pUserInfoOther->setVisibleKickBtn(m_bCanKick);

                // Another player has sorting state
                if (i != 0)
                {
                    pUserInfoOther->setSortState(false);
                    pUserInfoOther->visibleSortStateBg(false);
                }

				if (i == 1)
                {
                    pUserInfoOther->setPosition(Vec2(-130.0f, -70.0f));
                    pUserInfoOther->setBgAlign(true);
                }
                
				else if (i == 0 && !m_bJoinGame) pUserInfoOther->setPositionX(pUserInfoOther->getPositionX() - 80.0f);
                else if (i == 2) pUserInfoOther->setPosition(Vec2(-80.0f, -150.0f));
                else if (i == 3) pUserInfoOther->setPosition(Vec2(-5.0f, -70.0f));
                GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea = i;
                m_vUserInfoOthers->push_back(pUserInfoOther);
            }
        }
    }
    if(GlobalVariable::m_vPlayers->size() == 1
       || (GlobalVariable::m_vPlayersSorted->at(0)->m_iSfsId == GlobalVariable::m_pUser->m_iSfsId && !GlobalVariable::m_startGameData->m_bSpec)
       || GlobalVariable::m_startGameData->m_bReconnect
                                                   )
    {
        m_pnlPlayerAreas[0]->removeAllChildrenWithCleanup(true);
    }

    showInvite();
    showItemsRoom();
    
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setScale(1.2f);
    }
}

void CapsaSusunScene::addNotification()
{
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onGameStarted), SS_R_CARDLIST, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onUserDataEnd), SS_R_USER_DATA_END, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onUserDataEndView), SS_R_USER_DATA_END_VIEW, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onUpdateEndGame), SS_R_UPDATE_END_GAME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onNetworkSendPublishMsr), EVENT_NETWORK_SEND_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onNetworkGetPublishMsr), EVENT_NETWORK_GET_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onWaitingList), C_COMMAND_GET_LISTWAITING, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onFullTime), SS_R_FULLTIME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onSortFinish), SS_R_XEPXONG, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::showSettingRoom), EVENT_SHOW_SETTING_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::updateNewSetting), SS_R_CONFIG, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onGetMinMaxStake), SS_R_MIN_MAX_STAKE, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaSusunScene::onRestart), SS_R_RESTART, nullptr);

    m_listenerKeyboard->onKeyReleased = CC_CALLBACK_2(CapsaSusunScene::onKeyReleased, this);
    getEventDispatcher()->addEventListenerWithFixedPriority(m_listenerKeyboard, 1);
}

void CapsaSusunScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
	if (SceneManager::getInstance()->m_iCurrentScene == kSceneInGame2  && keyCode == EventKeyboard::KeyCode::KEY_BACK)
    {
        event->stopPropagation();
        if(m_vPopups != nullptr && m_vPopups->size() > 0)
        {
            closeAllPopups();
            return;
        }
		//showLoading();
		//SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
        GlobalVariable::m_pSettingCom->onBtnLogout(nullptr, Widget::TouchEventType::ENDED);
	}
}

void CapsaSusunScene::onRestart(Ref* obj)
{
    GlobalVariable::m_bGameRestarted = true;
    if(GlobalVariable::m_bRequestLogout)
    {
        GlobalVariable::m_bRequestLogout = false;
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
}

void CapsaSusunScene::onGetMinMaxStake(Ref* obj)
{
    GlobalVariable::m_pDataMinMaxStake = (CMDMinMaxStake*)obj;
}

void CapsaSusunScene::onSortFinish(Ref* obj)
{
    CCLOG("onSortFinish ");
    SSCMDSortedFinishData* sortedFinishData = (SSCMDSortedFinishData*)obj;
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        if(GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId == sortedFinishData->m_dUId)
        {
            m_vUserInfoOthers->at(i)->setSortState(sortedFinishData->m_bSortFinish);
        }
    }
}

void CapsaSusunScene::onFullTime(Ref* obj)
{
    CCLOG("onFullTime ");
    vector<int>* m_vCardsId = new vector<int>();
    for(int i = 0; i < 13; i++)
    {
        m_vCardsId->push_back(m_v_vCard.at(0).at(i)->m_iId);
        _eventDispatcher->removeEventListenersForTarget(m_v_vCard.at(0).at(i));
    }
    CCLOG("onFullTime 1");
	if (m_bJoinGame) {
		m_pnlPlayerAreas[0]->runAction(ScaleTo::create(0.2f, 1.0f));
	}
    if(m_bFinishSended == false)
    {
        SFSConnection::getInstance()->xepxong(m_vCardsId, true);
        m_bFinishSended = true;
    }
    CCLOG("onFullTime 2");
    m_btnFinish->setVisible(false);
    m_btnChange->setVisible(true);
    m_bmfSortDone->setVisible(true);
}

void CapsaSusunScene::setTurnId(long turnId)
{
    CCLOG("TurnId %ld", turnId);
    CCLOG("my TurnId %ld", GlobalVariable::m_pUser->m_iSfsId);

	long iIndex = 0;
	for (int i = 0, l = GlobalVariable::m_vPlayers->size(); i < l; i++)
    {
		PlayerData* playerData = GlobalVariable::m_vPlayers->at(i);
		// Get user 
		if (playerData->m_dId == GlobalVariable::m_pUser->m_dId)
        {
			iIndex = playerData->m_iIndex;
		}
	}

	if (turnId == GlobalVariable::m_pUser->m_iSfsId && GlobalVariable::m_startGameData->m_iNOPlayers >= 2 && !GlobalVariable::m_startGameData->m_bSpec) {
		m_btnStart->setVisible(true);
	}
	else {
		m_btnStart->setVisible(false);
	}

	if (iIndex == 0 && !GlobalVariable::m_startGameData->m_bSpec) {
		m_bCanKick = true;
	}
	else {
		m_bCanKick = false;
	}
}

void CapsaSusunScene::showInvite()
{
    for (int i = 1; i < 4; i++)
    {
        Button* invite = static_cast<Button*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        if(invite)invite->setVisible(false);

        Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
        if(pnlInvite)
        {
            if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
        }
    }
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_startGameData->m_bPlaying)
    {
        for (int i = 1; i < 4; i++)
        {
            Button* invite = static_cast<Button*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
            if(invite)invite->setVisible(true);
            Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(m_pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
            if(pnlInvite)
            {
                if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
                auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
                animCountDown->setName("sangvanmoi");
                animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
                animCountDown->addAnimation(0, "sangvanmoi", true);
                animCountDown->setPosition(pnlInvite->getContentSize().width / 2, pnlInvite->getContentSize().height / 2);
                pnlInvite->addChild(animCountDown);
            }
        }
        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
        {
            int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
            if(index != 0)
            {
                Button* invite = static_cast<Button*>(Helper::seekWidgetByName(m_pnlPlayerAreas[index], ccsf("btnInvite%d", index)));
                if(invite)invite->setVisible(false);
                Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(m_pnlPlayerAreas[index], ccsf("pnlInvite%d", index)));
                if(pnlInvite)
                {
                    if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
                }
            }
        }
    }
}


void CapsaSusunScene::onUserData(Ref* obj)
{
    SSCMDGameData* gameData = (SSCMDGameData*)obj;
    setTurnId(gameData->m_dStartSFSID);
}

void CapsaSusunScene::onBtnInviteClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->getWaitingList();
}

void CapsaSusunScene::onWaitingList(Ref* obj)
{
    vector<CMDWaitingData*>* vWaitingData = (vector<CMDWaitingData*>*)obj;
    InvitationPopup* cfm = new InvitationPopup(vWaitingData);
    openPopup(cfm);
}

void CapsaSusunScene::onGameStarted(Ref* obj)
{
    AudioManager::getInstance()->playBackgroundMusic(kSoundMusicStart);
    SSCMDStartData* startData = (SSCMDStartData*)obj;
    GlobalVariable::m_startGameData->m_bPlaying = true;
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown->setString("10");
    m_bmfCountDown->setVisible(false);
    showMessage(false);
    unschedule(schedule_selector(CapsaSusunScene::onCountDownTimer));
    m_btnStart->setVisible(false);
    showInvite();
    showItemsRoom();
    m_bFinishSended = false;
    m_iTime = startData->m_iTime;
	dealCards(startData->m_aCards);
}

void CapsaSusunScene::onUserDataEnd(Ref* obj)
{
    CCLOG("onUserDataEnd 1");
    showMessage(false);
	m_bCansort = false;
	SSCMDEndGameData* endGameData = (SSCMDEndGameData*)obj;
	vector<SSCMDUserEndData*>* vUserEndData = endGameData->m_vUsersEndData;
	vector<SSCMDCompareEndData*>* vCompareData = endGameData->m_vCompareEndData;
	vector<SSCMDSapEndData*>* vSapData = endGameData->m_vSapEndData;

    m_pUILayer->removeChildByName("tfMauBinh");
    for (int i = 0, l = m_vUserInfoOthers->size(); i < l; i++) {
        SSUserInfo* userInfo = m_vUserInfoOthers->at(i);
        if (userInfo != nullptr) userInfo->visibleSortStateBg(false);
    }
    CCLOG("onUserDataEnd 2");
    // Remove timer
    m_bmfSortDone->setVisible(false);
    unschedule(schedule_selector(CapsaSusunScene::onPrgTimer));
    m_gamebarContainer->runAction(Sequence::create(
        FadeTo::create(0.2f, 0.0f), 
        CallFunc::create(CC_CALLBACK_0(Node::setVisible, m_gamebarContainer, false)), 
        nullptr));
    // Remove all current cards
    for (int i = 0, l = m_v_vCard.size(); i < l; i++)
    {
        for (int j = 0, lj = m_v_vCard.at(i).size(); j < lj; j++)
        {
            SSCard* card = m_v_vCard.at(i).at(j);
            card->runAction(Sequence::create(FadeTo::create(0.2f, 0), CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onDeleteNode, this, card)), nullptr));
        }
        m_v_vCard.at(i).clear();
    }
    CCLOG("onUserDataEnd 3");
    // Get total mau binh deck (quick show if less than 2 decks need to compare)
    int countNormalDeck = 0;
    for (int i = 0, l = vUserEndData->size(); i < l; i++)
    {
    	SSCMDUserEndData* userEndData = vUserEndData->at(i);
    	int cardListType = userEndData->m_iCardListType;
    	if (cardListType == 2) countNormalDeck++;
    }
    CCLOG("onUserDataEnd 4");
    // Compare chi
    bool bQuickShow = countNormalDeck < 2 ? true : false;
    float fShowingTime = bQuickShow ? 12.0f : 14.0f;
    for (int i = 0, l = vUserEndData->size(); i < l; i++)
    {
		if (m_v_vCard.size() <= i) m_v_vCard.push_back({});
    	SSCMDUserEndData* userEndData = vUserEndData->at(i);
		//int iPlayerArea = GlobalVariable::m_vPlayersSorted->at(userEndData->m_iIndex)->m_iPlayerArea;
		int iPlayerArea = -1;
		for (int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++) {
			if (GlobalVariable::m_vPlayersSorted->at(j)->m_iSfsId == userEndData->m_dSFSId)
            {
				iPlayerArea = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
                GlobalVariable::m_vPlayersSorted->at(j)->m_iIndex = userEndData->m_iIndex;
				break;
			}
		}
		CCLOG("onUserDataEnd 5");
        // Add new cards for target player
        for (int j = 0; j < 13; j++)
        {
            SSCard* card = SSCard::create(iPlayerArea == 0 ? userEndData->m_aCards[j] : -1);
            card->setCardSize(SSCard::SIZE_SMALL);
            m_pUILayer->addChild(card);
            Vec2 pos = m_v_vCardAnimPos.at(iPlayerArea).at(j);
            card->setZOrder(1);
            card->setPosition(pos);
            card->setScale(0.5f);
            _eventDispatcher->removeEventListenersForTarget(card);
            card->setOpacity(0);
            if (j < 3) card->setRotation(-3.0f + 3.0f * j);
            else if (j < 5) card->setRotation(-9.0f + 6.0f * (j - 3));
            else if (j == 5) card->setRotation(0.0f);
            else if (j < 8) card->setRotation(6.0f + 3.0f * (j - 6));
            else if (j < 10) card->setRotation(-9.0f + 6.0f * (j - 8));
            else if (j == 10) card->setRotation(0.0f);
            else card->setRotation(6.0f + 3.0f * (j - 11));
            card->runAction(Sequence::create(DelayTime::create(0.2f), FadeTo::create(0.2f, 255),nullptr));
            m_v_vCard.at(iPlayerArea).push_back(card);
        }
        CCLOG("onUserDataEnd 6");
		// Binh lung
		if (userEndData->m_iCardListType == 0) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_BINH_LUNG).c_str(), "bf2-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
		// Mau binh
		else if (userEndData->m_iCardListType == 1) {
			// 3 sanh
			if (userEndData->m_iMauBinh == 31) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_THREE_STRAIGHT).c_str(), "bf0-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// 3 thung
			else if (userEndData->m_iMauBinh == 32) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_THREE_FLUSH).c_str(), "bf2-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// 6 doi
			else if (userEndData->m_iMauBinh == 33) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_SIX_PAIRS).c_str(), "bf4-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// 5 doi 1 xam
			else if (userEndData->m_iMauBinh == 34) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_FIVE_PAIR_ONE_TRIPLE).c_str(), "bf9-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// dong hoa
			else if (userEndData->m_iMauBinh == 35) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_SAME_SUIT).c_str(), "bf0-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// sanh rong
			else if (userEndData->m_iMauBinh == 36) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON).c_str(), "bf2-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			// sanh rong dong hoa
			else if (userEndData->m_iMauBinh == 37) showSpecialHandResult(ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON_SAME_SUIT).c_str(), "bf4-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
		}
		// Normal deck
		else {
			CCLOG("onUserDataEnd 7");
			if (bQuickShow) {
				showSpecialHandResult("", "bf0-export.fnt", userEndData->m_aCards, iPlayerArea, fShowingTime);
			}
			else {
				showHandWithDelay(1.0f, userEndData->m_aCards, iPlayerArea, 1);
				showHandWithDelay(6.0f, userEndData->m_aCards, iPlayerArea, 2);
				showHandWithDelay(11.0f, userEndData->m_aCards, iPlayerArea, 3);
				for (int j = 0, lj = vCompareData->size(); j < lj; j++) {
					SSCMDCompareEndData* data = vCompareData->at(j);
					if (data->idx1 == GlobalVariable::m_pUser->m_iSfsId
						&& data->idx2 == userEndData->m_dSFSId)
					{
						showChiResultWithDelay(1.0f, data->m_vSoChi.at(0), iPlayerArea, 1);
						showChiResultWithDelay(6.0f, data->m_vSoChi.at(1), iPlayerArea, 2);
						showChiResultWithDelay(11.0f, data->m_vSoChi.at(2), iPlayerArea, 3);
					}
				}
			}
		}
    }

    CCLOG("onUserDataEnd 8");
    CallFunc* showAct = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onShowEndGameResult, this));
	runAction(Sequence::create(DelayTime::create(fShowingTime), showAct, nullptr));

	// Show win/lose all hands
	Size deviceSize = Director::getInstance()->getWinSize();
	for (int i = 0, l = vSapData->size(); i < l; i++) {
		// Get player area based on sfsId
		int iPlayerArea = 0;
		for (int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++) {
			if (GlobalVariable::m_vPlayersSorted->at(j)->m_iSfsId == vSapData->at(i)->sfsID) {
				iPlayerArea = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
				break;
			}
		}
		TextBMFont* bmFont = nullptr;
		if (vSapData->at(i)->thangcalang) {
			std::string str = ResourceManager::getInstance()->getTextByName(kTEXT_WIN_ALL);
			bmFont = TextBMFont::create(str, "bf2-export.fnt");
		}
		if (vSapData->at(i)->thuacalang) {
			std::string str = ResourceManager::getInstance()->getTextByName(kTEXT_LOSE_ALL);
			bmFont = TextBMFont::create(str, "bf0-export.fnt");
		}

		if (bmFont != nullptr) {
			bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
			Vec2 offPos;
			if (iPlayerArea == 0) offPos = Vec2(deviceSize.width / 2, deviceSize.height / 2 - 100.0f);
			else if (iPlayerArea == 1) offPos = Vec2(deviceSize.width / 2 + 300.0f, deviceSize.height / 2);
			else if (iPlayerArea == 2) offPos = Vec2(deviceSize.width / 2, deviceSize.height / 2 + 100.0f);
			else if (iPlayerArea == 3) offPos = Vec2(deviceSize.width / 2 - 300.0f, deviceSize.height / 2);
			bmFont->setPosition(offPos);
			bmFont->setOpacity(0);
			bmFont->setZOrder(99);

			m_pUILayer->addChild(bmFont);
			bmFont->runAction(Sequence::create(
				DelayTime::create(fShowingTime + 1.0f),
				FadeTo::create(0.5f, 255),
				DelayTime::create(4.0f),
				FadeTo::create(0.5f, 0),
				CallFunc::create(CC_CALLBACK_0(Node::removeFromParent, bmFont)),
				nullptr));
		}
	}
}

void CapsaSusunScene::onUserDataEndView(Ref* obj)
{
    vector<SSCMDUserEndViewData*>* vUserEndViewData = (vector<SSCMDUserEndViewData*>*)obj;

    m_bHasEndGameResult = true;
    m_vMoneyResult = {-1, -1, -1, -1};
    for (int i = 0, l = vUserEndViewData->size(); i < l; i++)
    {
    	SSCMDUserEndViewData* userEndViewData = vUserEndViewData->at(i);
    	double money = userEndViewData->m_dMoneyChanged;

        for (int j = 0, lj = GlobalVariable::m_vPlayersSorted->size(); j < lj; j++)
        {
            if (GlobalVariable::m_vPlayersSorted->at(j)->m_dId == userEndViewData->m_dUid)
            {
                m_vMoneyResult.at(GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea) = money;
                break;
            }
        }

		for (int k = 0, lk = m_vUserInfoOthers->size(); k < lk; k++) {
			if (m_vUserInfoOthers->at(k)->m_dUserId == userEndViewData->m_dUid) {
				m_vUserInfoOthers->at(k)->updateMoney(userEndViewData->m_dMoneyReal);
			}
		}
    }
    //GlobalVariable::m_startGameData->m_bSpec = false;
    GlobalVariable::m_startGameData->m_bPlaying = false;
    GlobalVariable::m_vSSCMDUserEndViewData = vUserEndViewData;

}

void CapsaSusunScene::onUpdateEndGame(Ref* obj)
{
    
}

void CapsaSusunScene::relayout()
{
	Size deviceSize = Director::getInstance()->getWinSize();
    GlobalVariable::m_pSettingCom->setPosition(Vec2(-190 + deviceSize.width - GlobalVariable::m_iGameWidth, 40));
    pnlInvite->setPositionX(deviceSize.width / 2 - pnlInvite->getContentSize().width / 2);

	// Background first
	ImageView* imgInGameBG = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgTableBg"));
	imgInGameBG->setScaleX(float(deviceSize.width / 960));
	imgInGameBG->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    ImageView* imgLogoGame = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLogoGame"));
    imgLogoGame->setPositionX(deviceSize.width / 2);

    m_vChatToastPosition.push_back(Vec2(300.0f, deviceSize.height-140.0f));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width - 180.0f, deviceSize.height / 2));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width / 2, deviceSize.height - 140.0f));
    m_vChatToastPosition.push_back(Vec2(250.0f, deviceSize.height / 2));

	// Relayout all player areas
	m_pnlPlayerAreas[0]->setAnchorPoint(Vec2(0.0f, 0.0f));
	m_pnlPlayerAreas[1]->setAnchorPoint(Vec2(0.0f, 0.0f));
	m_pnlPlayerAreas[2]->setAnchorPoint(Vec2(0.0f, 0.0f));
	m_pnlPlayerAreas[3]->setAnchorPoint(Vec2(0.0f, 0.0f));
	m_pnlPlayerAreas[0]->setPosition(Vec2(deviceSize.width/2, 0.0f));
	m_pnlPlayerAreas[1]->setPosition(Vec2(deviceSize.width, deviceSize.height/2));
	m_pnlPlayerAreas[2]->setPosition(Vec2(deviceSize.width / 2, deviceSize.height - 20));
	m_pnlPlayerAreas[3]->setPosition(Vec2(0.0f, deviceSize.height/2));

	// Remember cards position for all player areas
	m_v_vCardPos.push_back(vector<Vec2>{});
	m_v_vCardPos.push_back(vector<Vec2>{});
	m_v_vCardPos.push_back(vector<Vec2>{});
	m_v_vCardPos.push_back(vector<Vec2>{});
	m_v_vCardAnimPos.push_back(vector<Vec2>{});
	m_v_vCardAnimPos.push_back(vector<Vec2>{});
	m_v_vCardAnimPos.push_back(vector<Vec2>{});
	m_v_vCardAnimPos.push_back(vector<Vec2>{});
	m_vBottomCardPos = {};
	float pi = 3.14;
    // Card pos follow panel player area
    // Card anim pos follow world
	for (int i = 0; i < 13; i++)
	{
		if (i < 3)
		{
			m_vBottomCardPos.push_back(Vec2(38.0f + i * 25, 110.0f));
			m_v_vCardPos.at(0).push_back(Vec2(-54.0f + i * 54, 200.0f + 4 * sin(pi * (i / 2.0f))));
			m_v_vCardPos.at(1).push_back(Vec2(-223.0f + i * 25, 40.0f));
			m_v_vCardPos.at(2).push_back(Vec2(38.0f + i * 25, -40.0f));
			m_v_vCardPos.at(3).push_back(Vec2(118.0f + i * 25, 40.0f));

			m_v_vCardAnimPos.at(0).push_back(Vec2(deviceSize.width/2 - 50.0f + i * 50.0f, deviceSize.height/2 - 100.0f + 6 * sin(pi * (i / 2.0f))));
			m_v_vCardAnimPos.at(1).push_back(Vec2((3.0f/4.0f) * deviceSize.width - 40.0f + i * 50.0f, deviceSize.height/2 + 60.0f + 6 * sin(pi * (i / 2.0f))));
			m_v_vCardAnimPos.at(2).push_back(Vec2(deviceSize.width/2 - 50.0f + i * 50.0f, deviceSize.height/2 + 220.0f + 6 * sin(pi * (i / 2.0f))));
			m_v_vCardAnimPos.at(3).push_back(Vec2((1.0f/4.0f) * deviceSize.width - 50.0f + i * 50.0f, deviceSize.height/2 + 60.0f + 6 * sin(pi * (i / 2.0f))));
		}
		else if (i < 8)
		{
			m_vBottomCardPos.push_back(Vec2(38.0f + (i - 3) * 25, 85.0f));
			m_v_vCardPos.at(0).push_back(Vec2(-108.0f + (i - 3) * 54, 140.0f + 8 * sin(pi * ((i-3) / 4.0f))));
			m_v_vCardPos.at(1).push_back(Vec2(-223.0f + (i - 3) * 25, 15.0f));
			m_v_vCardPos.at(2).push_back(Vec2(38.0f + (i - 3) * 25, -65.0f));
			m_v_vCardPos.at(3).push_back(Vec2(118.0f + (i - 3) * 25, 15.0f));

			m_v_vCardAnimPos.at(0).push_back(Vec2(deviceSize.width/2 - 100.0f + (i-3) * 50.0f, deviceSize.height/2 - 160.0f + 12 * sin(pi * ((i-3) / 4.0f))));
			m_v_vCardAnimPos.at(1).push_back(Vec2((3.0f/4.0f) * deviceSize.width - 90.0f + (i-3) * 50.0f, deviceSize.height/2 + 12 * sin(pi * ((i-3) / 4.0f))));
			m_v_vCardAnimPos.at(2).push_back(Vec2(deviceSize.width/2 - 100.0f + (i-3) * 50.0f, deviceSize.height/2 + 160.0f + 12 * sin(pi * ((i-3) / 4.0f))));
			m_v_vCardAnimPos.at(3).push_back(Vec2((1.0f/4.0f) * deviceSize.width - 100.0f + (i-3) * 50.0f, deviceSize.height/2 + 12 * sin(pi * ((i-3) / 4.0f))));
		}
		else
		{
			m_vBottomCardPos.push_back(Vec2(38.0f + (i - 8) * 25, 60.0f));
			m_v_vCardPos.at(0).push_back(Vec2(-108.0f + (i - 8) * 54, 80.0f + 8 * sin(pi * ((i-8) / 4.0f))));
			m_v_vCardPos.at(1).push_back(Vec2(-223.0f + (i - 8) * 25, -10.0f));
			m_v_vCardPos.at(2).push_back(Vec2(38.0f + (i - 8) * 25, -90.0f));
			m_v_vCardPos.at(3).push_back(Vec2(118.0f + (i - 8) * 25, -10.0f));

			m_v_vCardAnimPos.at(0).push_back(Vec2(deviceSize.width/2 - 100.0f + (i-8) * 50.0f, deviceSize.height/2 - 220.0f + 12 * sin(pi * ((i-8) / 4.0f))));
			m_v_vCardAnimPos.at(1).push_back(Vec2((3.0f/4.0f) * deviceSize.width - 90.0f + (i-8) * 50.0f, deviceSize.height/2 - 60.0f + 12 * sin(pi * ((i-8) / 4.0f))));
			m_v_vCardAnimPos.at(2).push_back(Vec2(deviceSize.width/2 - 100.0f + (i-8) * 50.0f, deviceSize.height/2 + 100.0f + 12 * sin(pi * ((i-8) / 4.0f))));
			m_v_vCardAnimPos.at(3).push_back(Vec2((1.0f/4.0f) * deviceSize.width - 100.0f + (i-8) * 50.0f, deviceSize.height/2 - 60.0f + 12 * sin(pi * ((i-8) / 4.0f))));
		}
	}
	m_btnStart->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2 - 100));
    m_bmfSortDone->setPosition(Vec2(deviceSize.width/2, 200.0f));
    m_pnlCountDown->setPosition(Vec2(deviceSize.width/2 + m_pnlCountDown->getContentSize().width / 2, deviceSize.height/2 + m_pnlCountDown->getContentSize().height / 2));
    m_bmfCountDown->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2 + 5));
    if(deviceSize.width / (float) deviceSize.height < 1.5f)
    {
        m_btnSort->setPositionX(m_btnFinish->getPositionX() + 120);
        m_btnSwap->setPositionX(m_btnSort->getPositionX() + 125);
    }
}

void CapsaSusunScene::swapCard(SSCard* cardA, SSCard* cardB)
{
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
	int indexCardA = -1;
	int indexCardB = -1;
	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
		if (card == cardA) indexCardA = i;
		else if (card == cardB) indexCardB = i;
	}

	if (-1 != indexCardA && -1 != indexCardB) 
	{
		std::swap(m_v_vCard.at(0)[indexCardA], m_v_vCard.at(0)[indexCardB]);
		Vec2 tmpPos = cardA->m_posOrigin;
		MoveTo* moveCardA = MoveTo::create(0.1f, cardB->m_posOrigin);
		MoveTo* moveCardB = MoveTo::create(0.1f, cardA->m_posOrigin);
		cardA->m_posOrigin = cardB->m_posOrigin;
		cardB->m_posOrigin = tmpPos;
		float fRotation = cardA->m_fRotationOrigin;
		cardA->m_fRotationOrigin = cardB->m_fRotationOrigin;
		cardB->m_fRotationOrigin = fRotation;
		cardA->runAction(moveCardA);
		cardB->runAction(moveCardB);
		cardA->runAction(RotateTo::create(0.1f, cardA->m_fRotationOrigin));
		cardB->runAction(RotateTo::create(0.1f, cardB->m_fRotationOrigin));
		
		for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
		{
			SSCard* card = m_v_vCard.at(0).at(i);
			m_pnlPlayerAreas[0]->reorderChild(card, i);
		}

		verifyHand();
	}

	addCardsTouchHandler();
}

void CapsaSusunScene::setUsingCards(vector<int> vCardId)
{
    return;
	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
		int id = card->m_iId;
		vector<int>::iterator it = std::find(vCardId.begin(), vCardId.end(), id);
		if (it != vCardId.end())
		{
			card->setColor(Color3B(255, 255, 255));
		}
		else 
		{
			card->setColor(Color3B(100, 100, 100));
		}
	}
}

bool CapsaSusunScene::onCardTouchBegan(Touch* touch, Event* event)
{
	SSCard* card = static_cast<SSCard*>(event->getCurrentTarget());

	if (card->containsTouchLocation(touch))
	{
		// Select card
		if (m_selectingCard == nullptr)
		{
			m_selectingCard = card;
            m_selectingCard->setName("SelectedCard");
			m_bTouchBeganCard = true;

			m_startPos = touch->getLocation();
		}
		// Deselect card
		else if (m_selectingCard == card)
		{
			m_selectingCard->setPosition(m_selectingCard->m_posOrigin);
			m_selectingCard = nullptr;
		}
		// Swap card
		else 
		{
			swapCard(m_selectingCard, card);
			m_selectingCard = nullptr;
		}

		return true;
	}

	return false;
}

void CapsaSusunScene::onCardTouchMoved(Touch* touch, Event* event)
{
	if (m_selectingCard == nullptr || !m_bTouchBeganCard) return;

	// Move card
	Vec2 targetPos = touch->getLocation();
	m_diffPos = Vec2((targetPos.x - m_startPos.x) / m_pnlPlayerAreas[0]->getScale(), (targetPos.y - m_startPos.y) / m_pnlPlayerAreas[0]->getScale());

	int iDiff = sqrt(m_diffPos.x*m_diffPos.x + m_diffPos.y*m_diffPos.y);
	if (iDiff < 2) return;

	m_bMovingCard = true;
	m_selectingCard->setZOrder(m_pnlPlayerAreas[0]->getChildrenCount());
	m_selectingCard->setPosition(Vec2(m_selectingCard->m_posOrigin.x + m_diffPos.x, m_selectingCard->m_posOrigin.y + m_diffPos.y));

	// Which card be targeted
	m_targetCard = nullptr;
	bool bFound = false;
	for (int i = m_v_vCard.at(0).size()-1; i >= 0; i--)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
		if (card == m_selectingCard) continue;
		if (bFound || !card->containsTouchLocation(touch))
		{
			card->setPosition(card->m_posOrigin);
		}
		else
		{
			card->setPosition(Vec2(card->m_posOrigin.x, card->m_posOrigin.y + 10.0f));
			m_targetCard = card;
			bFound = true;
		}
	}
}

void CapsaSusunScene::onCardTouchEnded(Touch* touch, Event* event)
{
	if (m_selectingCard)
	{
		// Moving and swap card
		if (m_targetCard)
		{
			swapCard(m_selectingCard, m_targetCard);
			m_selectingCard = nullptr;
			m_targetCard = nullptr;
		}
		// Just moving/swap card
		else 
		{
			// SSCard's not moving, user want select it
			if (!m_bMovingCard)
			{
				Vec2 pos = Vec2(m_selectingCard->m_posOrigin.x, m_selectingCard->m_posOrigin.y + 10.0f);
				m_selectingCard->setPosition(pos);
			}
			// SSCard's moving, user want to cancel 
			else
			{
				m_selectingCard->setPosition(m_selectingCard->m_posOrigin);
				m_selectingCard = nullptr;
			}
			
			for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
			{
				SSCard* card = m_v_vCard.at(0).at(i);
				m_pnlPlayerAreas[0]->reorderChild(card, i);
			}
		}
	}

	m_bTouchBeganCard = false;
	m_bMovingCard = false;
}

void CapsaSusunScene::verifyHand()
{
	vector<int> firstHandCardIds = {};
	vector<int> secondHandCardIds = {};
	vector<int> thirdHandCardIds = {};
	vector<int> allCardIds = {};
	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		if (i < 3) firstHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
		else if (i < 8) secondHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
		else thirdHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
		allCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
	}

	CardHand* firstHand = CardSusunHelper::getSusunHand(firstHandCardIds);
	CardHand* secondHand = CardSusunHelper::getSusunHand(secondHandCardIds);
	CardHand* thirdHand = CardSusunHelper::getSusunHand(thirdHandCardIds);
	if (!CardSusunHelper::compare(thirdHand, secondHand)
		|| !CardSusunHelper::compare(secondHand, firstHand))
	{
		log("binh lung");
	}

	vector<int> vCardId = {};
	firstHandCardIds = firstHand->getCardIds();
	secondHandCardIds = secondHand->getCardIds();
	thirdHandCardIds = thirdHand->getCardIds();

	vCardId.insert(vCardId.end(), firstHandCardIds.begin(), firstHandCardIds.end());
	vCardId.insert(vCardId.end(), secondHandCardIds.begin(), secondHandCardIds.end());
	vCardId.insert(vCardId.end(), thirdHandCardIds.begin(), thirdHandCardIds.end());
	setUsingCards(vCardId);
	
	// Check maubinh
	bool bMauBinh = false;
	std::string strMauBinh;
	std::string font;

	if (CardSusunHelper::checkDragonSameSuit(allCardIds)) {
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON_SAME_SUIT);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkDragon(allCardIds)) {
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_DRAGON);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkSameSuit(allCardIds)) {
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_SAME_SUIT);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkFivePairsOneTriple(allCardIds)) {
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_FIVE_PAIR_ONE_TRIPLE);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkSixPairs(allCardIds)) {
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_SIX_PAIRS);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkThreeFlushes(allCardIds)) {
		SFSConnection::getInstance()->requestMauBinh(32, allCardIds);
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_THREE_FLUSH);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}
	else if (CardSusunHelper::checkThreeStraights(allCardIds)) {
		SFSConnection::getInstance()->requestMauBinh(31, allCardIds);
		strMauBinh = ResourceManager::getInstance()->getTextByName(kTEXT_THREE_STRAIGHT);
		font = "bf2-export.fnt";
		bMauBinh = true;
	}

	if (bMauBinh) {
		m_btnSort->setVisible(false);
		m_btnFinish->setVisible(false);
		m_btnChange->setVisible(false);
		m_btnSwap->setVisible(false);
		m_pnlPlayerAreas[0]->runAction(ScaleTo::create(0.2f, 1.0f));

		m_pUILayer->removeChildByName("tfMauBinh");
		Size deviceSize = Director::getInstance()->getWinSize();
		Vec2 pos = Vec2(deviceSize.width / 2, 120.0f);
		TextBMFont* bmFont = TextBMFont::create(strMauBinh.c_str(), font.c_str());
		bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
		bmFont->setPosition(pos);
		bmFont->setZOrder(4);
        bmFont->setName("tfMauBinh");
		this->m_pUILayer->addChild(bmFont);
		m_tfMauBinh = bmFont;
	}
}

void CapsaSusunScene::dealCards(int cards[13])
{
	Size deviceSize = Director::getInstance()->getWinSize();
    m_pnlPlayerAreas[0]->setScale(1.0f);

    // Sanity! Remove all cards before deal
    for (int i = 0, l = m_v_vCard.size(); i < l; i++)
    {
        for (int j = 0, lj = m_v_vCard.at(i).size(); j < lj; j++)
        {
            SSCard* card = m_v_vCard.at(i).at(j);
            if (card!=nullptr) card->removeFromParentAndCleanup(true);
        }
    }
	for (int i = 0, l = m_vUserInfoOthers->size(); i < l; i++) {
		m_vUserInfoOthers->at(i)->setVisibleKickBtn(false);
	}
    m_v_vCard.clear();

	m_v_vCard = {};
	m_v_vCard.push_back(vector<SSCard*>{});
	m_v_vCard.push_back(vector<SSCard*>{});
	m_v_vCard.push_back(vector<SSCard*>{});
	m_v_vCard.push_back(vector<SSCard*>{});
	int noPlayer = GlobalVariable::m_vPlayersSorted->size();
	for (int k = 0; k < noPlayer; k++)
	{
		int i = GlobalVariable::m_vPlayersSorted->at(k)->m_iPlayerArea;
		vector<Vec2> vPos;
		if (i == 0 && !m_bJoinGame) vPos = m_vBottomCardPos;
		else vPos = m_v_vCardPos.at(i);
		for (int j = 0; j < 13; j++)
		{
            int cardId = (i == 0 &&  m_bJoinGame) ? cards[j] : -1;
			SSCard* card = SSCard::create(cardId);
			card->setVisible(false);
			if (i == 0 && m_bJoinGame)
			{
                setRotationCard(card, j);
			}
            card->m_fRotationOrigin = card->getRotation();
			m_pnlPlayerAreas[i]->addChild (card);
			m_v_vCard.at(i).push_back(card);

			Vec2 originPos = m_pnlPlayerAreas[i]->convertToNodeSpace(Vec2(deviceSize.width / 2, deviceSize.height / 2));
			Vec2 targetPos = vPos.at(j);
			card->setPosition(originPos);
			card->m_posOrigin = targetPos;
			if (i == 0 && m_bJoinGame) card->setScale(0.25f);
			else card->setScale(0.25f);

			_eventDispatcher->removeEventListenersForTarget(card);
			MoveTo* moveAct = MoveTo::create(0.2f, targetPos);
			Sequence* sequence;
			CallFunc* addAct = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onVisibleNode, this, card));
			// Last card be dealed
			if (k == noPlayer-1 && j == 12)
			{
				auto callback = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onFinishDealingCards, this));
				card->runAction(Sequence::create(DelayTime::create(0.02f*i + 0.1f*j), callback, nullptr));
			}
			// User's card
			if (i == 0 && m_bJoinGame)
			{
				sequence = Sequence::create(DelayTime::create(0.02f*i + 0.1f*j), addAct, moveAct, nullptr);
				card->runAction(Sequence::create(DelayTime::create(0.02f*i + 0.1f*j), ScaleTo::create(0.2f, 0.5f), nullptr));
			}
			else 
			{
                sequence = Sequence::create(
                                            DelayTime::create(0.01f*i + 0.05f*j)
                                            , addAct
                                            , Spawn::create(moveAct, FadeTo::create(0.2f, 0), nullptr)
                                            , CallFunc::create(CC_CALLBACK_0(Node::setVisible, card, false))
                                            , nullptr);
			}
			card->runAction(sequence);
		}
	}

    for (int i = 0, l = m_vUserInfoOthers->size(); i < l; i++)
    {
        SSUserInfo* userInfo = m_vUserInfoOthers->at(i);
        if (userInfo != nullptr)
        {
            userInfo->visibleSortStateBg(true);
            userInfo->setSortState(false);
        }
    }
}

void CapsaSusunScene::setRotationCard(SSCard* card, int index)
{
    if (index < 3)        card->setRotation(-3.0f + 3.0f * index);
    else if (index < 5)   card->setRotation(-9.0f + 6.0f * (index - 3));
    else if (index == 5)  card->setRotation(0.0f);
    else if (index < 8)   card->setRotation(6.0f + 3.0f * (index - 6));
    else if (index < 10)  card->setRotation(-9.0f + 6.0f * (index - 8));
    else if (index == 10) card->setRotation(0.0f);
    else card->setRotation(6.0f + 3.0f * (index - 11));
}

void CapsaSusunScene::onTouchBtnBonus(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    QuestBonusPopup* popup = new QuestBonusPopup();
    openPopup(popup);
}

void CapsaSusunScene::onTouchBtnStart(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
	//TODO! must check "can start game" here
    AudioManager::getInstance()->playBackgroundMusic(kSoundMusicStart);
    m_btnStart->setVisible(false);
    SFSConnection::getInstance()->startGame();
}

void CapsaSusunScene::onTouchBtnFinish(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
	m_bCansort = false;
    m_btnSort->setVisible(false);
	m_btnSwap->setVisible(false);
    vector<int>* m_vCardsId = new vector<int>();
    for(int i = 0; i < 13; i++)
    {
        m_vCardsId->push_back(m_v_vCard.at(0).at(i)->m_iId);
        _eventDispatcher->removeEventListenersForTarget(m_v_vCard.at(0).at(i));
    }
    m_pnlPlayerAreas[0]->runAction(ScaleTo::create(0.2f, 1.5f));
    if(m_bFinishSended == false)
    {
        SFSConnection::getInstance()->xepxong(m_vCardsId, true);
        m_bFinishSended = true;
    }
    m_btnFinish->setVisible(false);
    m_btnChange->setVisible(true);
    m_bmfSortDone->setVisible(true);
    Button* bg = static_cast<Button*>(m_pnlPlayerAreas[0]->getChildByName("overlay"));
    if (bg) bg->setVisible(false);

    vector<int> firstHandCardIds = {};
    vector<int> secondHandCardIds = {};
    vector<int> thirdHandCardIds = {};
    vector<int> allCardIds = {};
    for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
    {
        if (i < 3) firstHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
        else if (i < 8) secondHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
        else thirdHandCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
        allCardIds.push_back(m_v_vCard.at(0).at(i)->m_iId);
    }
    CardHand* firstHand = CardSusunHelper::getSusunHand(firstHandCardIds);
    CardHand* secondHand = CardSusunHelper::getSusunHand(secondHandCardIds);
    CardHand* thirdHand = CardSusunHelper::getSusunHand(thirdHandCardIds);
    bool firstCheck = false;
    bool secondCheck = false;
    if (thirdHand->getType() == CardHand::HIGH_CARD && secondHand->getType() == CardHand::HIGH_CARD) {
        firstCheck = CardSusunHelper::compareHighHands(thirdHandCardIds, secondHandCardIds);
    }
    else {
        firstCheck = CardSusunHelper::compare(thirdHand, secondHand);
    }
    if (secondHand->getType() == CardHand::HIGH_CARD && firstHand->getType() == CardHand::HIGH_CARD) {
        secondCheck = CardSusunHelper::compareHighHands(secondHandCardIds, firstHandCardIds);
    }
    else {
        secondCheck = CardSusunHelper::compare(secondHand, firstHand);
    }


    if (!firstCheck
        || !secondCheck)
    {
        m_pUILayer->removeChildByName("tfMauBinh");
        Size deviceSize = Director::getInstance()->getWinSize();
        Vec2 pos = Vec2(deviceSize.width / 2, 120.0f);
        TextBMFont* bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_BINH_LUNG), "bf2-export.fnt");
        bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
        bmFont->setPosition(pos);
        bmFont->setZOrder(4);
        bmFont->setName("tfMauBinh");
        this->m_pUILayer->addChild(bmFont);
        m_tfMauBinh = bmFont;
    }
}

void CapsaSusunScene::onTouchBtnChange(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
	m_bCansort = true;
    m_btnSort->setVisible(true);
	m_btnSwap->setVisible(true);
    vector<int>* m_vCardsId = new vector<int>();
    for(int i = 0; i < 13; i++)
    {
        m_vCardsId->push_back(m_v_vCard.at(0).at(i)->m_iId);
    }
    addCardsTouchHandler();
    m_pnlPlayerAreas[0]->runAction(ScaleTo::create(0.2f, 2.2f));
    if(m_bFinishSended == false)
    {
        m_bFinishSended = true;
        SFSConnection::getInstance()->xepxong(m_vCardsId, true);
    }
    else
    {
        m_bFinishSended = false;
        SFSConnection::getInstance()->xepxong(m_vCardsId, false);
    }
    m_btnFinish->setVisible(true);
    m_btnChange->setVisible(false);
    m_bmfSortDone->setVisible(false);
    Button* bg = static_cast<Button*>(m_pnlPlayerAreas[0]->getChildByName("overlay"));
    if (bg) bg->setVisible(true);

    m_pUILayer->removeChildByName("tfMauBinh");
}

void CapsaSusunScene::onTouchBtnSort(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type || !m_bCanTouchBtnSort || !m_bCansort) return;
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
	if (CapsaSusunScene::SORT_RANK == m_iSortState) m_iSortState = CapsaSusunScene::SORT_SUIT;
	else if (CapsaSusunScene::SORT_SUIT == m_iSortState) m_iSortState = CapsaSusunScene::SORT_HAND;
    else if (CapsaSusunScene::SORT_HAND == m_iSortState) m_iSortState = CapsaSusunScene::SORT_RANK;
	else m_iSortState = CapsaSusunScene::SORT_RANK;

	vector<int> vCardId = {};
	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		vCardId.push_back(m_v_vCard.at(0).at(i)->m_iId);
	}

	if (CapsaSusunScene::SORT_RANK == m_iSortState) CardSusunHelper::sortByUpRank(vCardId);
	else if (CapsaSusunScene::SORT_SUIT == m_iSortState) CardSusunHelper::sortBySuit(vCardId);
    else if (CapsaSusunScene::SORT_HAND == m_iSortState) CardSusunHelper::sortByHand(vCardId);
	vector<SSCard*> vTmpCard = m_v_vCard.at(0);
	m_v_vCard.at(0).clear();
	for (int i = 0, l = vCardId.size(); i < l; i++)
	{	
		int cardId = vCardId.at(i);
		for (int j = 0, lj = vTmpCard.size(); j < lj; j++)
		{
			SSCard* card = vTmpCard.at(j);
			if (card->m_iId == cardId)
			{
				m_v_vCard.at(0).push_back(card);
				break;
			}
		}
	}

	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
        card->stopAllActions();
        card->setRotation(card->m_fRotationOrigin);
        card->setPosition(card->m_posOrigin);
		Vec2 pos = m_v_vCardPos.at(0).at(i);
		MoveTo* moveAct = MoveTo::create(0.1f, pos);
		card->m_posOrigin = pos;
		card->runAction(moveAct);
		m_pnlPlayerAreas[0]->reorderChild(card, i);
        setRotationCard(card, i);
        card->m_fRotationOrigin = card->getRotation();
        card->runAction(RotateTo::create(0.1f, card->m_fRotationOrigin));
	}

	verifyHand();
    if (m_btnFinish->isVisible()) {
        addCardsTouchHandler();
    }

	disableSort();
	runAction(Sequence::create(DelayTime::create(0.5f), CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::enableSort, this)) ,nullptr));
}

void CapsaSusunScene::onTouchBtnSwap(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type || !m_bCanTouchBtnSort || !m_bCansort) return;
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
	std::swap(m_v_vCard.at(0)[3], m_v_vCard.at(0)[8]);
	std::swap(m_v_vCard.at(0)[4], m_v_vCard.at(0)[9]);
	std::swap(m_v_vCard.at(0)[5], m_v_vCard.at(0)[10]);
	std::swap(m_v_vCard.at(0)[6], m_v_vCard.at(0)[11]);
	std::swap(m_v_vCard.at(0)[7], m_v_vCard.at(0)[12]);

    for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
    {
        SSCard* card = m_v_vCard.at(0).at(i);
        card->stopAllActions();
        card->setRotation(card->m_fRotationOrigin);
        card->setPosition(card->m_posOrigin);
    }
	for (int i = 3; i < 8; i++)
	{
		SSCard* cardA = m_v_vCard.at(0).at(i);
		SSCard* cardB = m_v_vCard.at(0).at(i+5);
        cardA->stopAllActions();
        cardB->stopAllActions();
        cardA->setRotation(cardA->m_fRotationOrigin);
        cardB->setRotation(cardB->m_fRotationOrigin);
		MoveTo* moveCardA = MoveTo::create(0.1f, cardB->m_posOrigin);
		MoveTo* moveCardB = MoveTo::create(0.1f, cardA->m_posOrigin);
		Vec2 tmpPos = cardA->m_posOrigin;
		cardA->m_posOrigin = cardB->m_posOrigin;
		cardB->m_posOrigin = tmpPos;
		cardA->runAction(moveCardA);
		cardB->runAction(moveCardB);
	}

	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
		m_pnlPlayerAreas[0]->reorderChild(card, i);
	}

	verifyHand();
}

void CapsaSusunScene::onFinishDealingCards()
{
	addCardsTouchHandler();

	stringstream ss;
	ss << m_iTime;
	m_bmfTimer->setString(ss.str());
	auto moveMuteReverse1 = MoveTo::create(m_iTime - 0.5f, Vec2(m_imgTimeBg->getPositionX() - m_imgTimeBg->getContentSize().width / 2, m_imgTimeBg->getPositionY() + 4));
    m_imgLight->runAction(Sequence::create(moveMuteReverse1, CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onEndPrgTimer, this)), nullptr));
	unschedule(schedule_selector(CapsaSusunScene::onPrgTimer));
	schedule(schedule_selector(CapsaSusunScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);

	
	if (m_bJoinGame) {
		m_gamebarContainer->setVisible(true);
		m_gamebarContainer->setOpacity(0);
		m_gamebarContainer->runAction(FadeTo::create(0.5f, 255));

		m_btnFinish->setVisible(true);
		m_btnChange->setVisible(false);
		m_pnlPlayerAreas[0]->runAction(Sequence::create(DelayTime::create(0.5f), ScaleTo::create(0.2f, 2.2f), CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::verifyHand, this)), nullptr));

		m_bCansort = true;
		m_btnSort->setVisible(true);
		m_btnSwap->setVisible(true);
	}

    // Adding overlay to prevent user interactive
    LayerColor* overlay = LayerColor::create(Color4B(0, 0, 0, 170));
	Size deviceSize = Director::getInstance()->getWinSize();
    overlay->setContentSize(Size(deviceSize.width, deviceSize.height));
    overlay->setPosition(Vec2( - deviceSize.width / 2.0f, 0.0f));
    overlay->setZOrder(-1);
    overlay->setName("overlay");
    m_pnlPlayerAreas[0]->addChild(overlay);
}

void CapsaSusunScene::onPrgTimer(float dt)
{
	float percent = (100 * (m_imgLight->getPositionX() - (m_imgTimeBg->getPositionX() - m_imgTimeBg->getContentSize().width / 2))) / m_imgTimeBg->getContentSize().width;
	int timeRemain = (m_iTime * percent) / 100.0f;
	stringstream ss;
	ss << timeRemain;
	m_bmfTimer->setString(ss.str());
    m_prgTImer->setPercent(percent);
}

void CapsaSusunScene::onCountDownTimer(float dt) 
{
    m_iLastCount = round(m_fCountTimeLeft);
    m_fCountTimeLeft = m_fCountTimeLeft - dt;
    m_iCurrentCount = round(m_fCountTimeLeft);
    if(m_fCountTimeLeft < 0)
    {
        m_bmfCountDown->setVisible(false);
        m_pnlCountDown->setVisible(false);
        unschedule(schedule_selector(CapsaSusunScene::onCountDownTimer));
        return;
    }
    if(m_iLastCount != m_iCurrentCount)
    {
        AudioManager::getInstance()->playEffect(kSoundEffectCountDown);
    }
    m_bmfCountDown->setString(ccsf("%1.0f", m_fCountTimeLeft));
}

void CapsaSusunScene::onEndPrgTimer()
{
    m_gamebarContainer->runAction(Sequence::create(
        FadeTo::create(0.2f, 0.0f), 
        CallFunc::create(CC_CALLBACK_0(Node::setVisible, m_gamebarContainer, false)), 
        nullptr));

    // Disable all card interactives
    if (m_selectingCard != nullptr)
    {
        m_selectingCard->setPosition(m_selectingCard->m_posOrigin);
        for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
        {
            SSCard* card = m_v_vCard.at(0).at(i);
            m_pnlPlayerAreas[0]->reorderChild(card, i);
        }
    }
    m_selectingCard = nullptr;
    m_bTouchBeganCard = false;
    m_bMovingCard = false;

    // Remove all cards event and send msg sort finish to user
    vector<int>* m_vCardsId = new vector<int>();
    for(int i = 0; i < 13; i++)
    {
        SSCard* card = m_v_vCard.at(0).at(i);
        _eventDispatcher->removeEventListenersForTarget(card);
        m_vCardsId->push_back(m_v_vCard.at(0).at(i)->m_iId);
    }
    verifyHand();
}

void CapsaSusunScene::addCardsTouchHandler()
{
	for (int i = 0, l = m_v_vCard.at(0).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(0).at(i);
		_eventDispatcher->removeEventListenersForTarget(card);
		auto listener = EventListenerTouchOneByOne::create();
	    listener->setSwallowTouches(true);
	    listener->onTouchBegan = CC_CALLBACK_2(CapsaSusunScene::onCardTouchBegan, this);
	    listener->onTouchMoved = CC_CALLBACK_2(CapsaSusunScene::onCardTouchMoved, this);
	    listener->onTouchEnded = CC_CALLBACK_2(CapsaSusunScene::onCardTouchEnded, this);
		_eventDispatcher->addEventListenerWithSceneGraphPriority(listener, card);
	}
}

void CapsaSusunScene::showHand(int cardList[13], int iPlayerIndex, int iHandIndex)
{
	Size deviceSize = Director::getInstance()->getWinSize();

	// Get cards and  resort Z order
	int iBegin;
	int iEnd;
	if (iHandIndex == 1)
	{
		iBegin = 0;
		iEnd = 2;
	}
	else if (iHandIndex == 2)
	{
		iBegin = 3;
		iEnd = 7;
	}
	else if (iHandIndex == 3)
	{
		iBegin = 8;
		iEnd = 12;
	}

	int count = 0;
	Vec2 offPos;
	if (iPlayerIndex == 0) offPos = Vec2(deviceSize.width/2, deviceSize.height/2 - 100.0f);
	else if (iPlayerIndex == 1) offPos = Vec2(deviceSize.width/2 + 300.0f, deviceSize.height/2);
	else if (iPlayerIndex == 2) offPos = Vec2(deviceSize.width/2, deviceSize.height/2 + 100.0f);
	else if (iPlayerIndex == 3) offPos = Vec2(deviceSize.width/2 - 300.0f, deviceSize.height/2);
	offPos = m_pnlPlayerAreas[iPlayerIndex]->convertToNodeSpace(offPos);

	vector<int> vCardId = {};
	for (int i = 0, l = m_v_vCard.at(iPlayerIndex).size(); i < l; i++)
	{
		if (i < iBegin || i > iEnd) continue;

		// Resort order
		SSCard* card = m_v_vCard.at(iPlayerIndex).at(i);
		card->getParent()->reorderChild(card, 2);
		vCardId.push_back(cardList[i]);

		Vec2 targetPos = m_v_vCardAnimPos.at(iPlayerIndex).at(i);
        // Just moving cards
		if (iPlayerIndex == 0)
		{
			// card->runAction(Sequence::create(DelayTime::create(0.1f * count), moveAct, nullptr));
			// card->runAction(Sequence::create(
			// 	DelayTime::create(5.0f),
			// 	MoveTo::create(0.2f, card->m_posOrigin),
			// 	nullptr));
		}
		// Move cards and also change its face
		else 
		{
			card->runAction(Sequence::create(
				DelayTime::create(0.1f * count + 0.1f), 
				ScaleTo::create(0.2f, 0.0f, 0.5f),
				CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onOpenCard, this, card, cardList[i])), 
				ScaleTo::create(0.2f, 0.5f),
				nullptr));
		}
        card->runAction(Sequence::create(
                DelayTime::create(5.0f),
                CallFunc::create(CC_CALLBACK_0(Node::setColor, card, Color3B(100, 100, 100))),
                nullptr));
		count++;
	}

	CardHand* hand = CardSusunHelper::getSusunHand(vCardId);
	int handType = hand->getType();
	showHandResult(handType, iPlayerIndex, iHandIndex);
}

void CapsaSusunScene::showHandWithDelay(float delayTime, int cardList[13], int iPlayerIndex, int iHandIndex)
{
	DelayTime* delay = DelayTime::create(delayTime);
	CallFunc* func = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::showHand, this, cardList, iPlayerIndex, iHandIndex));
	runAction(Sequence::create(delay, func, nullptr));
}

void CapsaSusunScene::onOpenCard(SSCard* card, int id)
{
	card->setId(id);
}

void CapsaSusunScene::showMoney(int value, int iPlayerIndex)
{
	Size deviceSize = Director::getInstance()->getWinSize();

    string strMoney = ccsf("%1.0d", abs(value));
    strMoney = TTutil::addDot(strMoney);
    if(value < 0)
    {
        strMoney = ccsf("-%s", strMoney.c_str());
    }
    else if(value > 0)
    {
        strMoney = ccsf("+%s", strMoney.c_str());
    }
    else
    {
        strMoney = "+0";
    }

	TextBMFont* txtBMMoney = TextBMFont::create(strMoney, value < 0 ? "LosemoneyFont.fnt" : "WinmoneyFont.fnt");
	this->addChild(txtBMMoney);

	Vec2 offPos;
	if (iPlayerIndex == 0) offPos = Vec2(deviceSize.width/2, deviceSize.height/2 - 250.0f);
	else if (iPlayerIndex == 1) offPos = Vec2(deviceSize.width/2 + 300.0f, deviceSize.height/2);
	else if (iPlayerIndex == 2) offPos = Vec2(deviceSize.width/2, deviceSize.height/2 + 100.0f);
	else if (iPlayerIndex == 3) offPos = Vec2(deviceSize.width/2 - 300.0f, deviceSize.height/2);

	txtBMMoney->setPosition(Vec2(offPos.x, offPos.y + 90.0f));
	txtBMMoney->setOpacity(0);
	txtBMMoney->runAction(MoveBy::create(4.0f, Vec2(0.0f, 60.0f)));
	txtBMMoney->runAction(Sequence::create(
		FadeTo::create(0.5f, 255),
		DelayTime::create(3.0f),
		FadeTo::create(0.5f, 0),
		CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onDeleteNode, this, txtBMMoney)),
		nullptr));
	if (value == 0) return;

	Sprite* sprite = Sprite::create();
	sprite->setPosition(offPos);
	this->addChild(sprite);
	if (value > 0)
    {
        auto animWin = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimWin]->getSkeleton()->data);
        if(GlobalVariable::m_iCurrentLanguage == 0)
        {
            animWin->setMix("menang", "menang", 2.0f);
            animWin->addAnimation(0, "menang", false);
        }
        else
        {
            animWin->setMix("win", "win", 2.0f);
            animWin->addAnimation(0, "win", false);
        }
        sprite->addChild(animWin);
	}
	else if (value < 0)
    {
        auto animLose = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLose]->getSkeleton()->data);
        if(GlobalVariable::m_iCurrentLanguage == 0)
        {
            animLose->setMix("kalah", "kalah", 2.0f);
            animLose->addAnimation(0, "kalah", false);
        }
        else
        {
            animLose->setMix("lose", "lose", 2.0f);
            animLose->addAnimation(0, "lose", false);
        }
        sprite->addChild(animLose);
	}
}

void CapsaSusunScene::showMoneyWithDelay(float delayTime, int value, int iPlayerIndex)
{
	DelayTime* delay = DelayTime::create(delayTime);
	CallFunc* func = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::showMoney, this, value, iPlayerIndex));
	runAction(Sequence::create(delay, func, nullptr));
}

void CapsaSusunScene::onDeleteNode (Node* node)
{
	node->removeFromParentAndCleanup(true);
}

void CapsaSusunScene::onAddNode (Node* parent, Node* child)
{
	parent->addChild(child);
}

void CapsaSusunScene::onVisibleNode (Node* node)
{
	node->setVisible(true);
}

void CapsaSusunScene::showMessage(bool bVisible, const char* messageid)
{
    pnlInvite->setVisible(bVisible);
    if(bVisible)
    {
        Text* lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(messageid));
    }
}

void CapsaSusunScene::onShowEndGameResult()
{
	// Has result, can show immediately
	if (m_bHasEndGameResult)
	{
		m_bHasEndGameResult = false;
        // start count down timer
        auto deviceSize = Director::getInstance()->getWinSize();
        m_pnlCountDown->setVisible(true);
        m_bmfCountDown->setVisible(true);
        m_bmfCountDown->setString("10");
        if(m_pnlCountDown->getChildByName("sangvanmoi"))m_pnlCountDown->removeChildByName("sangvanmoi");
        auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
        animCountDown->setName("sangvanmoi");
        animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
        animCountDown->addAnimation(0, "sangvanmoi", true);
        m_pnlCountDown->addChild(animCountDown);
        m_fCountTimeLeft = 10.000f;
        unschedule(schedule_selector(CapsaSusunScene::onCountDownTimer));
        schedule(schedule_selector(CapsaSusunScene::onCountDownTimer), 1.0f, kRepeatForever, 0.0f);
		for (int i = 0, l = GlobalVariable::m_vPlayersSorted->size(); i < l; i++)
		{
            int iPlayerArea = GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea;
			double money = m_vMoneyResult.at(iPlayerArea);
			showMoneyWithDelay(0.2f, money, iPlayerArea);
		}
	}

	// Has not result, continue waitting
	CallFunc* showAct = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onShowEndGameResult, this));
    runAction(Sequence::create(DelayTime::create(1.0f), showAct, nullptr));
}

void CapsaSusunScene::showSpecialHandResult(std::string sResult, std::string sFont, int aCardId[13], int iPlayerArea, float showingTime)
{
    Vec2 pos = m_v_vCardAnimPos.at(iPlayerArea).at(5);
	TextBMFont* bmFont = TextBMFont::create(sResult, sFont.c_str());
	bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
	bmFont->setPosition(pos);
	bmFont->setZOrder(4);
	this->m_pUILayer->addChild(bmFont);

	bmFont->setOpacity(0);
	bmFont->runAction(Sequence::create(
		FadeTo::create(1.0f, 255), 
		DelayTime::create(showingTime),
		FadeTo::create(1.0f, 0),
		CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onDeleteNode, this, bmFont)),
		nullptr));

	// Turn up all cards
	for (int i = 0, l = m_v_vCard.at(iPlayerArea).size(); i < l; i++)
	{
		SSCard* card = m_v_vCard.at(iPlayerArea).at(i);
		card->runAction(Sequence::create(
			ScaleTo::create(0.2f, 0.0f, card->getScaleY()),
			CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onOpenCard, this, card, aCardId[i])),
			ScaleTo::create(0.2f, card->getScaleY(), card->getScaleY()),
			nullptr));
	}
}

void CapsaSusunScene::showHandResult(int iType, int iPlayerArea, int iHandIndex)
{
    Size deviceSize = Director::getInstance()->getWinSize();

    // Get positions
    int targetIndex = 1;
    if (iHandIndex == 1) targetIndex = 5;
    else if (iHandIndex == 2) targetIndex = 10;
    else if (iHandIndex == 3) targetIndex = 5;
    Vec2 pos = m_v_vCardAnimPos.at(iPlayerArea).at(targetIndex);
    if (iHandIndex == 1 || iHandIndex == 2) pos.y -= 50.0f;
    else pos.y += 50.0f;

    // Get bitmap font
    std::string sResult = "";
    TextBMFont* bmFont = 0;
    if (CardHand::STRAIGHT_FLUSH       == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_STRAIGHT_FLUSH).c_str(), "bf4-export.fnt");
    else if (CardHand::FOUR_OF_A_KIND  == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_FOUR_OF_A_KIND).c_str(), "bf9-export.fnt");
	else if (CardHand::FULL_HOUSE	   == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_FULL_HOUSE).c_str(), "bf4-export.fnt");
    else if (CardHand::FLUSH           == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_FLUSH).c_str(), "bf2-export.fnt");
    else if (CardHand::STRAIGHT        == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_STRAIGHT).c_str(), "bf0-export.fnt");
    else if (CardHand::THREE_OF_A_KIND == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_THREE_OF_A_KIND).c_str(), "bf9-export.fnt");
    else if (CardHand::TWO_PAIR        == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_TWO_PAIR).c_str(), "bf4-export.fnt");
    else if (CardHand::PAIR            == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_PAIR).c_str(), "bf2-export.fnt");
    else if (CardHand::HIGH_CARD       == iType) bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_HIGH_CARD).c_str(), "bf0-export.fnt");
    else                                         bmFont = TextBMFont::create(ResourceManager::getInstance()->getTextByName(kTEXT_HIGH_CARD).c_str(), "bf0-export.fnt");

	bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
	bmFont->setPosition(pos);
    bmFont->setZOrder(3);
	this->m_pUILayer->addChild(bmFont);

	bmFont->setOpacity(0);
	bmFont->runAction(Sequence::create(
		FadeTo::create(1.0f, 255), 
		DelayTime::create(3.0f),
		FadeTo::create(1.0f, 0),
		CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onDeleteNode, this, bmFont)),
		nullptr));
}

void CapsaSusunScene::showHandResultWithDelay(float time, int iType, int iPlayerIndex, int iHandIndex)
{
	DelayTime* delayAct =  DelayTime::create(time);
	Sequence* wholeAct = Sequence::create(delayAct, CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::showHandResult, this, iType, iPlayerIndex, iHandIndex)), nullptr);
	runAction(wholeAct);
}

void CapsaSusunScene::changeLanguage(Ref* obj)
{
    TextBMFont* bmfBtnSort     = static_cast<TextBMFont*>(m_btnSort->getChildByName("bmfBtnSort"));
    TextBMFont* bmfBtnSort_0   = static_cast<TextBMFont*>(m_btnSort->getChildByName("bmfBtnSort_0"));
    TextBMFont* bmfBtnChange   = static_cast<TextBMFont*>(m_btnChange->getChildByName("bmfBtnChange"));
    TextBMFont* bmfBtnChange_0 = static_cast<TextBMFont*>(m_btnChange->getChildByName("bmfBtnChange_0"));
    TextBMFont* bmfBtnSwap     = static_cast<TextBMFont*>(m_btnSwap->getChildByName("bmfBtnSwap"));
    TextBMFont* bmfBtnSwap_0   = static_cast<TextBMFont*>(m_btnSwap->getChildByName("bmfBtnSwap_0"));
    TextBMFont* bmfBtnFinish     = static_cast<TextBMFont*>(m_btnFinish->getChildByName("bmfBtnFinish"));
    if(GlobalVariable::m_iCurrentLanguage == 0)//Indo
    {
        bmfBtnFinish->setString("Siap");

        bmfBtnSort->setPositionY(70);
        bmfBtnSort->setString("Atur");
        bmfBtnSort_0->setVisible(true);
        bmfBtnSort_0->setString("kartu");

        bmfBtnChange->setPositionY(70);
        bmfBtnChange->setString("Susun");
        bmfBtnChange_0->setVisible(true);
        bmfBtnChange_0->setString("lagi");

        bmfBtnSwap->setPositionY(70);
        bmfBtnSwap->setString("Perubahan");
        bmfBtnSwap_0->setVisible(true);
        bmfBtnSwap_0->setString("baris");
    }
    else
    {
        bmfBtnFinish->setString("Done");

        bmfBtnSort->setPositionY(55);
        bmfBtnSort->setString("Sort");
        bmfBtnSort_0->setVisible(false);

        bmfBtnChange->setPositionY(55);
        bmfBtnChange->setString("Rearrange");
        bmfBtnChange_0->setVisible(false);

        bmfBtnSwap->setString("Change");
        bmfBtnSwap_0->setString("hand");
    }
    TextBMFont* bmfStart = static_cast<TextBMFont*>(m_btnStart->getChildByName("bmfBtnStart"));
    bmfStart->setString(ResourceManager::getInstance()->getTextByName(kTEXT_START));
}

void CapsaSusunScene::updateCardPos()
{
    vector<int>* vCardsId = new vector<int>();
    for(int i = 0; i < 13; i++)
    {
        SSCard* card = m_v_vCard.at(0).at(i);
        vCardsId->push_back(m_v_vCard.at(0).at(i)->m_iId);
    }
}

void CapsaSusunScene::onNetworkSendPublishMsr(Ref* obj)
{
    // Add chat toast as main player
    String* msr = (String*)obj;
    ChatToast* toast = ChatToast::create(msr->getCString());
    Size deviceSize = Director::getInstance()->getWinSize();
    //Vec2 position = m_vChatToastPosition.at(0);
    toast->setPosition(Vec2(300.0f, deviceSize.height - 140.0f));
    m_pUILayer->addChild(toast);
}

void CapsaSusunScene::onNetworkGetPublishMsr(Ref* obj)
{
    // Add chat toast as other players
    int noPlayer = GlobalVariable::m_vPlayersSorted->size();
    MsrObject* msrObj = static_cast<MsrObject*>(obj);
    // Find player who sent msr
    int i;
    int index = -1;
    for (i = 1; i < noPlayer; i++)
    {
        int checkId = GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId;
        if (checkId == msrObj->m_dId)
        {
            index = GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea;
            break;
        }
    }
    if (index == -1) return;
    // Add chat toast
    ChatToast* toast = ChatToast::create(msrObj->m_sUsername);
    Vec2 position = m_vChatToastPosition.at(index);
    toast->setPosition(position);
    m_pUILayer->addChild(toast);
}

void CapsaSusunScene::disableSort()
{
	m_bCanTouchBtnSort = false;
}

void CapsaSusunScene::enableSort()
{
	m_bCanTouchBtnSort = true;
}

void CapsaSusunScene::showChiResultWithDelay(float time, int iType, int iPlayerIndex, int iHandIndex)
{
	DelayTime* delay = DelayTime::create(time);
	CallFunc* func = CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::showChiResult, this, iType, iPlayerIndex, iHandIndex));
	runAction(Sequence::create(delay, func, nullptr));
}
void CapsaSusunScene::showChiResult(int iType, int iPlayerIndex, int iHandIndex)
{
	Size deviceSize = Director::getInstance()->getWinSize();
    std::string strWin = ResourceManager::getInstance()->getTextByName(kTEXT_WIN);
    std::string strLose = ResourceManager::getInstance()->getTextByName(kTEXT_LOSE);
	TextBMFont* bmFont = TextBMFont::create(iType == 1 ? strLose : strWin, iType == 1 ? "bf0-export.fnt" : "bf2-export.fnt");
	int targetIndex = 1;
	if (iHandIndex == 1) targetIndex = 5;
	else if (iHandIndex == 2) targetIndex = 10;
	else if (iHandIndex == 3) targetIndex = 5;
	Vec2 pos = m_v_vCardAnimPos.at(iPlayerIndex).at(targetIndex);
	if (iHandIndex == 1 || iHandIndex == 2) pos.y += 50.0f;
	else pos.y -= 50.0f;

	bmFont->setAnchorPoint(Vec2(0.5f, 0.5f));
	bmFont->setPosition(pos);
	bmFont->setZOrder(4);

    if(iType == 1)
    {
        if(m_pUILayer->getChildByName("animBadEffect"))m_pUILayer->removeChildByName("animBadEffect");
        auto animBadEffect = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimBad]->getSkeleton()->data);
        animBadEffect->setScale(0.5f);
        animBadEffect->setName("animBadEffect");
        animBadEffect->setMix("bad", "bad", 1.0f);
        animBadEffect->addAnimation(0, "bad", false);
        m_pUILayer->addChild(animBadEffect);
        animBadEffect->setZOrder(3);
        animBadEffect->setPosition(Vec2(pos.x + 5, pos.y - 10));
    }
    else
    {
        if(m_pUILayer->getChildByName("animGoodEffect"))m_pUILayer->removeChildByName("animGoodEffect");
        auto animGoodEffect = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimGood]->getSkeleton()->data);
        animGoodEffect->setName("animGoodEffect");
        animGoodEffect->setScale(0.5f);
        animGoodEffect->setMix("good", "good", 1.0f);
        animGoodEffect->addAnimation(0, "good", false);
        m_pUILayer->addChild(animGoodEffect);
        animGoodEffect->setZOrder(3);
        animGoodEffect->setPosition(pos);
    }

	m_pUILayer->addChild(bmFont);

	bmFont->setOpacity(0);
	bmFont->runAction(Sequence::create(
		FadeTo::create(1.0f, 255),
		DelayTime::create(3.0f),
		FadeTo::create(1.0f, 0),
		CallFunc::create(CC_CALLBACK_0(CapsaSusunScene::onDeleteNode, this, bmFont)),
		nullptr));
}

void CapsaSusunScene::showItemsRoom()
{
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_startGameData->m_bPlaying)
    {
        showKickUser(true);
    }
    else
    {
        showKickUser(false);
    }

    if(GlobalVariable::m_pUser->m_bHost)
    {
        GlobalVariable::m_pUserInfo->visibleHost(true);
    }
    else
    {
        GlobalVariable::m_pUserInfo->visibleHost(false);
    }
    showHostUser();
}

void CapsaSusunScene::showHostUser()
{
    for(int i= 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        for(int j = 0; j < m_vUserInfoOthers->size(); j++)
        {
            if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId == m_vUserInfoOthers->at(j)->m_dUserId)
            {
                m_vUserInfoOthers->at(j)->setVisibleHost(GlobalVariable::m_vPlayersSorted->at(i)->m_bHost);
            }
        }
    }
}

void CapsaSusunScene::showKickUser(bool bShow)
{
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleKickBtn(bShow);
    }
}