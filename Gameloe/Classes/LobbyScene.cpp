//
//  LobbyScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "LobbyScene.h"
#include "ChooseGameScene.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "ResourceManager.h"
#include "GlobalVariable.h"
#include "ImageLoader.h"
#include "SFSConnection.h"
#include "SceneManager.h"
#include "AlertPopup.h"
#include "LobbyTableView.h"
#include "DailyBonusPopup.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

//*******************************
// start pragma init Scene
//*******************************
void LobbyScene::onEnter()
{
	BaseScene::onEnter();
	schedule(schedule_selector(LobbyScene::update));
	//AudioManager::getInstance()->playBackgroundMusic(kSoundMusicTitle, true);
    BaseScene::initUI(kSceneLobbyGameJsonFile);
	if (GlobalVariable::m_pUserInfo->getParent()) GlobalVariable::m_pUserInfo->removeFromParent();
	m_pUILayer->addChild(GlobalVariable::m_pUserInfo);
    GlobalVariable::m_pUserInfo->setPosition(Vec2(-20, 525));
    GlobalVariable::m_pUserInfo->fillDataUserInfo();
    GlobalVariable::m_pUserInfo->visibleHost(false);

	m_pPanelRooms = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlRooms"));
	m_pPointView = static_cast<ImageView*>(Helper::seekWidgetByName(m_pPanelRooms, "iconPoint"));
    m_ivGame = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgGame"));
    m_ivGameName = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLogoGame"));
    if(GlobalVariable::m_iCurrentGame == 0)
    {
        m_ivGame->loadTexture("banting_tap.png");
        m_ivGameName->loadTexture("Banting.png");
    }
    else if(GlobalVariable::m_iCurrentGame == 1)
    {
        m_ivGame->loadTexture("susun_tap.png");
        m_ivGameName->loadTexture("Susun.png");
    }
    else
    {
        m_ivGame->loadTexture("banting_tap.png");
        m_ivGameName->loadTexture("Banting.png");
    }

	m_pPanelTitleListRoom = static_cast<Layout*>(Helper::seekWidgetByName(m_pPanelRooms, "pnlTitleListRoom"));
	m_pPanelTitleStakes = static_cast<Layout*>(Helper::seekWidgetByName(m_pPanelRooms, "pnlTitleStakes"));
	m_pPanelTitlePlayer = static_cast<Layout*>(Helper::seekWidgetByName(m_pPanelRooms, "pnlTitlePlayer"));
	txtRoomNumber = static_cast<TextField*>(m_pPanelTitleListRoom->getChildByName("txtRoomNumber"));
	txtRoomName = static_cast<TextField*>(m_pPanelTitleListRoom->getChildByName("txtRoomName"));
	txtRoomBet = static_cast<TextField*>(m_pPanelTitleStakes->getChildByName("txtRoomBet"));
	txtRoomPlayer = static_cast<TextField*>(m_pPanelTitlePlayer->getChildByName("txtRoomPlayer"));

	if (GlobalVariable::m_pSettingCom->getParent()) GlobalVariable::m_pSettingCom->removeFromParent();
	m_pUILayer->addChild(GlobalVariable::m_pSettingCom);
    GlobalVariable::m_pSettingCom->setVisiblePanelIAP(false);
	GlobalVariable::m_pSettingCom->setPosition(Vec2(0, 30));
	GlobalVariable::m_pSettingCom->setVisibleItems(true, true, false, false, true, true, true, true);

	//point transitions
	auto delay  = DelayTime::create(0.15f);
	auto moveUp = MoveBy::create(0.3, Vec2(0, -5));
	auto moveReverse = moveUp->reverse();
	auto seq1 = Sequence::create(moveUp, delay->clone(), moveReverse, delay->clone(), nullptr);
	m_pPointView->runAction(RepeatForever::create(seq1));

	addEventlistener();

	relayout();
    setTextLanguage();
    checkAlert();
    setPointPos();

    LobbyDataSource* dataSource = new LobbyDataSource();
	LobbyListDelegate* listDelegate = new LobbyListDelegate();
	TableView* tableView = TableView::create(dataSource, Size(750.0f, 380.0f));
	tableView->setPositionY(50.0f);
	tableView->setPositionX(0.0f);
	tableView->setDirection(cocos2d::extension::ScrollView::Direction::VERTICAL);
	tableView->setVerticalFillOrder(TableView::VerticalFillOrder::TOP_DOWN);
	tableView->setDelegate(listDelegate);
	ImageView* imgListRoomBG = static_cast<ImageView*>(Helper::seekWidgetByName(m_pPanelRooms, "imgListRoomBG"));
	imgListRoomBG->removeAllChildren();
	imgListRoomBG->addChild(tableView);
	tableView->reloadData();

    auto girl = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimGirl]->getSkeleton()->data);
    girl->setMix("girl", "girl", 1.0f);
    girl->addAnimation(0, "girl", true);
    girl->setPosition(Vec2(-200, -50));
    m_pBGLayer->addChild(girl);
    girl->setOpacity(0);
    girl->setScale(0.9f);
    int posX = 0;
    Size deviceSize = Director::getInstance()->getWinSize();
    if(deviceSize.width / (float) deviceSize.height < 1.5f)
    {
        posX = 800;
    }
    else
    {
        posX = 1000;
    }
    auto moveright1  = MoveTo::create(0.3f, Vec2(posX, girl->getPositionY()));
    auto fadeto = FadeTo::create(0.5f, 255);
    girl->runAction(Sequence::create(Spawn::create(moveright1, fadeto, nullptr), nullptr));
    GlobalVariable::m_bBackToLobby = false;
}

void LobbyScene::checkAlert()
{
    closeLastPopup();
    if(GlobalVariable::m_bWasKicked)
    {
        GlobalVariable::m_bWasKicked = false;
        string msg = ResourceManager::getInstance()->getTextByName(kTEXT_MSG_YOU_WAS_KICKED).c_str();
        AlertPopup* alp = AlertPopup::create(msg);
        openPopup(alp);
    }
    if(GlobalVariable::m_bWasKickedIdle)
    {
        GlobalVariable::m_bWasKickedIdle = false;
        string msg = ResourceManager::getInstance()->getTextByName(kTEXT_MSG_YOU_WAS_KICKED_IDLE).c_str();
        AlertPopup* alp = AlertPopup::create(msg);
        openPopup(alp);
    }
    if(GlobalVariable::m_bWasDailyBonus)
    {
        GlobalVariable::m_bWasDailyBonus = false;
        CMDDailyBonusData* data = GlobalVariable::m_cmdDailyBonusData;
        DailyBonusPopup* popup  = DailyBonusPopup::create(data);
        openPopup(popup);
    }
    if(GlobalVariable::m_bWasBonusStarup)
    {
        GlobalVariable::m_bWasBonusStarup = false;
        string msg = GlobalVariable::m_sMessage;
        AlertPopup* alp = AlertPopup::create(msg);
        openPopup(alp);
    }

}

void LobbyScene::onReminds(Ref* obj)
{
    AlertPopup* alp = new AlertPopup("message");
    openPopup(alp);
}

void LobbyScene::onWasKicked(Ref* obj)
{
    AlertPopup* alp = new AlertPopup("You was kicked out room");
    openPopup(alp);
}

void LobbyScene::onNetworkCheckReconnect(Ref* obj)
{
    hideLoading();
    CMDReconnectData* cmdReconnectData = (CMDReconnectData*)obj;
    GlobalVariable::m_sTableName = cmdReconnectData->m_sTableName;
    GlobalVariable::m_iCurrentTable = atoi(GlobalVariable::m_sTableName.substr(3, GlobalVariable::m_sTableName.length() - 3).c_str());
    string str = cmdReconnectData->m_sMsg;
    CCLOG("Message: %s", cmdReconnectData->m_sMsg.c_str());
	string key = str.substr(0, str.find_first_of(","));
	str.erase(0, key.size() + 1);

	vector<string>* params = new vector<string>();
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

	string alertString = GlobalVariable::msgConst->getMsg(key.c_str(), params);
    ConfirmPopup* cfm = ConfirmPopup::create(alertString);
    openPopup(cfm);
    cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, CC_CALLBACK_1(LobbyScene::confirmReconnect, this));
}

void LobbyScene::confirmReconnect(EventCustom* event)
{
    SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sTableName);
}

void LobbyScene::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void LobbyScene::setTextLanguage()
{
	txtZone1->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ZONE_TS).c_str());
	txtZone2->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ZONE_DG).c_str());
	txtZone3->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ZONE_VIP).c_str());
	txtZone4->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ZONE_TOUR).c_str());
	//txtMinigames->setText(ResourceManager::getInstance()->getTextByName(kTEXT_BANTING_MINI_GAME).c_str());

	txtRoomNumber->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ROOM_NO_TITLE).c_str());
	txtRoomName->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ROOM_TITLE_TITLE).c_str());
	txtRoomBet->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ROOM_BET_TITLE).c_str());
	txtRoomPlayer->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ROOM_PLAYER_TITLE).c_str());

    ImageView* imgPlayNow   = static_cast<ImageView*>(m_p_bPlay->getChildByName("imgPlayNow"));
    ImageView* imgCreateRoom = static_cast<ImageView*>(m_p_bCreate->getChildByName("imgCreateRoom"));
    if(GlobalVariable::m_iCurrentLanguage == LANG_INDONESIA)
    {
        imgPlayNow->loadTexture("langsung.png");
        imgCreateRoom->loadTexture("membuat.png");
    }
    else if(GlobalVariable::m_iCurrentLanguage == LANG_ENGLISH)
    {
        imgPlayNow->loadTexture("playnow.png");
        imgCreateRoom->loadTexture("Createroom.png");
    }
}

void LobbyScene::onEnterTransitionDidFinish()
{

}

void LobbyScene::relayout()
{
	Size deviceSize = Director::getInstance()->getWinSize();
    m_p_bPlay->setPositionX(100 + (deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
    m_p_bCreate->setPositionX(100 + (deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
    m_ivGame->setPositionX(100 +(deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
	m_pPanelRooms->setPosition(Vec2(deviceSize.width - m_pPanelRooms->getContentSize().width - (deviceSize.width - GlobalVariable::m_iGameWidth) / 2, m_pPanelRooms->getPosition().y));
    if(deviceSize.width / (float) deviceSize.height < 1.5f)
    {
        m_pPanelRooms->setScale(0.85f);
        m_p_bPlay->setPositionX(120 + (deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
        m_p_bCreate->setPositionX(120 + (deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
        m_ivGame->setPositionX(120 +(deviceSize.width - GlobalVariable::m_iGameWidth) / 4);
        m_ivGame->setScale(0.85f);
        m_pPanelRooms->setPosition(Vec2(m_p_bPlay->getContentSize().width + 10, 30));
    }
	GlobalVariable::m_pSettingCom->setPosition(Vec2(deviceSize.width - 400, 560));
    for(int i = 1; i <= 4; i++)
    {

        std::string str = ccsf("txtBtnRoom%d", i);
        TextField* txtZoneTab = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, str));
        //if(i == 5)
        //{
        //txtZoneTab->setText(ResourceManager::getInstance()->getTextByName(kTEXT_BANTING_MINI_GAME).c_str());
        //}
        if( i == 4)
        {
            txtZoneTab->setString(ResourceManager::getInstance()->getTextByName(kTEXT_ZONE_TOUR).c_str());
        }
        else
        {
            string str1 = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(i)->m_sName;
            txtZoneTab->setString(ResourceManager::getInstance()->getTextByName(str1.c_str()));
        }
    }
    // Animation
	GlobalVariable::m_pSettingCom->m_pLayout->setOpacity(0);
	GlobalVariable::m_pSettingCom->m_pLayout->runAction(Spawn::create(FadeTo::create(0.3f, 255), nullptr));
	GlobalVariable::m_pUserInfo->m_pLayout->setOpacity(0);
	GlobalVariable::m_pUserInfo->m_pLayout->runAction(Spawn::create(FadeTo::create(0.3f, 255), nullptr));

	m_ivGameName->setOpacity(0);
	m_ivGameName->runAction(FadeTo::create(0.2f, 255));

    m_p_bPlay->stopAllActions();
    m_p_bPlay->setCascadeOpacityEnabled(true);
	m_p_bPlay->setOpacity(0);
	m_p_bPlay->setPositionY(m_p_bPlay->getPositionY() + 20.0f);
	m_p_bPlay->runAction(Sequence::create(DelayTime::create(0.2f), Spawn::create(MoveBy::create(0.3f, Vec2(0.0f, -20.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));

    m_p_bCreate->stopAllActions();
    m_p_bCreate->setCascadeOpacityEnabled(true);
	m_p_bCreate->setOpacity(0);
	m_p_bCreate->setPositionY(m_p_bCreate->getPositionY() + 20.0f);
	m_p_bCreate->runAction(Sequence::create(DelayTime::create(0.3f), Spawn::create(MoveBy::create(0.3f, Vec2(0.0f, -20.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));

    m_ivGame->stopAllActions();
    m_ivGame->setCascadeOpacityEnabled(true);
	m_ivGame->setOpacity(0);
	m_ivGame->setPositionY(160);
	m_ivGame->runAction(Sequence::create(DelayTime::create(0.4f), Spawn::create(MoveBy::create(0.3f, Vec2(0.0f, -20.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));
}

// stayed for scroll-bar of list rooms
void LobbyScene::update(float dt)
{
	BaseScene::update(dt);
}

void LobbyScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
	if (SceneManager::getInstance()->m_iCurrentScene == kSceneLobby  &&
        keyCode == EventKeyboard::KeyCode::KEY_BACK)
    {
        event->stopPropagation();
        if(m_vPopups != nullptr && m_vPopups->size() > 0)
        {
            closeAllPopups();
            return;
        }
		backScene();
	}
}

void LobbyScene::addEventlistener()
{
	// Add eventlistener
	m_p_bBackHome = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnHome"));
	m_p_bBackHome->addTouchEventListener(CC_CALLBACK_2(LobbyScene::onBtnBackHomeClick, this));

	m_p_bPlay = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnPlay"));
    m_p_bPlay->addTouchEventListener(CC_CALLBACK_2(LobbyScene::onBtnPlayClick, this));

	m_p_bCreate = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCreate"));
    m_p_bCreate->addTouchEventListener(CC_CALLBACK_2(LobbyScene::onBtnCreateClick, this));

    for(int i = 1; i <= 4; i++)
    {
        std::string str = ccsf("btnZone%d", i);
        m_aBtZones[i - 1] = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, str));
        if(i!=5) m_aBtZones[i - 1]->addTouchEventListener(CC_CALLBACK_2(LobbyScene::getZone, this));
		if (i == 1) txtZone1 = static_cast<TextField*>(Helper::seekWidgetByName(m_aBtZones[i - 1], "txtBtnRoom1"));
		else if (i == 2) txtZone2 = static_cast<TextField*>(Helper::seekWidgetByName(m_aBtZones[i - 1], "txtBtnRoom2"));
		else if (i == 3) txtZone3 = static_cast<TextField*>(Helper::seekWidgetByName(m_aBtZones[i - 1], "txtBtnRoom3"));
		else if (i == 4) txtZone4 = static_cast<TextField*>(Helper::seekWidgetByName(m_aBtZones[i - 1], "txtBtnRoom4"));
		else if (i == 5) txtMinigames = static_cast<TextField*>(Helper::seekWidgetByName(m_aBtZones[i - 1], "txtBtnRoom5"));
    }

	m_listenerKeyboard->onKeyReleased = CC_CALLBACK_2(LobbyScene::onKeyReleased, this);
	getEventDispatcher()->addEventListenerWithFixedPriority(m_listenerKeyboard, 1);

    //network event
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onRoomJoinError), EVENT_NETWORK_ROOM_JOIN_ERROR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onRoomJoining), EVENT_NETWORK_ROOM_JOINING, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onInvition), C_COMMAND_INVITE, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onReminds), C_COMMAND_REMINDS, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onReminds), C_COMMAND_REMINDS, nullptr);
}

void LobbyScene::onInvition(Ref* obj)
{
    if(GlobalVariable::m_bInviteOn)
    {
        CMDInvitationData* cmdInvitionData = (CMDInvitationData*)obj;
        GlobalVariable::m_sTableName = cmdInvitionData->m_sTableName;
        GlobalVariable::m_iCurrentTable = atoi(GlobalVariable::m_sTableName.substr(3, GlobalVariable::m_sTableName.length() - 3).c_str());
        const char* sFormat = "%s %s  table: %d, bet: %ld gold %s";
        string sMsg = ccsf(sFormat,
                    cmdInvitionData->m_sName.c_str(),
                    ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITATION_1).c_str(),
                    GlobalVariable::m_iCurrentTable,
                    cmdInvitionData->m_iCuoc,
                    ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITATION_2).c_str());
        ConfirmPopup* cfm = ConfirmPopup::create(sMsg);
        openPopup(cfm);
        cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, CC_CALLBACK_1(LobbyScene::confirmInvite, this));
    }
}

void LobbyScene::confirmInvite(EventCustom* event)
{
    SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sTableName);
}

void LobbyScene::onRoomJoining(Ref* obj)
{
    showLoading();
}

void LobbyScene::onRoomJoinError(Ref* obj)
{
    openPopup(new AlertPopup("Join Room Fail!"));
}

void LobbyScene::setPointPos()
{
    m_pPointView->setPositionX(m_aBtZones[GlobalVariable::m_iCurrentZone - 1]->getPositionX());
    m_pPointView->setPositionY(110);
}

void LobbyScene::onBtnBackHomeClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    backScene();
}

void LobbyScene::onBtnCreateClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->createRoom();
}

void LobbyScene::backScene()
{
    GlobalVariable::m_bBackToLobby = true;
	GlobalVariable::m_iCurrentGame = 0;
	GlobalVariable::m_iCurrentZone = 0;
	SFSConnection::getInstance()->disconnectToServer();
}

void LobbyScene::onBtnPlayClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->playNow();
}

void LobbyScene::getZone(Ref *pSender, Widget::TouchEventType type)
{
    GlobalVariable::m_bBackToLobby = false;
    Button* btnZone = dynamic_cast<Button*>(pSender);
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    for(int i = 0; i < 3; i++)
    {
        if(btnZone == m_aBtZones[i])
        {
            GlobalVariable::m_iCurrentZone = i + 1;
            setPointPos();
            SFSConnection::getInstance()->disconnectToServer();
        }
    }
    if(btnZone == m_aBtZones[3])
    {
        showToast(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_UNDER_CONSTRUCTION), 2.0f);
    }
}

/* end pragma init Scene */

//*******************************
// start pragma exit Scene
//*******************************
void LobbyScene::onExit()
{
	BaseScene::onExit();
	NotificationCenter::getInstance()->removeObserver(this, EVENT_LANGUAGE_CHANGE);
	if (GlobalVariable::m_pAdBar->getParent() && GlobalVariable::m_pAdBar->getParent() == this) GlobalVariable::m_pAdBar->removeFromParent();
	if (GlobalVariable::m_pUserInfo->getParent() && GlobalVariable::m_pUserInfo->getParent() == m_pUILayer) GlobalVariable::m_pUserInfo->removeFromParent();
	if (GlobalVariable::m_pSettingCom->getParent() && GlobalVariable::m_pSettingCom->getParent() == m_pUILayer) GlobalVariable::m_pSettingCom->removeFromParent();
    unschedule(schedule_selector(LobbyScene::update));
}

/* end pragma exit Scene */

LobbyScene::LobbyScene()
{
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onNetworkCheckReconnect), C_CHECK_RECONNECT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LobbyScene::onWasKicked), C_COMMAND_KICK_USER, nullptr);
}

LobbyScene::~LobbyScene()
{
    
}