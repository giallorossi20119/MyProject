//
//  LoadingScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "LoadingScene.h"
#include "LoginScene.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "ResourceManager.h"
#include "GlobalVariable.h"
#include "SceneManager.h"
#include "spine/SkeletonAnimation.h"

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

LoadingScene::LoadingScene()
{
    m_fTimeLeft = 0.0f;
}

LoadingScene::~LoadingScene()
{
}

//*******************************
// start pragma init Scene
//*******************************
void LoadingScene::onEnter()
{
    BaseScene::onEnter();
    schedule(schedule_selector(LoadingScene::update));
    schedule(schedule_selector(LoadingScene::updateLoadingBar));
    //load scene
    BaseScene::initUI(kSceneJsonLoading);
    int lang =  UserDefault::getInstance()->getIntegerForKey("language");
    ResourceManager::getInstance()->setLanguage(lang);
    relayout();
    SFSConnection::getInstance()->initServer();
}

void LoadingScene::updateLoadingBar(float dt)
{
    //CCLOG("dt %f", m_fTimeLeft);
    m_fTimeLeft += dt;
    LoadingBar* prgLoadingBar = static_cast<LoadingBar*>(Helper::seekWidgetByName(m_pLayout, "prgLoadingBar"));
    prgLoadingBar->setPercent(100 * (m_fTimeLeft / 1));
    if(prgLoadingBar->getPercent() >= 100)
    {
        unschedule(schedule_selector(LoadingScene::updateLoadingBar));
        loadResource();
    }
}

void LoadingScene::loadResource()
{
    ResourceManager::getInstance()->cacheSpine();
    //update loading bar
    //load config
    ResourceManager::getInstance()->loadConfig();
    //load lang
    ResourceManager::getInstance()->loadTextMessage();
    ResourceManager::getInstance()->loadTextData();
    ResourceManager::getInstance()->loadTextureData();
    //load sound
    ResourceManager::getInstance()->loadSoundData();
    ResourceManager::getInstance()->loadTextureEffect();
    ResourceManager::getInstance()->cacheScene();
    ResourceManager::getInstance()->checkAccountMode();
    // Init ad baner
    GlobalVariable::m_pAdBar = new AdBar("news.txt");
    GlobalVariable::m_bResourceLoaded = true;
}

void LoadingScene::loadingCallBack(cocos2d::Texture2D *texture)
{
	//CCLOG("LoadingScene::loadingCallBack");
}

void LoadingScene::addEventlistener()
{

}

void LoadingScene::relayout()
{
    Size deviceSize = Director::getInstance()->getWinSize();

    ImageView* imgLoadingBarBg = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLoadingBarBg"));
    imgLoadingBarBg->setPosition(Vec2(deviceSize.width/2, imgLoadingBarBg->getPositionY()));

    ImageView* imgGirl = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgGirl"));
    imgGirl->setPosition(Vec2(deviceSize.width/2, imgGirl->getPositionY()));

    LoadingBar* prgLoadingBar = static_cast<LoadingBar*>(Helper::seekWidgetByName(m_pLayout, "prgLoadingBar"));
    prgLoadingBar->setPosition(Vec2(deviceSize.width/2, prgLoadingBar->getPositionY()));
    prgLoadingBar->setPercent(0);
}
/* end pragma init Scene */



//*******************************
// star pragma logic Scene
//*******************************

/* end pragma logic Scene */

void LoadingScene::update(float dt)
{
    //BaseScene::update(dt);
    if(ResourceManager::getInstance()->m_bLoadConfigFinish && GlobalVariable::m_bResourceLoaded && GlobalVariable::m_iAccountMode != kAccountModeOther)
    {
        SceneManager::getInstance()->switchScene(kSceneLogin);
    }
}

//*******************************
// start pragma exit Scene
//*******************************
void LoadingScene::onExit()
{
    BaseScene::onExit();
    getEventDispatcher()->removeEventListenersForTarget(this);
}

/* end pragma exit Scene */



