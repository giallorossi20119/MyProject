//
//  RegisterPopup.cpp
//  IndoGame
//
//  Created by longnh on 8/7/14.
//
//
#include "RegisterPopup.h"
#include "LoginHandler.h"

std::string RegisterPopup::ON_CONFIRM = "confirm";
std::string RegisterPopup::ON_CANCEL = "cancel";


RegisterPopup::RegisterPopup()
{
}

RegisterPopup::RegisterPopup(std::string sMsr)
{
	m_sMsr = sMsr;
}

RegisterPopup::~RegisterPopup()
{
}

RegisterPopup* RegisterPopup::create()
{
	RegisterPopup* popup = new RegisterPopup();
	popup->autorelease();
	return popup;
}
RegisterPopup* RegisterPopup::create(std::string sMsr)
{
	RegisterPopup* popup = new RegisterPopup(sMsr);
	popup->autorelease();
	return popup;
}

void RegisterPopup::onOpen()
{
	BasePopup::onOpen();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("RegisterPopup.json"));
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
	this->addChild(m_pLayout);
	auto background = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"));
    m_imgEmail = static_cast<ImageView*>(Helper::seekWidgetByName(background, "imgEmail"));
    m_imgPassword = static_cast<ImageView*>(Helper::seekWidgetByName(background, "imgPassword"));
    m_imgRePassword = static_cast<ImageView*>(Helper::seekWidgetByName(background, "imgRePassword"));

    m_bmfTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTitle"));
    m_lblMessage  = static_cast<Text*>(Helper::seekWidgetByName(m_pLayout, "lblMessage"));
    m_lblMessage->setVisible(false);
	m_btnCancel = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCancel"));
	m_btnCancel->addTouchEventListener(CC_CALLBACK_2(RegisterPopup::onTouchCancel, this));
	m_btnConfirm = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnRegister"));
	m_btnConfirm->addTouchEventListener(CC_CALLBACK_2(RegisterPopup::onTouchConfirm, this));
	m_txtEmail = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtEmail"));
    m_txtPassword = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtPassword"));
    m_txtRePassword = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtRePassword"));

    string email = UserDefault::getInstance()->getStringForKey("form_update_email");
    if(strcmp(email.c_str(), "") != 0)
    {
        m_txtEmail->setString(email);
    }
    string password = UserDefault::getInstance()->getStringForKey("form_update_password");
    if(strcmp(password.c_str(), "") != 0)
    {
        m_txtPassword->setString(password);
    }
    string repassword = UserDefault::getInstance()->getStringForKey("form_update_repassword");
    if(strcmp(repassword.c_str(), "") != 0)
    {
        m_txtPassword->setString(repassword);
    }
    m_txtEmail->addEventListener(CC_CALLBACK_2(RegisterPopup::onInputEmailEvent, this));
	m_txtPassword->addEventListener(CC_CALLBACK_2(RegisterPopup::onInputPasswordEvent, this));
	m_txtRePassword->addEventListener(CC_CALLBACK_2(RegisterPopup::onInputRepasswordEvent, this));

	fadeInContent();
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(RegisterPopup::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    setTextLanguage();
    setLightPosition();
}

void RegisterPopup::onClose()
{
	BasePopup::onClose();
}

void RegisterPopup::onTouchCancel(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(RegisterPopup::ON_CANCEL);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closePopup(this);
}

void RegisterPopup::onTouchConfirm(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(RegisterPopup::ON_CONFIRM);
    if(std::strcmp(m_txtEmail->getString().c_str(), "") == 0)
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Email can't empty");
        return;
    }

    if(!TTutil::isValidEmailAddress(m_txtEmail->getString().c_str()))
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Email not valid");
        return;
    }

    if((m_txtPassword->getString().length() < 6) || (m_txtPassword->getString().length() > 20))
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Length of Password must from 6 to 20 characters or empty");
        return;
    }

    if(std::strcmp(m_txtPassword->getString().c_str(), m_txtRePassword->getString().c_str()) != 0)
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Password does not match");
        return;
    }
    LoginHandler::getInstance()->signUp(m_txtEmail->getString(), m_txtPassword->getString());
}

void RegisterPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void RegisterPopup::setTextLanguage()
{
    m_bmfTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
    m_btnCancel->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
    m_btnConfirm->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
}

void RegisterPopup::onInputEmailEvent(Ref* sender, TextField::EventType type)
{
    Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    auto rep = RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 0), FadeTo::create(0.5f, 255), nullptr));
	switch (type)
	{
		case TextField::EventType::ATTACH_WITH_IME:
			m_pLayout->stopAllActions();
            m_imgEmail->runAction(rep);
            m_imgPassword->stopAllActions();
            m_imgRePassword->stopAllActions();
			//moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 - 20));
			//m_pLayout->runAction(moveAct);
			break;
		case TextField::EventType::DETACH_WITH_IME:
            m_imgEmail->stopAllActions();
            m_imgEmail->setOpacity(255);
            UserDefault::getInstance()->setStringForKey("form_update_email", m_txtEmail->getString());
			m_pLayout->stopAllActions();
			//moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
			//m_pLayout->runAction(moveAct);
            m_txtPassword->attachWithIME();
			break;
	}
}

void RegisterPopup::onInputPasswordEvent(Ref* sender, TextField::EventType type)
{
    Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    auto rep = RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 0), FadeTo::create(0.5f, 255), nullptr));
	switch (type)
	{
		case TextField::EventType::ATTACH_WITH_IME:
			m_pLayout->stopAllActions();
            m_imgPassword->runAction(rep);
            m_imgEmail->stopAllActions();
            m_imgRePassword->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2));
			m_pLayout->runAction(moveAct);
			break;
		case TextField::EventType::DETACH_WITH_IME:
            m_imgPassword->stopAllActions();
            m_imgPassword->setOpacity(255);
            UserDefault::getInstance()->setStringForKey("form_update_password", m_txtPassword->getString());
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
			m_pLayout->runAction(moveAct);
            m_txtRePassword->attachWithIME();
			break;
	}
}

void RegisterPopup::onInputRepasswordEvent(Ref* sender, TextField::EventType type)
{
    Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    auto rep = RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 0), FadeTo::create(0.5f, 255), nullptr));
	switch (type)
	{
		case TextField::EventType::ATTACH_WITH_IME:
			m_pLayout->stopAllActions();
            m_imgRePassword->runAction(rep);
            m_imgEmail->stopAllActions();
            m_imgPassword->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 + 20));
			m_pLayout->runAction(moveAct);
			break;
		case TextField::EventType::DETACH_WITH_IME:
            m_imgRePassword->stopAllActions();
            m_imgRePassword->setOpacity(255);
            UserDefault::getInstance()->setStringForKey("form_update_repassword", m_txtRePassword->getString());
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
			m_pLayout->runAction(moveAct);
			break;
	}
}
