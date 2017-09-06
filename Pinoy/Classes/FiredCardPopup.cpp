#include "FiredCardPopup.h"
#include "CMDTongitsData.h"
#include "Card.h"
#include "GlobalVariable.h"
#include "TongitsGameScene.h"

FiredCardPopup::FiredCardPopup()
{
}

FiredCardPopup::~FiredCardPopup()
{
}

FiredCardPopup* FiredCardPopup::create()
{
    FiredCardPopup* popup = new FiredCardPopup();
    popup->autorelease();
    return popup;
}

void FiredCardPopup::fillData()
{
    Layout* pnlCard = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "PnlFiredCard"));
    CCLOG("Phase5");
    if(GlobalVariable::getInstance()->m_vFiredCards->size()==0)
    {
        CCLOG("Phase61");
    }
    else
    {
        for(int i=0;i<GlobalVariable::getInstance()->m_vFiredCards->size();i++)
        {
            CCLOG("Phase62");
            Card* card = Card::create(GlobalVariable::getInstance()->m_vFiredCards->at(i)->m_iId);
            card->setScale(0.5f);
            card->setPosition(Vec2(i * 30, 50));
            card->setAnchorPoint(Vec2(0,0));
            card->setState(CardState::kCardStateKicked);
            pnlCard->addChild(card);
            CCLOG("Phase7");
        }
    }
}

void FiredCardPopup::onOpen()
{
    CCLOG("Phase1");
	BasePopup::onOpen();

	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kFiredCardPopup));
	this->addChild(m_pLayout);
    CCLOG("Phase2");
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    CCLOG("Phase3");
	Button* btnExit = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
	btnExit->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    CCLOG("Phase4");
	fillData();
}
void FiredCardPopup::onClose()
{
	BasePopup::onClose();
}