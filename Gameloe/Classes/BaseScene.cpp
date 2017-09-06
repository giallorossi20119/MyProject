//
//  BaseScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "BaseScene.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "EventConst.h"
#include "AlertPopup.h"
#include "ZoneData.h"
#include "SceneManager.h"
#include "ZoneData.h"
#include "CMDErrorData.h"
#include "RankPopup.h"
#include "PlayerInfoPopup.h"
#include "GlobalVariable.h"
#include "DailyBonusPopup.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_WP8
#else
#include "SFSConnection.h"
#endif

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
extern void saveScreenShot(std::string imgSSPath);
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID

#endif



BaseScene::BaseScene()
{
    m_pBGLayer              = nullptr;
	m_pLoadingLayer			= nullptr;
    m_pUILayer				= nullptr;
    m_pLayout				= nullptr;
	m_pListenerLoadingLayer = nullptr;
	m_pToast			    = nullptr;
    m_fTimeLeft = 0.0f;

    m_pUILayer = Layer::create();
    m_pUILayer->retain();
    m_pUILayer->scheduleUpdate();
    m_pBGLayer = Layer::create();
    m_pBGLayer->retain();
	m_pPopupLayer = Layer::create();
    m_pPopupLayer->retain();
	m_pLoadingLayer = Layer::create();
    m_pLoadingLayer->retain();

    m_listenerKeyboard = EventListenerKeyboard::create();
    m_listenerKeyboard->retain();

	m_vPopups = new vector<BasePopup*>();
}

BaseScene::~BaseScene()
{

}
void BaseScene::exitScene()
{
#if (CC_TARGET_PLATFORM == CC_PLATFORM_WP8) || (CC_TARGET_PLATFORM == CC_PLATFORM_WINRT)
	MessageBox("You pressed the close button. Windows Store Apps do not implement a close button.","Alert");
    return;
#endif

    Director::getInstance()->end();

#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
    exit(0);
#endif
}

/*************************************************************/
/* @author longnh								  				 */
/* Start group functions onEnter/onExit scene				 */
/*************************************************************/
void BaseScene::onEnter()
{
    Scene::onEnter();
    //AudioManager::getInstance()->stopSoundBackground();
    addChild(m_pBGLayer);
	addChild(m_pUILayer);
    addChild(m_pPopupLayer);
	addChild(m_pLoadingLayer);
    Size deviceSize = Director::getInstance()->getWinSize();

    relayout();
    schedule(schedule_selector(BaseScene::pingCount), 1.0f);
    //add notification event
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkConnection), EVENT_NETWORK_CONNECTION, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkConnecting), EVENT_NETWORK_CONNECTING, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkConnectionLost), EVENT_NETWORK_CONNECTION_LOST, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkNotAvailble), EVENT_NETWORK_NOT_AVAILBLE, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkLoginError), EVENT_NETWORK_lOGIN_ERROR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkLoginSuccessful), EVENT_NETWORK_LOGIN_SUCCESSFUL, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkResponse), EVENT_NETWORK_RESPONSE, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkDisconnect), EVENT_NETWORK_DISCONNECT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkLogging), EVENT_NETWORK_LOGGING, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkUserInfo), EVENT_NETWORK_USER_INFO, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkClientLobbyRecieved), C_CLIENT_LOBBY, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkSignInFail), EVENT_NETWORK_SIGNIN_FAIL, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onNetworkSignUpFail), EVENT_NETWORK_SIGNUP_FAIL, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::extensionResponseError), C_CLIENT_ERROR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onResponseClientPositionData), C_CLIENT_POSITION_DATA, nullptr);
	NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::recieveRankData), EVENT_SHOW_RANK_POPUP, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onSSResponseUserData), SS_R_USER_DATA, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::showAlert), EVENT_SHOW_ALERT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::showPlayerInfo), C_CLIENT_PLAYER_INFO, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onResponseDailyBonus), C_CLIENT_BONUS_DAILY, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onResponseBonusTime), C_CLIENT_BONUS_TIME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onResponseNameUpdated), EVENT_NAME_UPDATED, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(BaseScene::onResponseAccountUpdated), EVENT_ACCOUNT_UPDATED, nullptr);
}

void BaseScene::showPlayerInfo(Ref* obj)
{
    PlayerData* player = (PlayerData*)obj;
    PlayerInfoPopup* pip = new PlayerInfoPopup();
	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->openPopup(pip);
    pip->fillData(player);
}

void BaseScene::onResponseAccountUpdated(Ref* obj)
{
    showToast("Your account has been updated", 3.0f);
    GlobalVariable::m_pUserInfo->updateAccount();
}

void BaseScene::onResponseNameUpdated(Ref* obj)
{
	__String* name = static_cast<__String*>(obj);
    showToast(ccsf("Your name has been updated: %s", name->getCString()), 3.0f);
    GlobalVariable::m_pUser->m_sName = name->getCString();
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        if(GlobalVariable::m_pUser->m_dId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
        {
            GlobalVariable::m_vPlayersSorted->at(i)->m_sName = name->getCString();
        }
    }
    for(int i = 0; i < GlobalVariable::m_vPlayers->size(); i++)
    {
        if(GlobalVariable::m_pUser->m_dId == GlobalVariable::m_vPlayers->at(i)->m_dId)
        {
            GlobalVariable::m_vPlayers->at(i)->m_sName = name->getCString();
        }
    }
    GlobalVariable::m_pUserInfo->updateName();
}

void BaseScene::onSSResponseUserData(Ref* obj)
{
    SceneManager::getInstance()->switchScene(kSceneInGame2, obj);
}

void BaseScene::recieveRankData(Ref* obj)
{
	Size deviceSize = Director::getInstance()->getWinSize();

	RankPopup* rP = new RankPopup();
	openPopup(rP);
	rP->recieveRankData((CMD2Rank*)obj);
	hideLoading();
}
void BaseScene::onExit()
{
	Scene::onExit();
    NotificationCenter::getInstance()->removeAllObservers(this);
    getEventDispatcher()->removeEventListener(m_listenerKeyboard);
    m_listenerKeyboard->release();
	hideToast();
	hideLoading();
	closeAllPopups();

    m_vPopups->clear();
    CC_SAFE_DELETE(m_vPopups);

    m_pBGLayer->removeFromParent();
    m_pBGLayer->release();
	m_pUILayer->removeFromParent();
    m_pUILayer->release();
	m_pPopupLayer->removeFromParent();
    m_pPopupLayer->release();
	m_pLoadingLayer->removeFromParent();

    //m_pLayout->removeAllChildrenWithCleanup(true);
	cocostudio::GUIReader::destroyInstance();
	cocostudio::ActionManagerEx::destroyInstance();
}


void BaseScene::onResponseDailyBonus(Ref* obj)
{
    CMDDailyBonusData* data = (CMDDailyBonusData*)obj;
    DailyBonusPopup* bnp = DailyBonusPopup::create(data);
    openPopup(bnp);
}

void BaseScene::onResponseBonusTime(Ref* obj)
{
    return;
    CMDDailyBonusData* data = new CMDDailyBonusData();
    data->m_iBonus = 10000;
    data->m_sDay   = 1;
    auto alp = AlertPopup::create("adsfhkasdjf");
    DailyBonusPopup* popup = DailyBonusPopup::create(data);
    //CMDQuestBonusData* data = (CMDQuestBonusData*)obj;
    openPopup(alp);
}

void BaseScene::onNetworkSignInFail(Ref* obj)
{
	hideLoading();
	cocos2d::String* msr = static_cast<cocos2d::String*>(obj);
	openPopup(new AlertPopup(msr->getCString()));
}

void BaseScene::onNetworkSignUpFail(Ref* obj)
{
	hideLoading();
	cocos2d::String* msr = static_cast<cocos2d::String*>(obj);
	openPopup(new AlertPopup(msr->getCString()));
}

void BaseScene::onNetworkLogging(Ref* obj)
{
    showLoading();
}

void BaseScene::onNetworkLoginError(Ref* obj)
{
	CMDDataString* dat = (CMDDataString*)obj;

	rapidjson::Document document;
	document.Parse<0>(dat->str.c_str());

	string key = "";

	if (document.HasMember("msg"))
	{
		key = document["msg"].GetString();
	}

	vector<string>* params = new vector<string>();
	int key2 = 0;
	if (document.HasMember("ec"))
	{
		key2 = document["ec"].GetInt();
		CCLOG("key2-%d",key2);
	}

	string alertString = GlobalVariable::msgConst->getMsg(key.c_str(), params);

	openPopup(new AlertPopup(alertString));
	hideLoading();
}

void BaseScene::onNetworkLoginSuccessful(Ref* obj)
{
    //SceneManager::getInstance()->switchScene(kSceneChooseGame);
}

void BaseScene::onNetworkClientLobbyRecieved(Ref* obj)
{
    CCLOG("onNetworkClientLobbyRecieved1");
    SceneManager::getInstance()->switchScene(kSceneLobby);
    CCLOG("onNetworkClientLobbyRecieved2");
}

void BaseScene::onResponseClientPositionData(Ref* obj)
{
    SceneManager::getInstance()->switchScene(kSceneInGame1);
}

void BaseScene::onNetworkConnection(Ref* obj)
{
    //hideLoading();
}

void BaseScene::extensionResponseError(Ref* obj)
{
    CMDErrorData* cmdErrorData = (CMDErrorData*)obj;
	CCLOG("extensionResponseError %s", cmdErrorData->m_sMessage.c_str());
	string key = "";
	vector<string>* params = new vector<string>();
    GlobalVariable::msgConst->getMsgParams(cmdErrorData, key, params);
	string alertString = GlobalVariable::msgConst->getMsg(key.c_str(), params);
    params->clear();
    CC_SAFE_DELETE(params);
    CCLOG("Error String: %s", alertString.c_str());
    GlobalVariable::m_sMessage = alertString;
    if(strcmp(key.c_str(), "45") == 0)
    {
        GlobalVariable::m_bWasBonusStarup = true;
    }
	if(strcmp(key.c_str(), "201") == 0)
    {
        GlobalVariable::m_bWasKicked = true;
    }
    if(strcmp(key.c_str(), "208") != 0)
    {
        showToast(alertString, 3.0f);
        hideLoading();
    }
}

void BaseScene::onNetworkConnecting(Ref* obj)
{
    showLoading();
}

void BaseScene::onNetworkDisconnect(Ref* obj)
{
	hideLoading();
}

void BaseScene::onNetworkResponse(Ref* obj)
{
}

void BaseScene::onNetworkUserInfo(Ref* obj)
{
    if(SceneManager::getInstance()->m_iCurrentScene == kSceneLogin
       || (SceneManager::getInstance()->m_iCurrentScene == kSceneLobby && GlobalVariable::m_bBackToLobby))
    {
        SceneManager::getInstance()->switchScene(kSceneChooseGame);
    }
}

void BaseScene::onNetworkNotAvailble(Ref* obj)
{
	hideLoading();
    closeLastPopup();
    ConfirmPopup* cfm = ConfirmPopup::create("Please check your network connection, and try again!");
    openPopup(cfm);
    cfm->changeToAlert();
    auto func = [](EventCustom* event)
    {
        exit(0);
    };
    cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, func);
}

void BaseScene::onNetworkConnectionLost(Ref* obj)
{
	hideLoading();
    ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
    switch(SceneManager::getInstance()->m_iCurrentScene)
    {
        case kSceneChooseGame:
        {
            if(GlobalVariable::m_bBackToChooseGame)
            {
                GlobalVariable::m_bBackToChooseGame = false;
                SceneManager::getInstance()->switchScene(kSceneLogin);
            }
            else
            {
                SFSConnection::getInstance()->initServer();
                SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
            }
            break;
        }
        case kSceneLobby:
        {
            SFSConnection::getInstance()->initServer();
            SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
            break;
        }
        case kSceneInGame1:
        case kSceneInGame2:
        {
            closeLastPopup();
            ConfirmPopup* cfm = ConfirmPopup::create(ResourceManager::getInstance()->getTextByName(kTEXT_ALERT_CONNECTION_LOST));
            openPopup(cfm);
            cfm->changeToAlert();
            auto func = [](EventCustom* event)
            {
                SFSConnection::getInstance()->initServer();
                GlobalVariable::m_iCurrentGame = 0;
                GlobalVariable::m_iCurrentZone = 0;
                SceneManager::getInstance()->switchScene(kSceneLogin);
            };
            cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, func);
        }
            break;
    }
}

void BaseScene::initUI(std::string p_sSceneJsonFile)
{
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(p_sSceneJsonFile.c_str()));
    m_pUILayer->addChild(m_pLayout);
}

void BaseScene::relayout()
{
    Size deviceSize = Director::getInstance()->getWinSize();
    Sprite* bg = Sprite::create("BG.png");
    bg->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
    m_pBGLayer->addChild(bg);
}

/*************************************************************/
/* @author longnh						  				 */
/* Listening KeyBack event to switch scene or exit game 	 */
/*************************************************************/
void BaseScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
}

/*************************************************************/
/* @author longnh								  				 */
/* Show/Hide loading overlay which appear 					 */
/* when waiting for loading data. It's also disable 		 */
/* all user interactives 									 */
/*************************************************************/
void BaseScene::showLoading()
{
    if(SceneManager::getInstance()->m_iCurrentScene == kSceneLobby ||
       SceneManager::getInstance()->m_iCurrentScene == kSceneInGame1 ||
       SceneManager::getInstance()->m_iCurrentScene == kSceneInGame2 ||
       SceneManager::getInstance()->m_iCurrentScene == kSceneChooseGame)
        return;
	// Sanity! Cocos2d do not have function to check whether parent
	// contains one child node so we've to remove and clean all children
	// in loading layer before adding overlay
	m_pLoadingLayer->removeAllChildrenWithCleanup(true);
	_eventDispatcher->removeEventListener(m_pListenerLoadingLayer);

	// Add overlay
    LayerColor* overlay = LayerColor::create(Color4B(0, 0, 0, 170));
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLoadingLayer->addChild(overlay);
    overlay->setContentSize(Size(deviceSize.width, deviceSize.height));

	// Add loading symbol
	Sprite* loadingSymbol = Sprite::create("loadingicon.png");
	loadingSymbol->setAnchorPoint(Vec2(0.5f, 0.5f));
	loadingSymbol->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
	RotateBy* rotateAction = RotateBy::create(0.05f, -30.0f);
	loadingSymbol->runAction(RepeatForever::create(rotateAction));
	m_pLoadingLayer->addChild(loadingSymbol);

	// Create listener to prevent all user interactives while loading
	if (!m_pListenerLoadingLayer)
	{
		m_pListenerLoadingLayer = EventListenerTouchOneByOne::create();
		m_pListenerLoadingLayer->retain();
		m_pListenerLoadingLayer->setEnabled(true);
		m_pListenerLoadingLayer->setSwallowTouches(true);
		m_pListenerLoadingLayer->onTouchBegan = [](Touch* touch, Event* event)
		{
			return true;
		};
	}
	_eventDispatcher->addEventListenerWithSceneGraphPriority(m_pListenerLoadingLayer, m_pLoadingLayer);
}

void BaseScene::hideLoading()
{
	m_pLoadingLayer->removeAllChildrenWithCleanup(true);
	_eventDispatcher->removeEventListener(m_pListenerLoadingLayer);
}
/* END PRAGMA SHOW/HIDE LOADING FUNCTIONS SCENE			     */


/*************************************************************/
/* @author longnh								  				 */
/* Show/Hide toast											 */
/*************************************************************/
void BaseScene::showToast(string sMessenger, float fTime)
{
	// Ensure we have only one toast at once time
	hideToast();

	m_pToast = new Toast(sMessenger);
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pToast->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 6));

	//schedule(schedule_selector(BaseScene::autoRemoveToast), fTime);
	m_pUILayer->addChild(m_pToast);

	m_pToast->setScale(0.2f);
	ScaleTo* scaleAct = ScaleTo::create(0.1f, 1.0f);
	EaseIn* easeAct = EaseIn::create(scaleAct, 0.2f);
    auto delay = DelayTime::create(fTime);
    auto actRemove = CallFunc::create( CC_CALLBACK_0(BaseScene::hideToast, this));
    auto seq = Sequence::create(easeAct, delay, actRemove, nullptr);
	m_pToast->runAction(seq);
}


void BaseScene::pingCount(float dt)
{
    GlobalVariable::m_iPingCount++;
    //CCLOG("ping count %d", GlobalVariable::m_iPingCount);
    onNetworkLag();
}

void BaseScene::onNetworkLag()
{
    std::string msg = "";
    if(GlobalVariable::m_iPingCount == 20)
    {
        if(SceneManager::getInstance()->m_iCurrentScene != kSceneLogin && SceneManager::getInstance()->m_iCurrentScene != kSceneLoading)
        {
            closeLastPopup();
            ConfirmPopup* cfm = ConfirmPopup::create(ResourceManager::getInstance()->getTextByName(kTEXT_ALERT_CONNECTION_LOST));
            openPopup(cfm);
            cfm->changeToAlert();
            auto func = [](EventCustom* event)
            {
                GlobalVariable::m_iCurrentGame = 0;
                GlobalVariable::m_iCurrentZone = 0;
                SFSConnection::getInstance()->initServer();
                SceneManager::getInstance()->switchScene(kSceneLogin);
            };
            cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, func);
        }
    }
}

void BaseScene::idleGame()
{
    if(SceneManager::getInstance()->m_iCurrentScene == kSceneInGame1 || SceneManager::getInstance()->m_iCurrentScene == kSceneInGame2)
    {
        GlobalVariable::m_bWasKickedIdle = true;
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
}

void BaseScene::hideToast()
{
	if (m_pToast)
	{
		//unschedule(schedule_selector(BaseScene::autoRemoveToast));
		m_pToast->removeFromParentAndCleanup(true);
	}
}

void BaseScene::showAlert(Ref* obj)
{
	const char* str = (char*)obj;
    showToast(str, 3.0f);
}

void BaseScene::autoRemoveToast(float dt)
{
	unschedule(schedule_selector(BaseScene::autoRemoveToast));
	m_pToast->removeFromParentAndCleanup(true);
	m_pToast->release();
	m_pToast = nullptr;
}
/* END GROUP SHOW/HIDE TOAST								 */


/*************************************************************/
/* @author longnh								  				 */
/* Start functions handle popups							 */
/*************************************************************/
void BaseScene::openPopup(BasePopup* popup)
{
	popup->retain();
	m_vPopups->push_back(popup);
	m_pPopupLayer->addChild(popup);
	popup->onOpen();
}

void BaseScene::closePopup(BasePopup* popup)
{
	int noPopup = m_vPopups->size();
	BasePopup* targetPopup;
	int i;

	// Passed popup was opened
	for (i = 0; i < noPopup; i++)
	{
		targetPopup = m_vPopups->at(i);
		if (targetPopup == popup)
		{
			popup->onClose();
			m_pPopupLayer->removeChild(popup);
			m_vPopups->erase(m_vPopups->begin() + i);
			return;
		}
	}
}

void BaseScene::closeLastPopup()
{
	int noPopup = m_vPopups->size();

	if (0 == noPopup) return;

	BasePopup* popup = m_vPopups->at(noPopup-1);
	popup->onClose();
	m_pPopupLayer->removeChild(popup);
	m_vPopups->pop_back();
}

void BaseScene::closeAllPopups()
{
	BasePopup* popup;
	int noPopup = m_vPopups->size();
	for (int i = noPopup - 1; i >= 0; i--)
	{
		popup = m_vPopups->at(i);
		popup->onClose();
		popup->release();
		m_vPopups->pop_back();
	}

	m_pPopupLayer->removeAllChildrenWithCleanup(true);
}
/* END GROUP FUNCTIONS HANDLING POPUPS						 */


/*************************************************************/
/* @author longnh												 */
/* Handle loop functions									 */
/*************************************************************/

void BaseScene::update(float delta)
{
    GlobalVariable::m_dLastSecond = GlobalVariable::m_dCurrentSecond;
    GlobalVariable::m_dCurrentSecond = TTutil::getCurrentSecond();
    if(GlobalVariable::m_dCurrentSecond - GlobalVariable::m_dLastSecond > 60000)
    {
        idleGame();
    }
	SFSConnection::getInstance()->updateEvent();
}
/* END HANDLE LOOP FUNCTIONS								 */

/*************************************************************/
/* @author longnh												 */
/* Capture screen functions									 */
/*************************************************************/
std::string imgSSPath = "";
void BaseScene::captureScreen()
{
	showLoading();
	time_t t = time(0);
    std::string ss;
    struct tm * now = localtime(&t);
    ss = ccsf("%d_%d_%d_%d_%d_%d", now->tm_year + 1900, now->tm_mon + 1, now->tm_mday, now->tm_hour, now->tm_min, now->tm_sec);
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
	std::string fileName = "";
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    std::string fileName = "/sdcard/gameloe/";
#endif
	fileName.append(ss);
	fileName.append(".png");
    imgSSPath = fileName;
	utils::captureScreen(CC_CALLBACK_2(BaseScene::onCapturedScreen, this), fileName);
}

void BaseScene::onCapturedScreen(bool succeed, const std::string& outputFile)
{
	hideLoading();
	if (succeed)
	{
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        std::string msr = "Capture screen succeed, you can find it at Photos Library: \n\n";
        saveScreenShot(imgSSPath);
#elif CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        std::string msr = "Capture screen succeed, you can find it at: \n\n";
#endif
		msr.append(imgSSPath);
		openPopup(new AlertPopup(msr));
	}
	else {
		openPopup(new AlertPopup("Can not capture screen"));
	}
    
}



