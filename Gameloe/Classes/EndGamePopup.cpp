//
//  EndGamePopup.cpp
//  IndoGame
//
//  Created by longnh on 10/08/14.
//
//

#include "EndGamePopup.h"
#include "CMDBantingData.h"
#include "Card.h"
#include "GlobalVariable.h"

EndGamePopup::EndGamePopup()
{
}


EndGamePopup::~EndGamePopup()
{
}

void EndGamePopup::fillData()
{
	vector<CMDFinishData*>* vCMDFinishData = GlobalVariable::m_vCMDFinishData;
	if (!vCMDFinishData) return;
	int si = vCMDFinishData->size();
	if (si == 0) return;

	Layout* pnlMain = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlMain"));
	for (int i = 0; i < si; i++)
	{
		CMDFinishData* data = vCMDFinishData->at(i);
		Layout* pnli = static_cast<Layout*>(Helper::seekWidgetByName(pnlMain, ccsf("pnlRow%d", i + 1)));
		TextField* txtName = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtName"));
		TextField* txtMoney = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtMoney"));
        Text* txtDes = static_cast<Text*>(Helper::seekWidgetByName(pnli, "lblDes"));
        txtDes->setVisible(false);
		Layout* pnlCard = static_cast<Layout*>(Helper::seekWidgetByName(pnli, "pnlCards"));

		txtName->setString(data->m_sName);
		txtMoney->setString(TTutil::addDot(ccsf("%1.0f", data->m_dChangeMoney)));

		if (data->m_vCardsIdRemain->size() > 0)
		{
			for (int i = 0; i < data->m_vCardsIdRemain->size(); i++)
			{
				Card* card = Card::create(data->m_vCardsIdRemain->at(i));
				card->setScale(0.3f);
				card->setPosition(Vec2(i * 20, 0));
				card->setAnchorPoint(Vec2(0,0));
				pnlCard->addChild(card);
			}
		}
		pnli->setVisible(true);
	}
}

void EndGamePopup::fillDataSS()
{
	vector<SSCMDUserEndViewData*>* vSSCMDUserEndViewData = GlobalVariable::m_vSSCMDUserEndViewData;
	if (!vSSCMDUserEndViewData) return;
	int si = vSSCMDUserEndViewData->size();
	if (si == 0) return;

	Layout* pnlMain = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlMain"));
	for (int i = 0; i < si; i++)
	{
		SSCMDUserEndViewData* data = vSSCMDUserEndViewData->at(i);
		Layout* pnli = static_cast<Layout*>(Helper::seekWidgetByName(pnlMain, ccsf("pnlRow%d", i + 1)));
		TextField* txtName = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtName"));
		TextField* txtMoney = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtMoney"));
        Text* txtDes = static_cast<Text*>(Helper::seekWidgetByName(pnli, "lblDes"));
		Layout* pnlCard = static_cast<Layout*>(Helper::seekWidgetByName(pnli, "pnlCards"));
        pnlCard->setVisible(false);
        if(data->m_sName.length() < 16)
        {
            txtName->setString(data->m_sName);
        }
        else
        {
            txtName->setString(data->m_sName.substr(0, 16));
        }
		txtMoney->setString(TTutil::addDot(ccsf("%1.0f", data->m_dMoneyChanged)));
        txtDes->setString(data->m_sDes);
		pnli->setVisible(true);
	}
}

void EndGamePopup::onOpen()
{
    BasePopup::onOpen();
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kEndGamePopup));
	this->addChild(m_pLayout);

	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    TextBMFont* bmTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmTitle"));
	Button* btnExit = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnExit"));
	btnExit->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    if(GlobalVariable::m_iCurrentGame == 0)
    {
        fillData();
    }
    else
    {
        fillDataSS();
    }
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(EndGamePopup::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    setTextLanguage();
    setLightPosition();
}
void EndGamePopup::onClose()
{
	BasePopup::onClose();
}


void EndGamePopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void EndGamePopup::setTextLanguage()
{
    TextBMFont* bmTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmTitle"));
    bmTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_RESULTS));
	Button* btnExit = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnExit"));
    TextBMFont* bmClose = static_cast<TextBMFont*>(btnExit->getChildByName("bmClose"));
    bmClose->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CLOSE));
}
