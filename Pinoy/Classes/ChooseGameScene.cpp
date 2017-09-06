//
//  ChooseGameScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "ChooseGameScene.h"
#include "LobbyScene.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "ResourceManager.h"
#include "GlobalVariable.h"
#include "ImageLoader.h"
#include "ZoneData.h"
#include "UserInfo.h"
#include "DailyBonusPopup.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_WP8
#include "\\psf\Home\Desktop\Projects\SVN\indo\mobile\trunk\proj.wp8-xaml\AppComponent\src\SmartfoxInterop.h"
using namespace PhoneDirect3DXamlAppComponent;
extern SmartfoxClientCallback^ g_smartfoxClientCallback;
#else
#include "SFSConnection.h"
#endif

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

//bool isFirstLoad = true;
//*******************************
// start pragma init Scene
//*******************************
void ChooseGameScene::onEnter()
{
    BaseScene::onEnter();
    schedule(schedule_selector(ChooseGameScene::update));
    AudioManager::getInstance()->playBackgroundMusic(kSoundMusicTitle, true);
    //ads bar component
//    if (GlobalVariable::m_pAdBar->getParent()) GlobalVariable::m_pAdBar->removeFromParent();
//    
//    m_pUILayer->addChild(GlobalVariable::m_pAdBar);
//    GlobalVariable::m_pAdBar->continueRun();
    
    //load scene
    BaseScene::initUI(kSceneChooseGameJsonFile);
    //user infor component
    if(GlobalVariable::m_bFirstLoad == false)
    {
        GlobalVariable::m_pUserInfo = new UserInfo();
        GlobalVariable::m_pUserInfo->fillDataUserInfo();
        GlobalVariable::m_pSettingCom = new SettingCom();
        GlobalVariable::m_bFirstLoad = true;
    }
    else
    {
        GlobalVariable::m_pUserInfo->fillDataUserInfo();
        GlobalVariable::m_pUserInfo->visibleHost(false);
    }
    
    //setting panel
    if (GlobalVariable::m_pSettingCom->getParent()) GlobalVariable::m_pSettingCom->removeFromParent();
    GlobalVariable::m_pSettingCom->setPosition(Vec2(0, 0));
    GlobalVariable::m_pSettingCom->setVisiblePanelIAP(false);
    m_pLayout->addChild(GlobalVariable::m_pSettingCom);
    GlobalVariable::m_pSettingCom->setVisibleItems(true, true, false, false, true, false, true, false, false);
    
    //ads bar component
//    if (GlobalVariable::m_pAdBar->getParent()) GlobalVariable::m_pAdBar->removeFromParent();
//    m_pLayout->addChild(GlobalVariable::m_pAdBar);
//    GlobalVariable::m_pAdBar->continueRun();
    
    addEventlistener();
    
    relayout();
    /*
     auto girl = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimGirl]->getSkeleton()->data);
     girl->setMix("girl", "girl", 1.0f);
     girl->addAnimation(0, "girl", true);
     girl->setOpacity(0);
     girl->setScale(0.9f);
     girl->setPosition(Vec2(-200, -50));
     m_pBGLayer->addChild(girl);
     auto moveright1  = MoveTo::create(0.2f, Vec2(200, girl->getPositionY()));
     auto fadein      = FadeTo::create(0.2f, 225);
     auto spawn       = Spawn::create(moveright1, fadein, NULL, NULL);
     girl->runAction(spawn);
     */
    GlobalVariable::m_bBackToLobby = false;
    GlobalVariable::m_bBackToChooseGame = false;
    
    bool bFirstLoad = UserDefault::getInstance()->getBoolForKey("FirstLoad");
    if(!bFirstLoad && LoginHandler::getInstance()->m_iLoginType == kLoginTypeDeviceID)
    {
//        UserDefault::getInstance()->setBoolForKey("FirstLoad", true);
//        auto cpu = ChangeNamePopup::create();
//        openPopup(cpu);
    }
    
    if(GlobalVariable::m_bWasDailyBonus)
    {
        GlobalVariable::m_bWasDailyBonus = false;
        CMDDailyBonusData* data = GlobalVariable::m_cmdDailyBonusData;
        DailyBonusPopup* popup  = DailyBonusPopup::create(data);
        openPopup(popup);
    }
}

void ChooseGameScene::onEnterTransitionDidFinish()
{
    Vector<Node*> arr = m_pUILayer->getChildren();
    if (GlobalVariable::m_pUserInfo->getParent()) GlobalVariable::m_pUserInfo->removeFromParent();
    m_pUILayer->addChild(GlobalVariable::m_pUserInfo);
    GlobalVariable::m_pUserInfo->setPosition(Vec2(-20, 525));
}

void ChooseGameScene::update(float dt)
{
    BaseScene::update(dt);
}

void ChooseGameScene::relayout()
{
    Size deviceSize = Director::getInstance()->getWinSize();
    
    GlobalVariable::m_pSettingCom->setPosition(Vec2(deviceSize.width - 400, 560));
    Layout* panelGameBtns = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "panelGameBtns"));
    panelGameBtns->setPositionX((deviceSize.width - panelGameBtns->getContentSize().width) / 2);
    // Animation
    GlobalVariable::m_pSettingCom->m_pLayout->setOpacity(50);
    GlobalVariable::m_pSettingCom->m_pLayout->runAction(Spawn::create(FadeTo::create(0.3f, 255), nullptr));
    GlobalVariable::m_pUserInfo->m_pLayout->setOpacity(50);
    GlobalVariable::m_pUserInfo->m_pLayout->runAction(Spawn::create(FadeTo::create(0.3f, 255), nullptr));
    
    panelGameBtns->setOpacity(50);
    panelGameBtns->runAction(FadeTo::create(0.2f, 255));
    m_p_bGame1->setPositionX(m_p_bGame1->getPositionX() - 100.0f);
    m_p_bGame2->setPositionX(m_p_bGame2->getPositionX() + 0.0f);
    m_p_bGame3->setPositionX(m_p_bGame3->getPositionX() + 100.0f);
    m_p_bGame1->setOpacity(0);
    m_p_bGame2->setOpacity(0);
    m_p_bGame3->setOpacity(0);
    m_p_bGame1->runAction(Sequence::create(DelayTime::create(0.3f), Spawn::create(MoveBy::create(0.2f, Vec2(20.0f, 0.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));
    m_p_bGame2->runAction(Sequence::create(DelayTime::create(0.4f), Spawn::create(MoveBy::create(0.2f, Vec2(20.0f, 0.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));
    m_p_bGame3->runAction(Sequence::create(DelayTime::create(0.5f), Spawn::create(MoveBy::create(0.2f, Vec2(20.0f, 0.0f)), FadeTo::create(0.2f, 255), nullptr), nullptr));
    
}

void ChooseGameScene::addEventlistener()
{
    m_p_bGame1 = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnGame1"));
    m_p_bGame1->addTouchEventListener(CC_CALLBACK_2(ChooseGameScene::onBtnGame1Click, this));
//    m_p_bGame1->setVisible(false);
    
    m_p_bGame2 = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnGame2"));
    m_p_bGame2->addTouchEventListener(CC_CALLBACK_2(ChooseGameScene::onBtnGame2Click, this));
    
    m_p_bGame3 = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnGame3"));
    m_p_bGame3->addTouchEventListener(CC_CALLBACK_2(ChooseGameScene::onBtnGame3Click, this));
//    m_p_bGame3->setVisible(false);
    
    Layout* panelSetting = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "panelRightBtns"));
    m_p_bBtnMoney = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnMoney"));
    m_p_bBtnRanking = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnRanking"));
    m_p_bBtnSettings = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnSettings"));
    
    m_p_bBackHome = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnHome"));
    m_p_bBackHome->addTouchEventListener(CC_CALLBACK_2(ChooseGameScene::onBtnBackHomeClick, this));
    
    imgLogoChooseGame = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLogo"));
    imgLogoChooseGame->setVisible(false);
    
    m_listenerKeyboard->onKeyReleased = CC_CALLBACK_2(ChooseGameScene::onKeyReleased, this);
    getEventDispatcher()->addEventListenerWithFixedPriority(m_listenerKeyboard, 1);
}
void ChooseGameScene::onBtnBackHomeClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    backScene();
}
void ChooseGameScene::backScene()
{
    GlobalVariable::m_bLogout = true;
    GlobalVariable::m_bBackToChooseGame = true;
    LoginHandler::logoutFacebook();
//    LoginHandler::logoutGooglePlus();
    SFSConnection::getInstance()->disconnectToServer();
}
void ChooseGameScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
    if (SceneManager::getInstance()->m_iCurrentScene == kSceneChooseGame  &&
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

void ChooseGameScene::onBtnGame1Click(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    
//    openPopup(new AlertPopup("We are so sorry, Pusoy Dos Game is under construction!"));
    GlobalVariable::m_iCurrentGame = kGameBanting;
    GlobalVariable::m_iCurrentZone = 1;
    chooseGame();
}

void ChooseGameScene::onBtnGame2Click(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    if (Widget::TouchEventType::ENDED != type) return;
    GlobalVariable::m_iCurrentGame = kGameSusun;
    GlobalVariable::m_iCurrentZone = 1;
    chooseGame();
}

void ChooseGameScene::onBtnGame3Click(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    
//    openPopup(new AlertPopup("We are so sorry, Tongits Game is under construction!"));
    GlobalVariable::m_iCurrentGame = kGameTongits;
    GlobalVariable::m_iCurrentZone = 1;
    chooseGame();
}

void ChooseGameScene::chooseGame()
{
    SFSConnection::getInstance()->disconnectToServer();
}

void ChooseGameScene::changeLanguage(Ref* obj)
{
    TextField* txtLabel = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtLabel"));
    txtLabel->setString(ResourceManager::getInstance()->getTextByName(kTEXT_LOADING_TITLE).c_str());
}

/* end pragma init Scene */

//*******************************
// start pragma exit Scene
//*******************************
void ChooseGameScene::onExit()
{
    BaseScene::onExit();
    getEventDispatcher()->removeEventListenersForTarget(this);
//    if (GlobalVariable::m_pAdBar->getParent() && GlobalVariable::m_pAdBar->getParent() == this) GlobalVariable::m_pAdBar->removeFromParent();
    if (GlobalVariable::m_pUserInfo->getParent() && GlobalVariable::m_pUserInfo->getParent() == m_pUILayer)
    {
        GlobalVariable::m_pUserInfo->removeFromParent();
    }
}

/* end pragma exit Scene */

ChooseGameScene::ChooseGameScene()
{
}

ChooseGameScene::~ChooseGameScene()
{
    
}
