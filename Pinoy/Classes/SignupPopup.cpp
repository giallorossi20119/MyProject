#include "SignupPopup.h"

SignUpPopup::SignUpPopup(){}
SignUpPopup::~SignUpPopup(){}

void SignUpPopup::onOpen()
{
    BasePopup::onOpen();
    
    // Get popup layout
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("SignupPopup.json"));
    
    // Re-layout popup
    Size layoutSize = m_pLayout->getContentSize();
    Size deviceSize = Director::getInstance()->getWinSize();
    m_pLayout->setAnchorPoint(Vec2(0.5, 0.5));
    m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    this->addChild(m_pLayout);
    
    // Get reference from UIs
    m_btnConfirm			= static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnConfirm"));
    m_btnBack               = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnBack"));
    m_inputUsername         = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "inputUsername"));
    m_inputPassword         = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "inputPassword"));
    m_inputConfirmPassword  = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "inputConfirmPassword"));
    m_inputEmail            = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "inputEmail"));
    m_textWarning			= static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "textWarning"));
    
    // Set text based on language
    m_btnConfirm->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM).c_str());
    m_btnBack->setTitleText   (ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL).c_str());
    m_btnConfirm->setTitleFontSize(24.0f);
    m_btnBack->setTitleFontSize   (24.0f);
    
    // Set place holder text input
    m_inputUsername->setEnabled		  (false);
    m_inputPassword->setEnabled       (false);
    m_inputConfirmPassword->setEnabled(false);
    m_inputEmail->setEnabled          (false);
    
    m_textWarning->setEnabled         (false);
    m_textWarning->setVisible		  (false);
    
    m_inputUsername->setTouchAreaEnabled (false);
    m_inputPassword->setTouchAreaEnabled(false);
    m_inputConfirmPassword->setTouchAreaEnabled(false);
    m_inputEmail->setTouchAreaEnabled(false);
    
    // Register IME event to move popup when soft input appear
    m_inputUsername->addEventListener		(CC_CALLBACK_2(SignUpPopup::onTextFieldEvent, this));
    m_inputPassword->addEventListener       (CC_CALLBACK_2(SignUpPopup::onTextFieldEvent, this));
    m_inputConfirmPassword->addEventListener(CC_CALLBACK_2(SignUpPopup::onTextFieldEvent, this));
    m_inputEmail->addEventListener          (CC_CALLBACK_2(SignUpPopup::onTextFieldEvent, this));
    
    // Register user interactive handler
    m_btnConfirm->addTouchEventListener(CC_CALLBACK_2(SignUpPopup::onTouchConfirmBtn, this));
    m_btnBack->addTouchEventListener   (CC_CALLBACK_2(SignUpPopup::onTouchBackBtn, this));
    
    Button* background = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "background"));
    background->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchBackground, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    
    // Add notifications from Network to response to user
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(SignUpPopup::onSignUpFailed), EVENT_NETWORK_SIGNUP_FAIL, nullptr);
    
    Button* bgInputUsername = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgInputUsername"));
    Button* bgInputPassWord = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgInputPassword"));
    Button* bgInputConfirmPassword = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgInputConfirmPassword"));
    Button* bgInputEmail = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgInputEmail"));
    
    bgInputUsername->addTouchEventListener(CC_CALLBACK_2(SignUpPopup::onTouchInputUsername, this));
    bgInputPassWord->addTouchEventListener(CC_CALLBACK_2(SignUpPopup::onTouchInputPassword, this));
    bgInputConfirmPassword->addTouchEventListener(CC_CALLBACK_2(SignUpPopup::onTouchInputConfirmPassword, this));
    bgInputEmail->addTouchEventListener(CC_CALLBACK_2(SignUpPopup::onTouchInputEmail, this));
    
    // Add effect
    fadeInContent();
}
void SignUpPopup::onClose()
{
    NotificationCenter::getInstance()->removeObserver(this, EVENT_NETWORK_SIGNUP_FAIL);
}

void SignUpPopup::onTouchConfirmBtn(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    // ---------------------------------------------------------
    // Verify input fields
    // ---------------------------------------------------------
    // All fields have filled?
    if (   m_inputUsername->getStringLength()		 == 0
        || m_inputPassword->getStringLength()        == 0
        || m_inputConfirmPassword->getStringLength() == 0
        || m_inputEmail->getStringLength()           == 0)
    {
        m_textWarning->setString("Please fill content all fileds!");
        m_textWarning->setVisible(true);
        return;
    }
    
    // Passworld ans confirm password and same?
    if (strcmp(m_inputPassword->getString().c_str(), m_inputConfirmPassword->getString().c_str()) != 0)
    {
        m_textWarning->setString("Passwords are not same!");
        m_textWarning->setVisible(true);
        return;
    }
    
    // Email fields is valid?
    if (!TTutil::isValidEmailAddress(m_inputEmail->getString().c_str()))
    {
        m_textWarning->setString("Email address is not valid!");
        m_textWarning->setVisible(true);
        return;
    }
    
//    LoginHandler::getInstance()->signUp(m_inputUsername->getString().c_str(), m_inputPassword->getString().c_str());
    
}

void SignUpPopup::onTouchBackBtn(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closeAllPopups();
    scene->openPopup(new LoginPopup());
}

void SignUpPopup::onTextFieldEvent(Ref* sender, TextField::EventType type)
{
    Size deviceSize = Director::getInstance()->getWinSize();
    Size popupSize = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "background"))->getContentSize();
    MoveTo* moveAct = 0;
    
    m_textWarning->setVisible(false);
    switch (type)
    {
        case TextField::EventType::ATTACH_WITH_IME:
            m_pLayout->stopAllActions();
            moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height - popupSize.height / 2 - 20));
            m_pLayout->runAction(moveAct);
            break;
        case TextField::EventType::DETACH_WITH_IME:
            m_pLayout->stopAllActions();
            moveAct = MoveTo::create(0.2f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
            m_pLayout->runAction(moveAct);
            break;
        default:
            break;
    }
}

void SignUpPopup::onSignUpFailed(Ref* sender)
{
    CCString* stringRef = static_cast<CCString*>(sender);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->openPopup(new AlertPopup(stringRef->getCString()));
}


void SignUpPopup::onTouchInputUsername(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    m_inputUsername->attachWithIME();
}

void SignUpPopup::onTouchInputPassword(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    m_inputPassword->attachWithIME();
}

void SignUpPopup::onTouchInputConfirmPassword(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    m_inputConfirmPassword->attachWithIME();
}

void SignUpPopup::onTouchInputEmail(Ref* sender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    m_inputEmail->attachWithIME();
}
