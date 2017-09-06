//
//  SettingRoomPopup.cpp
//  IndoGame
//
//  Created by longnh on 16/9/14.
//
//
#include "SettingRoomPopup.h"


SettingRoomPopup::SettingRoomPopup(CMDMinMaxStake* _stake, int _m_iCurStake, int times, bool bFirst)
{
    m_pStake = _stake;
    m_iCurTime = times;
    m_iCurStake = _m_iCurStake;
    
    stepStake = 1000;
    m_bFirst = bFirst;
}

SettingRoomPopup::~SettingRoomPopup()
{
}

//SettingRoomPopup* SettingRoomPopup::create()
//{
//	SettingRoomPopup* popup = new SettingRoomPopup();
//	popup->autorelease();
//	return popup;
//}

void SettingRoomPopup::onOpen()
{
    BasePopup::onOpen();
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kSettingRoomPopup));
    // Re-layout popup
    Size layoutSize = m_pLayout->getContentSize();
    Size deviceSize = Director::getInstance()->getWinSize();
    m_pLayout->setAnchorPoint(Vec2(0.5, 0.5));
    m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    this->addChild(m_pLayout);
    m_pChk2Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk2Players"));
    m_pChk3Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk3Players"));
    m_pChk4Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk4Players"));
    m_pChkTime10s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime10s"));
    m_pChkTime15s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime15s"));
//    m_pChkTime20s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime20s"));
    m_pSliderStake = static_cast<Slider*>(Helper::seekWidgetByName(m_pLayout, "sliderStake"));
    m_bmfStake = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfStake"));
    btnOk = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnOk"));
    btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnExit"));
    
    auto time1 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime1"));
    auto time2 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime2"));
//    auto time3 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime3"));
    if(GlobalVariable::m_iCurrentGame == 0)
    {
        time1->setString("10s");
        time2->setString("15s");
//        time3->setString("20s");
    }
    else
    {
        time1->setString("30s");
        time2->setString("60s");
//        time3->setString("90s");
    }
    btnOk->addTouchEventListener(CC_CALLBACK_2(SettingRoomPopup::requestChangeSetting, this));
    btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    
    m_pSliderStake->addEventListener(CC_CALLBACK_2(SettingRoomPopup::sliderEvent, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pChkTime10s->addEventListener(CC_CALLBACK_2(SettingRoomPopup::chkTime10sSelectedEvent, this));
    m_pChkTime15s->addEventListener(CC_CALLBACK_2(SettingRoomPopup::chkTime15sSelectedEvent, this));
//    m_pChkTime20s->addEventListener(CC_CALLBACK_2(SettingRoomPopup::chkTime20sSelectedEvent, this));
    
    setTextLanguage();
    m_bmfStake->setString(ccsf("%d", m_iCurStake));
    setNumberPlayers(m_iCurPlayers);
    setNumberTime(m_iCurTime);
    //setStake(m_iCurStake);
    setDefaultSetting();
    setLightPosition();
}

void SettingRoomPopup::setDefaultSetting()
{
//    long leng = m_pStake->maxStake - m_pStake->minStake;
    m_pSliderStake->setPercent(100.0f);
    if(m_pStake==nullptr)
    {
        CCLOG("vao roi nhe");
        m_pStake= new CMDMinMaxStake();
        m_pStake->maxStake=50000;
        m_pStake->minStake=10000;
    }
    m_iCurStake = m_pStake->maxStake;
    m_bmfStake->setString(ccsf("%ld", m_pStake->maxStake));
    if(GlobalVariable::m_iCurrentGame == 0)
    {
        m_iCurTime = 10;
    }
    else
    {
        m_iCurTime = 30;
    }
    m_pChkTime10s->setSelected(true);
    m_pChkTime15s->setSelected(false);
//    m_pChkTime20s->setSelected(false);
}

void SettingRoomPopup::requestChangeSetting(Ref *pSender, Widget::TouchEventType type)
{
    if (type == Widget::TouchEventType::ENDED)
    {
        SFSConnection::getInstance()->requestChangeSettingRoom(m_iCurStake, m_iCurTime);
        BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
        scene->closeLastPopup();
    }
}

void SettingRoomPopup::closePopup(Ref *pSender, Widget::TouchEventType type)
{
    if (type == Widget::TouchEventType::ENDED)
    {
    }
}

void SettingRoomPopup::chkTime10sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChkTime10s->setSelected(true);
        m_pChkTime15s->setSelected(false);
//        m_pChkTime20s->setSelected(false);
        
        m_pChkTime10s->setEnabled(false);
        m_pChkTime15s->setEnabled(true);
//        m_pChkTime20s->setEnabled(true);
        if(GlobalVariable::m_iCurrentGame == 0)
        {
            m_iCurTime = 10;
        }
        else
        {
            m_iCurTime = 30;
        }
    }
}

void SettingRoomPopup::chkTime15sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChkTime10s->setSelected(false);
        m_pChkTime15s->setSelected(true);
//        m_pChkTime20s->setSelected(false);
        
        m_pChkTime10s->setEnabled(true);
        m_pChkTime15s->setEnabled(false);
//        m_pChkTime20s->setEnabled(true);
        if(GlobalVariable::m_iCurrentGame == 0)
        {
            m_iCurTime = 15;
        }
        else
        {
            m_iCurTime = 60;
        }
    }
}

void SettingRoomPopup::chkTime20sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChkTime10s->setSelected(false);
        m_pChkTime15s->setSelected(false);
//        m_pChkTime20s->setSelected(true);
        
        m_pChkTime10s->setEnabled(true);
        m_pChkTime15s->setEnabled(true);
//        m_pChkTime20s->setEnabled(false);
        if(GlobalVariable::m_iCurrentGame == 0)
        {
            m_iCurTime = 20;
        }
        else
        {
            m_iCurTime = 90;
        }
    }
}

void SettingRoomPopup::chk2PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChk2Players->setSelected(true);
        m_pChk3Players->setSelected(false);
        m_pChk4Players->setSelected(false);
        
        m_pChk4Players->setEnabled(true);
        m_pChk3Players->setEnabled(true);
        m_pChk2Players->setEnabled(false);
    }
}

void SettingRoomPopup::chk3PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChk3Players->setSelected(true);
        m_pChk2Players->setSelected(false);
        m_pChk4Players->setSelected(false);
        
        m_pChk4Players->setEnabled(true);
        m_pChk3Players->setEnabled(false);
        m_pChk2Players->setEnabled(true);
    }
}

void SettingRoomPopup::chk4PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChk4Players->setSelected(true);
        m_pChk2Players->setSelected(false);
        m_pChk3Players->setSelected(false);
        
        m_pChk4Players->setEnabled(false);
        m_pChk3Players->setEnabled(true);
        m_pChk2Players->setEnabled(true);
    }
}

void SettingRoomPopup::sliderEvent(Ref *pSender, Slider::EventType type)
{
    if (type == Slider::EventType::ON_PERCENTAGE_CHANGED)
    {
        int percent = m_pSliderStake->getPercent();
        int leng = m_pStake->maxStake - m_pStake->minStake;
        int stake = percent * leng / 100 + m_pStake->minStake;
        
        //calculate with step
        if (stake % stepStake != 0)
        {
            int sd = stake % stepStake;
            if (sd <= 500)
            {
                stake = stake - sd;
            }
            else
            {
                stake = stake - sd + 1000;
            }
            int newpercent = (stake - m_pStake->minStake) * 100 / leng;
            m_pSliderStake->setPercent(newpercent);
        }
        
        m_iCurStake = stake;
        setStake(stake);
    }
}

void SettingRoomPopup::setStake(int stake)
{
    m_bmfStake->setString(ccsf("%d", stake));
    CCLOG("setStake 1 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
    long leng = m_pStake->maxStake - m_pStake->minStake;
    
    if (leng == 0 || m_bFirst)
    {
        m_bFirst = false;
        m_pSliderStake->setPercent(100);
        CCLOG("setStake 2 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
        m_iCurStake = m_pStake->maxStake;
        m_bmfStake->setString(ccsf("%ld", m_pStake->maxStake));
        CCLOG("setStake 3 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
        if(GlobalVariable::m_iCurrentGame == 0)
        {
            m_iCurTime = 10;
        }
        else
        {
            m_iCurTime = 30;
        }
        CCLOG("setStake 4 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
        m_pChkTime10s->setSelected(true);
        m_pChkTime15s->setSelected(false);
//        m_pChkTime20s->setSelected(false);
        CCLOG("setStake 5 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
    }
    else
    {
        CCLOG("setStake 6 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
        int percent = (m_iCurStake - m_pStake->minStake) * 100 / leng;
        m_pSliderStake->setPercent(percent);
        CCLOG("setStake 7 %ld %ld", m_pStake->maxStake, m_pStake->minStake);
    }
}

void SettingRoomPopup::setNumberPlayers(int players)
{
    return;
    m_iCurPlayers = players;
    
    switch (players)
    {
        case 2:
            m_pChk2Players->setSelected(true);
            m_pChk3Players->setSelected(false);
            m_pChk4Players->setSelected(false);
            break;
        case 3:
            m_pChk2Players->setSelected(false);
            m_pChk3Players->setSelected(true);
            m_pChk4Players->setSelected(false);
            break;
        case 4:
            m_pChk2Players->setSelected(false);
            m_pChk3Players->setSelected(false);
            m_pChk4Players->setSelected(true);
            break;
        default:
            m_pChk2Players->setSelected(false);
            m_pChk3Players->setSelected(false);
            m_pChk4Players->setSelected(true);
            break;
    }
}

void SettingRoomPopup::setNumberTime(int times)
{
    m_iCurTime = times;
    
    switch (times)
    {
        case 10:
            m_pChkTime10s->setSelected(true);
            m_pChkTime15s->setSelected(false);
//            m_pChkTime20s->setSelected(false);
            break;
        case 15:
            m_pChkTime10s->setSelected(false);
            m_pChkTime15s->setSelected(true);
//            m_pChkTime20s->setSelected(false);
            break;
        case 20:
            m_pChkTime10s->setSelected(false);
            m_pChkTime15s->setSelected(false);
//            m_pChkTime20s->setSelected(true);
            break;
        case 30:
            m_pChkTime10s->setSelected(true);
            m_pChkTime15s->setSelected(false);
//            m_pChkTime20s->setSelected(false);
            break;
        case 60:
            m_pChkTime10s->setSelected(false);
            m_pChkTime15s->setSelected(true);
//            m_pChkTime20s->setSelected(false);
            break;
        case 90:
            m_pChkTime10s->setSelected(false);
            m_pChkTime15s->setSelected(false);
//            m_pChkTime20s->setSelected(true);
            break;
        default:
            m_pChkTime10s->setSelected(false);
            m_pChkTime15s->setSelected(false);
//            m_pChkTime20s->setSelected(true);
            break;
    }
}

void SettingRoomPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void SettingRoomPopup::setTextLanguage()
{
    TextBMFont* bmTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmTitle"));
    bmTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_SETTING));
    TextBMFont* bmOK = static_cast<TextBMFont*>(btnOk->getChildByName("bmOK"));
    bmOK->setString(ResourceManager::getInstance()->getTextByName(kTEXT_OK));
    TextBMFont* bmCancel = static_cast<TextBMFont*>(btnClose->getChildByName("bmCancel"));
    bmCancel->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
}
