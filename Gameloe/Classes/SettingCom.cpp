//
//  SettingCom.cpp
//  IndoGame
//
//  Created & Modified by longnh on 8/14/14.
//
//

#include "SettingCom.h"
#include "IAPPopup.h"

SettingCom::SettingCom()
{
    BaseCom();
    BaseCom::create(kComponentSetting);

	Layout* panelSetting = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "panelRightBtns"));
    m_pnlIAP = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlIAP"));
    m_pnlIAP->setVisible(false);
    m_p_bBtnIAP = static_cast<Button*>(Helper::seekWidgetByName(m_pnlIAP, "btnAdd"));

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    m_p_bBtnIAP->loadTextureNormal("ios_iap_button.png");
    m_p_bBtnIAP->loadTexturePressed("ios_iap_button_tap.png");
#else
    m_p_bBtnIAP->loadTextureNormal("google_iap_tap.png");
    m_p_bBtnIAP->loadTexturePressed("google_iap.png");
#endif
    m_p_bBtnIAP->setVisible(false);
    m_p_bBtnUnipin  = static_cast<Button*>(Helper::seekWidgetByName(m_pnlIAP, "btnUnipin"));
    m_p_bBtnMimoPay = static_cast<Button*>(Helper::seekWidgetByName(m_pnlIAP, "btnMimopay"));
	m_p_bBtnMoney = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnMoney"));
	m_p_bBtnRanking = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnRanking"));
    m_p_bBtnLogout = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnLogout"));
	m_p_bBtnSettings = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnSettings"));
	m_p_bBtnChat = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnChat"));
	m_p_bBtnFanPage = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnFanPage"));
    m_p_bBtnPhone = static_cast<Button*>(Helper::seekWidgetByName(panelSetting, "btnPhone"));
    m_p_lblPhone = static_cast<Text*>(Helper::seekWidgetByName(panelSetting, "lblPhone"));

    m_p_lSettingBtnsDropDown = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "panelSettings"));
	m_p_lSettingBtnsDropDown->setVisible(false);
	m_p_bBtnCapture = static_cast<Button*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "btnCapture"));
	m_p_bBtnMute = static_cast<Button*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "btnMute"));
	m_p_bBtnUnmute = static_cast<Button*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "btnUnmute"));
	m_p_bBtnSettingsIn = static_cast<Button*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "btnSettingIn"));
    m_p_bBtnHistory = static_cast<Button*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "btnHistory"));
	m_p_iImageSlide = static_cast<ImageView*>(Helper::seekWidgetByName(m_p_lSettingBtnsDropDown, "imgSlide"));
    m_posSetting      = Vec2(40, 540);
    m_posBtnCapture   = m_p_bBtnCapture->getPosition();
    m_posBtnMute      = m_p_bBtnMute->getPosition();
    m_posBtnSettingIn = m_p_bBtnSettingsIn->getPosition();
    m_posBtnUnmute    = m_p_bBtnUnmute->getPosition();
    m_posBtnHistory   = m_p_bBtnHistory->getPosition();

	m_p_bBtnCapture->setPosition(m_posSetting);
	m_p_bBtnMute->setPosition(m_posSetting);
	m_p_bBtnUnmute->setPosition(m_posSetting);
	m_p_bBtnSettingsIn->setPosition(m_posSetting);
    m_p_bBtnHistory->setPosition(m_posSetting);

	m_fDurationTrans = 0.2;
    bool bMuted = UserDefault::getInstance()->getBoolForKey("muted");
    CCLOG("Mute>>>>>>>>>>>>>>%d", bMuted);
	if (bMuted)
	{
		m_p_bBtnMute->setVisible(false);
		m_p_bBtnUnmute->setVisible(true);
	}
	else
	{
		m_p_bBtnMute->setVisible(true);
		m_p_bBtnUnmute->setVisible(false);
	}

	addEventlistener();
    if(strcmp(GlobalVariable::m_sInreview.c_str(), "1") == 0)
    {
        //m_p_bBtnMimoPay->setVisible(false);
        //m_p_bBtnUnipin->setVisible(false);
    }
}

void SettingCom::onBtnChatClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->openPopup(new ChatPopup());
}

void SettingCom::onBtnSettingsClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    m_bIsSettingsVisible = (m_bIsSettingsVisible == true) ? false : true;
    m_p_iImageSlide->stopAllActions();
    if (m_bIsSettingsVisible)
    {
        m_p_lSettingBtnsDropDown->setVisible(m_bIsSettingsVisible);
        auto moveCapture = MoveTo::create(m_fDurationTrans, m_posBtnCapture);
        auto moveMute = MoveTo::create(m_fDurationTrans, m_posBtnMute);
        auto moveUnmute = MoveTo::create(m_fDurationTrans, m_posBtnUnmute);
        auto moveSettingIn = MoveTo::create(m_fDurationTrans, m_posBtnSettingIn);
        auto moveHistory = MoveTo::create(m_fDurationTrans, m_posBtnHistory);
        auto fadeSlide = FadeTo::create(m_fDurationTrans, 255);

        auto seq1 = Sequence::create(moveCapture, DelayTime::create(0.0f), nullptr, nullptr, nullptr);
        auto seq2 = Sequence::create(moveMute, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
        auto seq3 = Sequence::create(moveUnmute, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
        auto seq4 = Sequence::create(moveSettingIn, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
        auto seq5 = Sequence::create(moveHistory, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
        auto seq6 = Sequence::create(fadeSlide, DelayTime::create(0.5f), nullptr, nullptr, nullptr);

        m_p_bBtnCapture->runAction(seq1);
        m_p_bBtnMute->runAction(seq2);
        m_p_bBtnUnmute->runAction(seq3);
        m_p_bBtnSettingsIn->runAction(seq4);
        m_p_bBtnHistory->runAction(seq5);

        m_p_iImageSlide->runAction(Sequence::create(seq6, CallFuncN::create(CC_CALLBACK_1(SettingCom::hideSettings, this)), nullptr));
    }
    else
    {
        hideSlideButtons();
    }
}

void SettingCom::hideSlideButtons()
{
    m_bIsSettingsVisible = false;
	auto moveCaptureReverse = MoveTo::create(m_fDurationTrans, m_posSetting);
	auto moveMuteReverse = MoveTo::create(m_fDurationTrans, m_posSetting);
	auto moveUnmuteReverse = MoveTo::create(m_fDurationTrans, m_posSetting);
	auto moveSettingInReverse = MoveTo::create(m_fDurationTrans, m_posSetting);
    auto moveHistoryReverse = MoveTo::create(m_fDurationTrans, m_posSetting);
	auto fadeSlideReverse = FadeTo::create(m_fDurationTrans, 0);
	auto seq1 = Sequence::create(moveCaptureReverse, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
	auto seq2 = Sequence::create(moveMuteReverse, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
	auto seq3 = Sequence::create(moveUnmuteReverse, DelayTime::create(0.5f), nullptr, nullptr, nullptr);
	auto seq4 = Sequence::create(moveSettingInReverse, DelayTime::create(0.0f), nullptr, nullptr, nullptr);
    auto seq5 = Sequence::create(moveHistoryReverse, DelayTime::create(0.0f), nullptr, nullptr, nullptr);
	auto seq6 = Sequence::create(fadeSlideReverse, DelayTime::create(0.0f), nullptr, nullptr, nullptr);

	m_p_bBtnMute->runAction(seq2);
	m_p_bBtnUnmute->runAction(seq3);
	m_p_bBtnSettingsIn->runAction(seq4);
    m_p_bBtnHistory->runAction(seq5);
	m_p_bBtnCapture->runAction(Sequence::create(seq1, CallFuncN::create(CC_CALLBACK_1(SettingCom::hideSettings, this)), nullptr));
	m_p_iImageSlide->runAction(seq6);
}

void SettingCom::hideSettings(Node* node)
{
	m_p_lSettingBtnsDropDown->setVisible(m_bIsSettingsVisible);
}

void SettingCom::addEventlistener()
{
	m_p_bBtnSettings->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnSettingsClick, this));
	m_p_bBtnRanking->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnRankingClick, this));
	m_p_bBtnMoney->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnMoneyClick, this));
    m_p_bBtnIAP->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnIAPClick, this));
    m_p_bBtnMimoPay->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnUnipinClick, this));
    m_p_bBtnUnipin->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnUnipinClick, this));
    m_p_bBtnLogout->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnLogout, this));
	m_p_bBtnCapture->addTouchEventListener(CC_CALLBACK_2(SettingCom::onCaptureClick, this));
	m_p_bBtnUnmute->addTouchEventListener(CC_CALLBACK_2(SettingCom::onUnmuteClick, this));
	m_p_bBtnMute->addTouchEventListener(CC_CALLBACK_2(SettingCom::onMuteClick, this));
	m_p_bBtnSettingsIn->addTouchEventListener(CC_CALLBACK_2(SettingCom::onSettingInClick, this));
    m_p_bBtnChat->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnChatClick, this));
    m_p_bBtnHistory->addTouchEventListener(CC_CALLBACK_2(SettingCom::onBtnHistory, this));
    m_p_bBtnFanPage->addTouchEventListener(CC_CALLBACK_2(SettingCom::onTouchBtnFanPage, this));
    m_p_bBtnPhone->addTouchEventListener(CC_CALLBACK_2(SettingCom::onTouchBtnPhone, this));
}

void SettingCom::onTouchBtnPhone(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    LoginHandler::getInstance()->callSupport(kSupportNumber);
}

void SettingCom::onTouchBtnFanPage(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    LoginHandler::getInstance()->openFanpage(kURLFanPage);
}

void SettingCom::onBtnIAPClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    IAPPopup* ip = IAPPopup::create();
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->openPopup(ip);
}

void SettingCom::onBtnLogout(Ref *pSender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    if(SceneManager::getInstance()->m_iCurrentScene == kSceneLobby)
    {
        GlobalVariable::m_bBackToLobby = true;
        GlobalVariable::m_iCurrentGame = 0;
        GlobalVariable::m_iCurrentZone = 0;
        SFSConnection::getInstance()->disconnectToServer();
        return;
    }

    if(SceneManager::getInstance()->m_iCurrentScene == kSceneChooseGame)
    {
        GlobalVariable::m_bLogout = true;
        GlobalVariable::m_bBackToChooseGame = true;
        LoginHandler::logoutFacebook();
        LoginHandler::logoutGooglePlus();
        SceneManager::getInstance()->switchScene(kSceneLogin);
        return;
    }

    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    CCLOG("Playing: %i | Reconnect: %i | Spectator: %i",
          GlobalVariable::m_cSetData->m_bPlaying,
          GlobalVariable::m_cSetData->m_bReconnect,
          GlobalVariable::m_cSetData->m_bSpectator);
    if((GlobalVariable::m_cSetData->m_bPlaying && !GlobalVariable::m_cSetData->m_bSpectator)
       || (GlobalVariable::m_startGameData->m_bPlaying && !GlobalVariable::m_startGameData->m_bSpec))
    {
        GlobalVariable::m_bRequestLogout = GlobalVariable::m_bRequestLogout ? false : true;
        if(GlobalVariable::m_bRequestLogout)
        {
            scene->showToast(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_REQUEST_LOGOUT), 3.0f);
            m_p_bBtnLogout->setColor(Color3B(252, 100, 0));
        }
        else
        {
            scene->showToast(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_REQUEST_LOGOUT_CANCEL), 3.0f);
            m_p_bBtnLogout->setColor(Color3B(255, 255, 255));
        }
    }
    else
    {
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
}

void SettingCom::onMuteClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;

    GlobalVariable::m_bMute = true;
    UserDefault::getInstance()->setBoolForKey("muted", true);
    m_p_bBtnUnmute->setVisible(true);
    m_p_bBtnMute->setVisible(false);
    AudioManager::getInstance()->muteBackground(true);
    AudioManager::getInstance()->muteEffect(true);
}

void SettingCom::onUnmuteClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;

    GlobalVariable::m_bMute = false;
    UserDefault::getInstance()->setBoolForKey("muted", false);
    m_p_bBtnUnmute->setVisible(false);
    m_p_bBtnMute->setVisible(true);
    AudioManager::getInstance()->muteBackground(false);
    AudioManager::getInstance()->muteEffect(false);
}

void SettingCom::onCaptureClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->captureScreen();
}

void SettingCom::onSettingInClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type ) return;
    AudioManager::getInstance()->playEffect(kSoundEffectFire);
    if (SceneManager::getInstance()->m_iCurrentScene == kSceneInGame1 || SceneManager::getInstance()->m_iCurrentScene == kSceneInGame2)
    {
        if (GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_cSetData->m_bPlaying && !GlobalVariable::m_startGameData->m_bPlaying)
        {
            m_bIsSettingsVisible = !m_bIsSettingsVisible;
            hideSlideButtons();
            NotificationCenter::getInstance()->postNotification(EVENT_SHOW_SETTING_ROOM, NULL);
        }
        else
        {
            const char* str = ResourceManager::getInstance()->getTextByName(kTEXT_MSG_HOST_NOT_READY).c_str();
            NotificationCenter::getInstance()->postNotification(EVENT_SHOW_ALERT, (Ref*)str);
        }
    }
    else
    {
        m_bIsSettingsVisible = !m_bIsSettingsVisible;
        hideSlideButtons();

        BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
        scene->openPopup(new SettingLobby());
    }
}

void SettingCom::onBtnUnipinClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);

    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    Size deviceSize = Director::getInstance()->getWinSize();
    if(scene->getChildByName("_webView"))scene->removeChildByName("_webView");
    if(scene->getChildByName("_imgviewBG"))scene->removeChildByName("_imgviewBG");
    if(scene->getChildByName("_btnClose"))scene->removeChildByName("_btnClose");

    auto func = [](Ref *pSender, Widget::TouchEventType type){
        if (Widget::TouchEventType::ENDED != type) return;
        BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
        if(scene->getChildByName("_webView"))scene->removeChildByName("_webView");
        if(scene->getChildByName("_imgviewBG"))scene->removeChildByName("_imgviewBG");
        if(scene->getChildByName("_btnClose"))scene->removeChildByName("_btnClose");
    };

    auto func0 = [](Ref *pSender, Widget::TouchEventType type){return;};
    LayerColor* _imgviewBG = LayerColor::create(Color4B(0, 0, 0, 170));
    _imgviewBG->setContentSize(Size(deviceSize.width, deviceSize.height));
    _imgviewBG->setTouchEnabled(true);
    _imgviewBG->setName("_imgviewBG");
    auto touchOneByOne = EventListenerTouchOneByOne::create();

		touchOneByOne->retain();
		touchOneByOne->setEnabled(true);
		touchOneByOne->setSwallowTouches(true);
		touchOneByOne->onTouchBegan = [](Touch* touch, Event* event)
		{
			return true;
		};
	_eventDispatcher->addEventListenerWithSceneGraphPriority(touchOneByOne, _imgviewBG);

    auto _webView = cocos2d::experimental::ui::WebView::create();
    _webView->setName("_webView");
    _webView->setOnShouldStartLoading(CC_CALLBACK_2(SettingCom::onWebViewShouldStartLoading, this));
    _webView->setOnDidFinishLoading(CC_CALLBACK_2(SettingCom::onWebViewDidFinishLoading, this));
    _webView->setOnDidFailLoading(CC_CALLBACK_2(SettingCom::onWebViewDidFailLoading, this));
    _webView->setPosition(deviceSize/2);
    _webView->setContentSize(Size(deviceSize.width, deviceSize.height));
    _webView->loadURL(ccsf("%s%s", kBankURL, GlobalVariable::m_sSID.c_str()));
    _webView->setScalesPageToFit(true);

    auto _btnClose = Button::create("normal_btn.png", "normal_btn_tap.png");
    _btnClose->setName("_btnClose");
    _btnClose->setTitleText("X");
    _btnClose->setScale(0.7f);
    _btnClose->setTitleFontSize(40);
    _btnClose->setPosition(Vec2(0, 0));

    _btnClose->addTouchEventListener(func);

    scene->addChild(_imgviewBG);
    scene->addChild(_webView);
    _webView->addChild(_btnClose, 1);
}

void SettingCom::onBtnMoneyClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);

    if(m_pnlIAP->isVisible())
    {
        m_pnlIAP->setVisible(false);
    }
    else
    {
        m_pnlIAP->setVisible(true);
    }
}

void SettingCom::onBtnRankingClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
    SFSConnection::getInstance()->requestRank();
}

void SettingCom::onBtnHistory(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    EndGamePopup* eP = new EndGamePopup();
    scene->openPopup(eP);
}

SettingCom::~SettingCom()
{
}

void SettingCom::setVisibleItems(bool p_bMoney, bool P_bRank, bool p_bChat, bool p_bHistory, bool p_bLogout, bool p_bUnipin, bool p_bFanPage, bool p_bPhone, bool p_bMimoPay)
{
    m_p_bBtnLogout->setColor(Color3B(255, 255, 255));
    m_p_bBtnHistory->setVisible(p_bHistory);
    m_p_bBtnMoney->setVisible(p_bMoney);
    m_p_bBtnRanking->setVisible(P_bRank);
    m_p_bBtnChat->setVisible(p_bChat);
    m_p_bBtnChat->setPosition(m_p_bBtnFanPage->getPosition());
    m_p_bBtnLogout->setVisible(p_bLogout);
    m_p_bBtnFanPage->setVisible(p_bFanPage);
    m_p_bBtnPhone->setVisible(p_bPhone);
    m_p_lblPhone->setVisible(p_bPhone);
}

void SettingCom::setVisiblePanelIAP(bool bVisible)
{
    m_pnlIAP->setVisible(bVisible);
}

bool SettingCom::onWebViewShouldStartLoading(experimental::ui::WebView *sender, const std::string &url)
{
    //CCLOG("onWebViewShouldStartLoading, url is %s", url.c_str());
    return true;
}

void SettingCom::onWebViewDidFinishLoading(experimental::ui::WebView *sender, const std::string &url)
{
    CCLOG("onWebViewDidFinishLoading, url is %s", url.c_str());
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    if(url.find("return?code=1") != std::string::npos)
    {
        char* end;
        string moneyChange = url.substr(strlen("http://bank.gameloe.com/webview/return?code=1&money="), url.length());
        double money = std::strtod(moneyChange.c_str(), &end);
        CCLOG("money changed 1: %1.0f", money);
        if(scene->getChildByName("_webView"))scene->removeChildByName("_webView");
        if(scene->getChildByName("_imgviewBG"))scene->removeChildByName("_imgviewBG");
        if(scene->getChildByName("_btnClose"))scene->removeChildByName("_btnClose");
        CCLOG("money changed 3");
        CMDDoubleData* data = new CMDDoubleData(money);
        data->autorelease();
        NotificationCenter::getInstance()->postNotification("UPDATE_USER_MONEY", data);
    }
}

void SettingCom::onWebViewDidFailLoading(experimental::ui::WebView *sender, const std::string &url)
{
    CCLOG("onWebViewDidFailLoading, url is %s", url.c_str());
}

