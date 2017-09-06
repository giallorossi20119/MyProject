//
//  ChangeNamePopup.cpp
//  Gameloe
//
//  Created by Rainy on 8/7/14.
//
//
#include "ChangeNamePopup.h"
#include "ALertPopup.h"
#include "LoginHandler.h"
#include "RegisterPopup.h"

std::string ChangeNamePopup::ON_CONFIRM = "confirm";
std::string ChangeNamePopup::ON_CANCEL = "cancel";


ChangeNamePopup::ChangeNamePopup()
{
}

ChangeNamePopup::ChangeNamePopup(std::string sMsr)
{
	m_sMsr = sMsr;
}

ChangeNamePopup::~ChangeNamePopup()
{
}

ChangeNamePopup* ChangeNamePopup::create()
{
	ChangeNamePopup* popup = new ChangeNamePopup();
	popup->autorelease();
	return popup;
}

ChangeNamePopup* ChangeNamePopup::create(std::string sMsr)
{
	ChangeNamePopup* popup = new ChangeNamePopup(sMsr);
	popup->autorelease();
	return popup;
}

void ChangeNamePopup::onOpen()
{
	BasePopup::onOpen();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("EditNamePopup.json"));
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
	this->addChild(m_pLayout);

    m_bmfTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTitle"));
    m_lblMessage = static_cast<Text*>(Helper::seekWidgetByName(m_pLayout, "lblMessage"));
    m_lblMessage->setVisible(false);
	m_btnCancel = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCancel"));
	m_btnCancel->addTouchEventListener(CC_CALLBACK_2(ChangeNamePopup::onTouchCancel, this));
	m_btnConfirm = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnChange"));
	m_btnConfirm->addTouchEventListener(CC_CALLBACK_2(ChangeNamePopup::onTouchConfirm, this));
	m_txtNewName = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtNewName"));
    m_txtNewName->setString(GlobalVariable::getInstance()->m_pUser->m_sName);
    m_txtNewName->addEventListener(CC_CALLBACK_2(ChangeNamePopup::onInputUsernameEvent, this));
	fadeInContent();
    setTextLanguage();
    setLightPosition();
}

void ChangeNamePopup::onClose()
{
	BasePopup::onClose();
    CCLOG("ChangeNamePopup::onClose");
    //RegisterPopup* rpu = RegisterPopup::create();
    //BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    //scene->openPopup(rpu);
}

void ChangeNamePopup::onTouchCancel(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(ChangeNamePopup::ON_CANCEL);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closePopup(this);
}

void ChangeNamePopup::onTouchConfirm(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;
    m_txtNewName->setDetachWithIME(true);
	getSpecialEventDispatcher()->dispatchCustomEvent(ChangeNamePopup::ON_CONFIRM);
    if((m_txtNewName->getString().length() < 6) || (m_txtNewName->getString().length() > 20))
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Length of Name must from 6 to 20 characters or empty");
        return;
    }
    if(strcmp(m_txtNewName->getString().c_str(), GlobalVariable::m_pUser->m_sName.c_str()) == 0)
    {
        m_lblMessage->setVisible(true);
        m_lblMessage->setString("Please choose other name!");
        return;
    }
    LoginHandler::getInstance()->requestChangeName(m_txtNewName->getString());
}

void ChangeNamePopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void ChangeNamePopup::onInputUsernameEvent(Ref* sender, TextField::EventType type)
{
	Size deviceSize = Director::getInstance()->getWinSize();
	Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
	MoveTo* moveAct = 0;
    switch (type)
	{
		case TextField::EventType::ATTACH_WITH_IME:
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 - 110));
			m_pLayout->runAction(moveAct);
			break;
		case TextField::EventType::DETACH_WITH_IME:
			m_pLayout->stopAllActions();
			moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
			m_pLayout->runAction(moveAct);
            //m_txtNewName->setDetachWithIME(false);
			break;
	}
}

void ChangeNamePopup::setTextLanguage()
{
    m_bmfTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
    //m_btnCancel->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
    //m_btnConfirm->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
}
/* END PRAGMA EVENT HANDLERS FUNCTIONS					     */
