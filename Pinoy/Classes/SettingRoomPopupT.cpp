#include "SettingRoomPopupT.h"

SettingRoomPopupT::SettingRoomPopupT(CMDMinMaxStakeT* _stake, int _m_iCurStake, int times, bool bFirst)
{
    m_pStakeT = _stake;
    m_iCurTime = times;
    m_iCurStake = _m_iCurStake;
    
    stepStake = 1000;
    m_bFirst = bFirst;
}

SettingRoomPopupT::~SettingRoomPopupT()
{
}

//SettingRoomPopup* SettingRoomPopup::create()
//{
//	SettingRoomPopup* popup = new SettingRoomPopup();
//	popup->autorelease();
//	return popup;
//}

void SettingRoomPopupT::onOpen()
{
    BasePopup::onOpen();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kSettingRoomPopupT));
	// Re-layout popup
	Size layoutSize = m_pLayout->getContentSize();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5, 0.5));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
	this->addChild(m_pLayout);
	m_pChk2Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk2Players"));
	m_pChk3Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk3Players"));
	m_pChk4Players = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chk4Players"));
	m_pChkTime15s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime15s"));
	m_pChkTime20s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime20s"));
	m_pChkTime30s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime30s"));
    m_pChkTime40s = static_cast<CheckBox*>(Helper::seekWidgetByName(m_pLayout, "chkTime40s"));
	m_pSliderStake = static_cast<Slider*>(Helper::seekWidgetByName(m_pLayout, "sliderStake"));
	m_bmfStake = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfStake"));
	btnOk = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnOk"));
	btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnExit"));

    auto time1 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime1"));
    auto time2 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime2"));
    auto time3 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime3"));
    auto time4 = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTime4"));
    if(GlobalVariable::m_iCurrentGame == 2)
    {
        time1->setString("15s");
        time2->setString("20s");
        time3->setString("30s");
        time4->setString("40s");
    }
    else
    {
        time1->setString("30s");
        time2->setString("40s");
        time3->setString("60s");
        time4->setString("90s");
    }
	btnOk->addTouchEventListener(CC_CALLBACK_2(SettingRoomPopupT::requestChangeSetting, this));
	btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));

	m_pSliderStake->addEventListener(CC_CALLBACK_2(SettingRoomPopupT::sliderEvent, this));
	m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
	m_pChkTime15s->addEventListener(CC_CALLBACK_2(SettingRoomPopupT::chkTime15sSelectedEvent, this));
	m_pChkTime20s->addEventListener(CC_CALLBACK_2(SettingRoomPopupT::chkTime20sSelectedEvent, this));
	m_pChkTime30s->addEventListener(CC_CALLBACK_2(SettingRoomPopupT::chkTime30sSelectedEvent, this));
    m_pChkTime40s->addEventListener(CC_CALLBACK_2(SettingRoomPopupT::chkTime40sSelectedEvent, this));
    setTextLanguage();
	m_bmfStake->setString(ccsf("%d", m_iCurStake));
	setNumberPlayers(m_iCurPlayers);
	setNumberTime(m_iCurTime);
	setStake(m_iCurStake);
    setLightPosition();
}

void SettingRoomPopupT::requestChangeSetting(Ref *pSender, Widget::TouchEventType type)
{
	if (type == Widget::TouchEventType::ENDED)
	{
		SFSConnection::getInstance()->requestChangeSettingRoom(m_iCurStake, m_iCurTime);
		BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
		scene->closeLastPopup();
	}
}

void SettingRoomPopupT::closePopup(Ref *pSender, Widget::TouchEventType type)
{
	if (type == Widget::TouchEventType::ENDED)
	{
	}
}

void SettingRoomPopupT::chkTime15sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
	if (type == CheckBox::EventType::SELECTED)
	{
		m_pChkTime15s->setSelected(true);
		m_pChkTime20s->setSelected(false);
		m_pChkTime30s->setSelected(false);
        m_pChkTime40s->setSelected(false);

		m_pChkTime15s->setEnabled(false);
		m_pChkTime20s->setEnabled(true);
		m_pChkTime30s->setEnabled(true);
        m_pChkTime40s->setEnabled(true);
        if(GlobalVariable::m_iCurrentGame == 2)
        {
            m_iCurTime = 15;
        }
	}
}

void SettingRoomPopupT::chkTime20sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
	{
		m_pChkTime15s->setSelected(false);
		m_pChkTime20s->setSelected(true);
		m_pChkTime30s->setSelected(false);
        m_pChkTime40s->setSelected(false);

		m_pChkTime15s->setEnabled(true);
		m_pChkTime20s->setEnabled(false);
		m_pChkTime30s->setEnabled(true);
        m_pChkTime40s->setEnabled(true);
        if(GlobalVariable::m_iCurrentGame == 2)
        {
            m_iCurTime = 20;
        }
	}
}

void SettingRoomPopupT::chkTime30sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
	if (type == CheckBox::EventType::SELECTED)
	{
        m_pChkTime15s->setSelected(false);
        m_pChkTime20s->setSelected(false);
        m_pChkTime30s->setSelected(true);
        m_pChkTime40s->setSelected(false);
        
        m_pChkTime15s->setEnabled(true);
        m_pChkTime20s->setEnabled(true);
        m_pChkTime30s->setEnabled(false);
        m_pChkTime40s->setEnabled(true);
        if(GlobalVariable::m_iCurrentGame == 2)
        {
            m_iCurTime = 30;
        }
	}
}

void SettingRoomPopupT::chkTime40sSelectedEvent(Ref* pSender, CheckBox::EventType type)
{
    if (type == CheckBox::EventType::SELECTED)
    {
        m_pChkTime15s->setSelected(false);
        m_pChkTime20s->setSelected(false);
        m_pChkTime30s->setSelected(false);
        m_pChkTime40s->setSelected(true);
        
        m_pChkTime15s->setEnabled(true);
        m_pChkTime20s->setEnabled(true);
        m_pChkTime30s->setEnabled(true);
        m_pChkTime40s->setEnabled(false);
        if(GlobalVariable::m_iCurrentGame == 2)
        {
            m_iCurTime = 40;
        }
    }
}

void SettingRoomPopupT::chk2PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
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

void SettingRoomPopupT::chk3PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
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

void SettingRoomPopupT::chk4PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type)
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

void SettingRoomPopupT::sliderEvent(Ref *pSender, Slider::EventType type)
{
	if (type == Slider::EventType::ON_PERCENTAGE_CHANGED)
	{
		int percent = m_pSliderStake->getPercent();
		int leng = m_pStakeT->maxStake - m_pStakeT->minStake;
		int stake = percent * leng / 100 + m_pStakeT->minStake;

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
			int newpercent = (stake - m_pStakeT->minStake) * 100 / leng;
			m_pSliderStake->setPercent(newpercent);
		}

		m_iCurStake = stake;
		setStake(stake);
	}
}

void SettingRoomPopupT::setStake(int stake)
{
    m_bmfStake->setString(ccsf("%d", stake));
    CCLOG("setStake 1 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
    int leng = m_pStakeT->maxStake - m_pStakeT->minStake;
    if (leng == 0 || m_bFirst)
    {
        m_bFirst = false;
        m_pSliderStake->setPercent(100);
        CCLOG("setStake 2 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
        m_iCurStake = m_pStakeT->maxStake;
        m_bmfStake->setString(ccsf("%ld", m_pStakeT->maxStake));
        CCLOG("setStake 3 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
        if(GlobalVariable::m_iCurrentGame == 2)
        {
            m_iCurTime = 30;
        }
        CCLOG("setStake 4 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
        m_pChkTime15s->setSelected(false);
        m_pChkTime20s->setSelected(false);
        m_pChkTime30s->setSelected(true);
        m_pChkTime40s->setSelected(false);
        CCLOG("setStake 5 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
    }
    else
    {
        CCLOG("setStake 6 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
        int percent = (m_iCurStake - m_pStakeT->minStake) * 100 / leng;
        m_pSliderStake->setPercent(percent);
        CCLOG("setStake 7 %ld %ld", m_pStakeT->maxStake, m_pStakeT->minStake);
    }
}

void SettingRoomPopupT::setNumberPlayers(int players)
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

void SettingRoomPopupT::setNumberTime(int times)
{
	m_iCurTime = times;

	switch (times)
	{
        case 15:
            m_pChkTime15s->setSelected(true);
            m_pChkTime20s->setSelected(false);
            m_pChkTime30s->setSelected(false);
            m_pChkTime40s->setSelected(false);
            break;
        case 20:
            m_pChkTime15s->setSelected(false);
            m_pChkTime20s->setSelected(true);
            m_pChkTime30s->setSelected(false);
            m_pChkTime40s->setSelected(false);
            break;
        case 30:
            m_pChkTime15s->setSelected(false);
            m_pChkTime20s->setSelected(false);
            m_pChkTime30s->setSelected(true);
            m_pChkTime40s->setSelected(false);
            break;
        case 40:
            m_pChkTime15s->setSelected(false);
            m_pChkTime20s->setSelected(false);
            m_pChkTime30s->setSelected(false);
            m_pChkTime30s->setSelected(true);
            break;
        default:
            m_pChkTime15s->setSelected(false);
            m_pChkTime20s->setSelected(false);
            m_pChkTime30s->setSelected(false);
            m_pChkTime40s->setSelected(true);
            break;
	}
}

void SettingRoomPopupT::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void SettingRoomPopupT::setTextLanguage()
{
    TextBMFont* bmTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmTitle"));
    bmTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_SETTING));
    TextBMFont* bmOK = static_cast<TextBMFont*>(btnOk->getChildByName("bmOK"));
    bmOK->setString(ResourceManager::getInstance()->getTextByName(kTEXT_OK));
    TextBMFont* bmCancel = static_cast<TextBMFont*>(btnClose->getChildByName("bmCancel"));
    bmCancel->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
}