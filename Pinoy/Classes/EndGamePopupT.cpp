#include "EndGamePopupT.h"
#include "CMDTongitsData.h"
#include "Card.h"
#include "GlobalVariable.h"

EndGamePopupT::EndGamePopupT()
{
}

EndGamePopupT::~EndGamePopupT()
{
}

EndGamePopupT* EndGamePopupT::create()
{
    EndGamePopupT* popup = new EndGamePopupT();
    popup->autorelease();
    return popup;
}

void EndGamePopupT::fillData()
{
    CCLOG("endgame1");
	vector<CMDFinishDataT*>* vCMDFinishData = GlobalVariable::m_vCMDFinishDataT;

	if (!vCMDFinishData) return;
	int si = (int)vCMDFinishData->size();
	if (si == 0) return;

	Layout* pnlMain = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlMain"));
    CCLOG("endgame2");
    for (int i = 0; i < si; i++)
    {
        CCLOG("endgame3");
        CMDFinishDataT* data = vCMDFinishData->at(i);
        Layout* pnli = static_cast<Layout*>(Helper::seekWidgetByName(pnlMain, ccsf("pnlRow%d", i + 1)));
        TextField* txtName = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtName"));
        TextField* txtMoney = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtMoney"));
        TextField* txtStatus = static_cast<TextField*>(Helper::seekWidgetByName(pnli, "txtStatus"));
        TextField* txtPoint = static_cast<TextField*>(Helper::seekWidgetByName(pnli,"txtPoint"));
        Layout* pnlCard = static_cast<Layout*>(Helper::seekWidgetByName(pnli, "pnlCards"));
        
        if(data->m_sName.length() > 11)
        {
            txtName->setString(ccsf("%s..",data->m_sName.substr(0, 10).c_str()));
        }
        else
        {
            txtName->setString(data->m_sName.c_str());
        }
        
        txtMoney->setString(ccsf("%1.0f", data->m_dMoney));
        txtPoint->setString(ccsf("%d (Points)", data->m_sPoint));
        CCLOG("endgame4");
        
        for (int j=0; j<data->m_vLogs->size(); j++)
        {
            result[j] = static_cast<TextField*>(Helper::seekWidgetByName(pnli, ccsf("tfResult%d",j)));
            result[j]->setString("");
            result[j]->setString(data->m_vLogs->at(j));
        }
        
        for (int k=0; k<data->m_vPoints->size(); k++)
        {
            bet[k] = static_cast<TextField*>(Helper::seekWidgetByName(pnli, ccsf("tfBet%d",k)));
            bet[k]->setString("");
            bet[k]->setString(ccsf("%hd",data->m_vPoints->at(k)));
        }

        if(data->m_dMoney>0)
        {
            if (data->m_bU)
            {
                txtStatus->setString("TONGITS");
            }
            else
            {
                txtStatus->setString("WIN");
            }
        }
        else
        {
            txtStatus->setString("LOSE");
        }
        
        if (data->m_vQue->size() > 0)
        {
            for (int i = 0; i < data->m_vQue->size(); i++)
            {
                CCLOG("endgame8");
                Card* card = Card::create(data->m_vQue->at(i));
                card->setScale(0.25f);
                card->setPosition(Vec2(i * 20, 0));
                card->setAnchorPoint(Vec2(0,0));
                card->setState(CardState::kCardStateKicked);
                pnlCard->addChild(card);
            }
        }
        pnli->setVisible(true);
    }
}

void EndGamePopupT::onOpen()
{
	BasePopup::onOpen();

	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kEndGamePopupT));
	this->addChild(m_pLayout);

	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));

	Button* btnExit = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnExit"));
	btnExit->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));

	fillData();
}
void EndGamePopupT::onClose()
{
	BasePopup::onClose();
}