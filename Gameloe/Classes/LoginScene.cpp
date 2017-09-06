//
//  LoginScene.cpp
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#include "LoginScene.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "ResourceManager.h"
#include "GlobalVariable.h"
#include "LoginScene.h"
#include "ZoneData.h"
#include "AlertPopup.h"
#include "ChooseGameScene.h"
#include "EventConst.h"
#include "ChatToast.h"
#include "ChatPopup.h"
#include "spine/SkeletonAnimation.h"
#include "RegisterPopup.h"
#include "LoginPopup.h"
#include "ForgotPWPopup.h"
#include "DailyBonusPopup.h"
#include "TextMessage.h"

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


LoginScene::LoginScene()
{

}

LoginScene::~LoginScene()
{

}


void LoginScene::onEnter()
{
    BaseScene::onEnter();
    schedule(schedule_selector(LoginScene::update));
    BaseScene::initUI(kSceneJsonLogin);
    addEventlistener();
    Size windowSize = Director::getInstance()->getWinSize();
    ImageView* imgLogo = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLogo"));
    ImageView* imgLoginPanelBg = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLoginPanelBg"));
    auto moveright  = MoveTo::create(0.3f, Vec2(windowSize.width - 200, imgLogo->getPositionY()));
    auto movedown = MoveTo::create(0.2f, Vec2(imgLoginPanelBg->getPosition().x, imgLoginPanelBg->getPosition().y - 500));
    auto delay = DelayTime::create(0.3f);
    auto seq1 = Sequence::create(delay, movedown, NULL);
    imgLoginPanelBg->runAction(seq1);
    imgLogo->runAction(moveright);
    changeLanguage(NULL);
    relayout();

    auto girl = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimGirl]->getSkeleton()->data);
    girl->setScale(0.9f);
    girl->setMix("girl", "girl", 1.0f);
    girl->addAnimation(0, "girl", true);
    girl->setPosition(Vec2(-200, -50));
    m_pBGLayer->addChild(girl);
    girl->setOpacity(0);
    auto fadein = FadeTo::create(0.3f, 255);
    auto moveright1  = MoveTo::create(0.3f, Vec2(windowSize.width - 200, girl->getPositionY()));
    auto spaw = Spawn::create(moveright1, fadein, nullptr, nullptr);
    girl->runAction(spaw);

    auto lightLeft = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[1]->getSkeleton()->data);
    lightLeft->setMix("trai", "trai", 1.0f);
    lightLeft->addAnimation(0, "trai", true);
    imgLoginPanelBg->addChild(lightLeft);
    lightLeft->setPosition(Vec2(imgLoginPanelBg->getContentSize().width / 2, 5));

    auto lightRight = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[1]->getSkeleton()->data);
    lightRight->setMix("phai", "phai", 1.0f);
    lightRight->addAnimation(0, "phai", true);
    imgLoginPanelBg->addChild(lightRight);
    lightRight->setPosition(Vec2(imgLoginPanelBg->getContentSize().width / 2, imgLoginPanelBg->getContentSize().height - 4));
    checkVersion();
    if(!GlobalVariable::m_bLogout)
    {
        GlobalVariable::m_bLogout = true;
        //LoginHandler::getInstance()->connectToFacebook();
        //LoginHandler::getInstance()->connectByDeviceID();
    }
}

void LoginScene::addEventlistener()
{
    m_btnFacebookLogin = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLoginByFacebook"));
    m_btnFacebookLogin->addTouchEventListener(CC_CALLBACK_2(LoginScene::onBtnLoginFacebook, this));

    m_btnGoogleLogin = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLoginByGoogle"));
    m_btnGoogleLogin->addTouchEventListener(CC_CALLBACK_2(LoginScene::onBtnLoginGoogle, this));
    m_btnGoogleLogin->setCascadeOpacityEnabled(true);
    m_btnGoogleLogin->setEnabled(false);
    m_btnGoogleLogin->setOpacity(80);

    m_btnAccountBaseLogin = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLoginByAccountBase"));
    m_btnAccountBaseLogin->addTouchEventListener(CC_CALLBACK_2(LoginScene::onTouchBtnAccountBase, this));
    m_btnAccountBaseLogin->setCascadeOpacityEnabled(true);

    m_btnDeviceIDLogin = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLoginByDeviceID"));
    m_btnDeviceIDLogin->addTouchEventListener(CC_CALLBACK_2(LoginScene::onBtnDeviceID, this));
    m_btnDeviceIDLogin->setCascadeOpacityEnabled(true);

    int mode = UserDefault::getInstance()->getIntegerForKey("AccountMode");
    if(mode == kAccountModePersonal)
    {
        m_btnDeviceIDLogin->setEnabled(false);
        m_btnDeviceIDLogin->setOpacity(80);
    }
	//keyboard event
	m_listenerKeyboard->onKeyReleased = CC_CALLBACK_2(LoginScene::onKeyReleased, this);
	getEventDispatcher()->addEventListenerWithFixedPriority(m_listenerKeyboard, 1);

}

void LoginScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
	if (SceneManager::getInstance()->m_iCurrentScene == kSceneLogin  &&
        keyCode == EventKeyboard::KeyCode::KEY_BACK)
    {
        event->stopPropagation();
        if(m_vPopups != nullptr && m_vPopups->size() > 0)
        {
            closeAllPopups();
            return;
        }
		ConfirmPopup* cp = new ConfirmPopup(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_EXIT_GAME));
		openPopup(cp);
        auto func = [this](EventCustom* event){exit(0);};
		cp->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, func);
	}
}

RenderTexture* LoginScene::createStroke(Sprite* label, int size, Color3B color, GLubyte opacity)
{
    RenderTexture* rt = RenderTexture::create(label->getTexture()->getContentSize().width + size * 2,
                                                  label->getTexture()->getContentSize().height+size * 2);
    Vec2 originalPos = label->getPosition();
    Color3B originalColor = label->getColor();
    GLubyte originalOpacity = label->getOpacity();
    label->setColor(color);
    label->setOpacity(opacity);
    bool originalVisibility = label->isVisible();
    BlendFunc originalBlend = label->getBlendFunc();
    BlendFunc bf = {GL_SRC_ALPHA, GL_ONE};
    label->setBlendFunc(bf);
    Vec2 bottomLeft = Vec2(
                             label->getTexture()->getContentSize().width * label->getAnchorPoint().x + size,
                             label->getTexture()->getContentSize().height * label->getAnchorPoint().y + size);
    Vec2 positionOffset = Vec2(0, 0);
    if(label->getAnchorPoint().x == 0.5f){
        positionOffset.x = 0;
    }else if(label->getAnchorPoint().x == 0.0f){
        positionOffset.x =- label->getTexture()->getContentSize().width / 2;
    }else{
        positionOffset.x = label->getTexture()->getContentSize().width/2;
    }
    if(label->getAnchorPoint().y == 0.5f){
        positionOffset.y = 0;
    }else if(label->getAnchorPoint().y == 0.0f){
        positionOffset.y =- label->getTexture()->getContentSize().height / 2;
    }else{
        positionOffset.y =  label->getTexture()->getContentSize().height/2;
    }
    Vec2 position = originalPos - positionOffset;
    rt->begin();
    for (int i=0; i<360; i++)
    {
        label->setPosition(
                           Vec2(bottomLeft.x + sin(CC_DEGREES_TO_RADIANS(i))*size, bottomLeft.y + cos(CC_DEGREES_TO_RADIANS(i))*size)
                           );
        label->visit();
    }
    rt->end();
    label->setPosition(originalPos);
    label->setColor(originalColor);
    label->setBlendFunc(originalBlend);
    label->setVisible(originalVisibility);
    label->setOpacity(originalOpacity);
    rt->setPosition(position);

    rt->getSprite()->getTexture()->setAntiAliasTexParameters();
    return rt;
}

void LoginScene::checkVersion()
{
    if(GlobalVariable::m_bHasNewVersion)
    {
        closeAllPopups();
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
        ConfirmPopup* cp = new ConfirmPopup(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_NEW_VERSION_IOS));
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
        ConfirmPopup* cp = new ConfirmPopup(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_NEW_VERSION_ANDROID));
#else
        ConfirmPopup* cp = new ConfirmPopup(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_NEW_VERSION_ANDROID));
#endif

        openPopup(cp);
        cp->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, CC_CALLBACK_1(LoginScene::openStore, this));
        cp->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CANCEL, CC_CALLBACK_1(LoginScene::openStore, this));
    }
}

void LoginScene::openStore(EventCustom* event)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    Application::getInstance()->openURL("https://play.google.com/store/apps/details?id=com.Gameloe.CapsaSusun");
    exit(0);
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    Application::getInstance()->openURL("https://itunes.apple.com/us/app/52la.vn/id961960368?ls=1&mt=8");
    exit(0);
#else
    exit(0);
#endif
}

void LoginScene::changeLanguage(Ref* obj)
{
    //m_btnFacebookLogin->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_LOGIN_LOGIN_FACEBOOK).c_str());
    //m_btnGoogleLogin->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_LOGIN_LOGIN_GOOGLE).c_str());
    //m_btnDeviceIDLogin->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_LOGIN_LOGIN_DEVICE_ID).c_str());
}


void LoginScene::onTouchBtnAccountBase(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->initServer();
    LoginPopup* lp = LoginPopup::create();
    openPopup(lp);
}

void LoginScene::onBtnLoginFacebook(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->initServer();
    LoginHandler::getInstance()->connectToFacebook();
}

void LoginScene::onBtnDeviceID(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->initServer();
    LoginHandler::getInstance()->connectByDeviceID();
}

void LoginScene::onBtnLoginGoogle(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    if(!SFSConnection::getInstance()->isServerInit)
    {
        SFSConnection::getInstance()->initServer();
    }
    LoginHandler::getInstance()->connectToGooglePlus();
}

void LoginScene::update(float dt)
{
    BaseScene::update(dt);
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    if (LoginHandler::m_bLoginError)
    {
        hideLoading();
        closeAllPopups();
        LoginHandler::m_bLoginError = false;
        string alertString = "";
        CCLOG("errorrrrrr 0 %s", LoginHandler::m_sMsrError.c_str());
        if(strcmp(LoginHandler::m_sMsrError.c_str(), IDS_INVALID_CREDENTIAL) == 0 ||
           strcmp(LoginHandler::m_sMsrError.c_str(), IDS_ACCOUNT_NOT_EXIST_OR_EMAIL) == 0 ||
           strcmp(LoginHandler::m_sMsrError.c_str(), IDS_INVALID_ACCOUNT) == 0)
        {
            CCLOG("errorrrrrr 1");
            alertString = GlobalVariable::msgConst->getCurMsg(LoginHandler::m_sMsrError.c_str());
            CCLOG("errorrrrrr 2");
        }
        else
        {
            alertString = LoginHandler::m_sMsrError;
        }
        CCLOG("errorrrrrr %s", alertString.c_str());
        auto popup = AlertPopup::create(alertString);
        openPopup(popup);
        //showToast(LoginHandler::m_sMsrError, 3.0f);
    }
#endif
}

//*******************************
// start pragma exit Scene
//*******************************
void LoginScene::onExit()
{
    BaseScene::onExit();
    getEventDispatcher()->removeEventListenersForTarget(this);
}

/* end pragma exit Scene */