//
//  ForgotPWPopup.cpp
//  Gameloe
//
//  Created by Rainy on 8/7/14.
//
//
#include "ForgotPWPopup.h"
#include "ALertPopup.h"

std::string ForgotPWPopup::ON_CONFIRM = "confirm";
std::string ForgotPWPopup::ON_CANCEL = "cancel";


ForgotPWPopup::ForgotPWPopup()
{
}

ForgotPWPopup::ForgotPWPopup(std::string sMsr)
{
	m_sMsr = sMsr;
}

ForgotPWPopup::~ForgotPWPopup()
{
}

ForgotPWPopup* ForgotPWPopup::create()
{
	ForgotPWPopup* popup = new ForgotPWPopup();
	popup->autorelease();
	return popup;
}

ForgotPWPopup* ForgotPWPopup::create(std::string sMsr)
{
	ForgotPWPopup* popup = new ForgotPWPopup(sMsr);
	popup->autorelease();
	return popup;
}

void ForgotPWPopup::onOpen()
{
	BasePopup::onOpen();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ForgotPWPopup.json"));
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
	this->addChild(m_pLayout);

    //m_bmfTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTitle"));
	m_btnCancel = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCancel"));
	m_btnCancel->addTouchEventListener(CC_CALLBACK_2(ForgotPWPopup::onTouchCancel, this));
	m_btnConfirm = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSend"));
	m_btnConfirm->addTouchEventListener(CC_CALLBACK_2(ForgotPWPopup::onTouchConfirm, this));
	m_txtEmail = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtEmail"));
    m_txtEmail->setString(UserDefault::getInstance()->getStringForKey("email"));
    m_txtEmail->addEventListener(CC_CALLBACK_2(ForgotPWPopup::onInputEmailEvent, this));
	fadeInContent();
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(ForgotPWPopup::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    setTextLanguage();
    setLightPosition();
}

void ForgotPWPopup::onClose()
{
	BasePopup::onClose();
}

void ForgotPWPopup::onTouchCancel(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;
    m_txtEmail->setDetachWithIME(false);
	getSpecialEventDispatcher()->dispatchCustomEvent(ForgotPWPopup::ON_CANCEL);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closePopup(this);
}

void ForgotPWPopup::onTouchConfirm(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(ForgotPWPopup::ON_CONFIRM);

    HttpRequest* request = new HttpRequest();
    std::string url = kURLGameloeDeviceID;
    string action = "forgotPassword";
    string email  = m_txtEmail->getString();
	std::string strRequestData =
    "action=" + action +
    "&email=" + email;

	request = new HttpRequest();
	request->setRequestType(HttpRequest::Type::POST);
	request->setRequestData(strRequestData.c_str(), strlen(strRequestData.c_str()));
	request->setResponseCallback(CC_CALLBACK_2(ForgotPWPopup::onResponseForgotPW, this));
	request->setUrl(kURLGameloeDeviceID);
	HttpClient::getInstance()->sendImmediate(request);
	request->release();
}

void ForgotPWPopup::onResponseForgotPW(HttpClient *sender, HttpResponse *response)
{
    if (!response)
    {
        return;
    }

    if(response->getResponseCode() == -1)
    {
        NotificationCenter::getInstance()->postNotification(EVENT_NETWORK_NOT_AVAILBLE, NULL);
        return;
    }
    //dump data

    std::vector<char>* l_v_buffer_data = response->getResponseData();

    int i = 0;
    while(l_v_buffer_data->at(i) != '{')
    {
        i++;
    }
    std::string l_s_data(l_v_buffer_data->begin() + i, l_v_buffer_data->end());
    rapidjson::Document document;
    document.Parse<0>(l_s_data.c_str());
    int status = document["status"].GetInt();
    std::string message = document["message"].GetString();
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    if(status == 0)
    {
        scene->openPopup(AlertPopup::create(message));
    }
    else
    {
        scene->closeAllPopups();
        scene->openPopup(AlertPopup::create("Please check your email to get new password!"));
    }
}

void ForgotPWPopup::onInputEmailEvent(Ref* sender, TextField::EventType type)
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
			break;
	}
}

void ForgotPWPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void ForgotPWPopup::setTextLanguage()
{
    //m_bmfTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
    //m_btnCancel->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
    //m_btnConfirm->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
}
/* END PRAGMA EVENT HANDLERS FUNCTIONS					     */
