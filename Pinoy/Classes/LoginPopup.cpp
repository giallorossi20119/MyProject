#include "LoginPopup.h"
#include "ForgotPWPopup.h"

LoginPopup::LoginPopup(){}
LoginPopup::~LoginPopup(){}

LoginPopup* LoginPopup::create()
{
	LoginPopup* popup = new LoginPopup();
	popup->autorelease();
	return popup;
}

void LoginPopup::onOpen()
{
	BasePopup::onOpen();

	// Get popup layout
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("LoginPopup.json"));

	// Re-layout popup
	Size layoutSize = m_pLayout->getContentSize();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5, 0.5));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
	this->addChild(m_pLayout);

	// Get reference from UIs
	m_btnLogin      = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLogin"));
	m_btnClose      = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCancel"));
	m_btnForgotPW   = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnForgotPW"));
	m_txtEmail      = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtEmail"));
	m_txtPassword   = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtPassword"));
	m_chkSave       = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkSavePassword"));
    auto chkChangePassword = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkChangePassword"));
    chkChangePassword->setVisible(false);
    auto bmfChangPW = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfChangPW"));
    bmfChangPW->setVisible(false);
	// Set text based on language
	m_btnLogin->setTitleText   (ResourceManager::getInstance()->getTextByName(kTEXT_LOGIN_LOGIN).c_str());
	m_btnForgotPW->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_LOGIN_FORGOTPW).c_str());

	// Set place holder text input
	m_txtEmail->setPlaceHolder("Email");
	m_txtPassword->setPlaceHolder("Password");

	// Register IME event to move popup when soft input appear
	m_txtEmail->addEventListener(CC_CALLBACK_2(LoginPopup::onInputUserEvent, this));
	m_txtPassword->addEventListener(CC_CALLBACK_2(LoginPopup::onInputPasswordEvent, this));
	m_txtEmail->onFocusChanged = CC_CALLBACK_2(LoginPopup::onLoseFocusInputUser, this);

	// Register user interactive handler
	m_btnLogin->addTouchEventListener   (CC_CALLBACK_2(LoginPopup::onTouchLoginBtn, this));
	m_btnForgotPW->addTouchEventListener(CC_CALLBACK_2(LoginPopup::onTouchForgotPwBtn, this));

	Button* background = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "background"));

    m_imgEmail = static_cast<ImageView*>(Helper::seekWidgetByName(background, "imgEmail"));
    m_imgPassword = static_cast<ImageView*>(Helper::seekWidgetByName(background, "imgPassword"));

	background->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchBackground, this));
	m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));

    m_txtEmail->setString(UserDefault::getInstance()->getStringForKey("email"));
    m_txtPassword->setString(UserDefault::getInstance()->getStringForKey("password"));
    m_chkSave->setSelected(UserDefault::getInstance()->getBoolForKey("save"));
    setLightPosition();
	fadeInContent();
}

void LoginPopup::onClose()
{
	BasePopup::onClose();
}

void LoginPopup::onLoseFocusInputUser(Widget* lastWidget, Widget* nextWidget)
{
	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->openPopup(new AlertPopup("well well"));
}


void LoginPopup::onInputUserEvent(Ref* sender, TextField::EventType type)
{
	Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    auto seq = Sequence::create(FadeTo::create(0.5f, 0), FadeTo::create(0.5f, 255), nullptr);
	switch (type)
	{
		case TextField::EventType::ATTACH_WITH_IME:
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 - 20));
			m_pLayout->runAction(moveAct);
            m_imgEmail->runAction(RepeatForever::create(seq));
			break;
		case TextField::EventType::DETACH_WITH_IME:
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
			m_pLayout->runAction(moveAct);
            m_imgEmail->stopAllActions();
            m_imgEmail->setOpacity(255);
            m_txtPassword->attachWithIME();
			break;
	}
}

void LoginPopup::onInputPasswordEvent(Ref* sender, TextField::EventType type)
{
	Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    auto seq = Sequence::create(FadeTo::create(0.5f, 0), FadeTo::create(0.5f, 255), nullptr);
	switch (type)
	{
	case TextField::EventType::ATTACH_WITH_IME:
		m_pLayout->stopAllActions();
		moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 - 20));
		m_pLayout->runAction(moveAct);
        m_imgPassword->runAction(RepeatForever::create(seq));
		break;
	case TextField::EventType::DETACH_WITH_IME:
        UserDefault::getInstance()->setStringForKey("form_login_password", m_txtPassword->getString());
		m_pLayout->stopAllActions();
		moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
		m_pLayout->runAction(moveAct);
        m_imgPassword->stopAllActions();
        m_imgPassword->setOpacity(255);
		break;
	case TextField::EventType::INSERT_TEXT:
		break;
	default:
		break;
	}
}

void LoginPopup::onTouchLoginBtn(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;

	if (m_txtEmail->getString() == "" || m_txtPassword->getString() == "")
	{
		return;
	}
    bool  save = m_chkSave->isSelected();
    if(save)
    {
        UserDefault::getInstance()->setStringForKey("email", m_txtEmail->getString().c_str());
        UserDefault::getInstance()->setStringForKey("password", m_txtPassword->getString().c_str());
        UserDefault::getInstance()->setBoolForKey("save", save);
    }
	LoginHandler::getInstance()->signIn(m_txtEmail->getString().c_str(), m_txtPassword->getString().c_str());
}

void LoginPopup::onTouchSignUpBtn(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;

	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closeAllPopups();
	scene->openPopup(new SignUpPopup());
}
void LoginPopup::onTouchForgotPwBtn(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closeAllPopups();
	scene->openPopup(new ForgotPWPopup());
}

void LoginPopup::onTouchInputUsername(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
	m_txtEmail->attachWithIME();
}

void LoginPopup::onTouchInputPassword(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
	m_txtPassword->attachWithIME();
}
