#include "DailyBonusPopup.h"
#include "TTutil.h"
#include "GlobalVariable.h"
#include "IAPHandler.h"

DailyBonusPopup::DailyBonusPopup()
{
}


DailyBonusPopup::~DailyBonusPopup()
{
}

DailyBonusPopup* DailyBonusPopup::create(CMDDailyBonusData* data)
{
    DailyBonusPopup* popup = new (std::nothrow) DailyBonusPopup();
    if (popup && popup->init(kDailyBonusPopup) && popup->fillData(data))
    {
        popup->autorelease();
        return popup;
    }
    CC_SAFE_DELETE(popup);
    return nullptr;
}

bool DailyBonusPopup::init(string csbFileName)
{
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(csbFileName.c_str()));

	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2,deviceSize.height/2));

	m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    m_ltvBonus = static_cast<ListView*>(Helper::seekWidgetByName(m_pLayout, "ltvBonus"));
    auto item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kBonusItem));

    m_ltvBonus->setInertiaScrollEnabled(true);
    m_ltvBonus->setClippingType(Layout::ClippingType::SCISSOR);
	m_ltvBonus->setItemModel(item);

	m_btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));

    return true;
}

void DailyBonusPopup::onOpen()
{
	BasePopup::onOpen();
    addChild(m_pLayout);
    Vec2 posOrigin = m_pLayout->getPosition();
    Vec2 pos = Vec2(posOrigin.x, posOrigin.y + 640);
    //m_pLayout->setPosition(pos);
    //m_pLayout->runAction(MoveTo::create(0.5f, posOrigin));
    setTextLanguage();
    setLightPosition();
}

bool DailyBonusPopup::fillData(CMDDailyBonusData* data)
{
    for(int i = 0; i < 5; i++)
    {
        m_ltvBonus->pushBackDefaultItem();
    }

    for (int i = 0; i < m_ltvBonus->getItems().size(); i++)
	{
		Widget* item = m_ltvBonus->getItem(i);
		Button* btnBonus = static_cast<Button*>(item->getChildByName("btnBonus"));
        TextBMFont* bmfMoney = static_cast<TextBMFont*>(item->getChildByName("bmfMoney"));
        if(data->m_sDay == i + 1)
        {
            bmfMoney->setString(TTutil::addDot(ccsf("$%ld", data->m_iBonus)));
            btnBonus->loadTextureNormal(ccsf("bt%d0001.png", i + 1));
            btnBonus->loadTexturePressed(ccsf("bt%d0002.png", i + 1));
            btnBonus->loadTextureDisabled(ccsf("bt%d0002.png", i + 1));
        }
        else
        {
            bmfMoney->setVisible(false);
            btnBonus->loadTextureNormal(ccsf("bt%d0002.png", i + 1));
            btnBonus->loadTexturePressed(ccsf("bt%d0001.png", i + 1));
            btnBonus->loadTextureDisabled(ccsf("bt%d0001.png", i + 1));
        }


        TextBMFont* bmfInfo = static_cast<TextBMFont*>(item->getChildByName("bmfInfo"));
        bmfInfo->setString(ccsf("Day %d", i + 1));
    }
    return true;
}

void DailyBonusPopup::requestIAPList()
{

}

void DailyBonusPopup::responseIAPList(HttpClient *sender, HttpResponse *response)
{

}

void DailyBonusPopup::onTouchBtnAdd(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);

    Button* button = static_cast<Button*>(pSender);
    string sku = button->getName();
    CCLOG("onTouchBtnAdd sku %s", sku.c_str());
    IAPHandler::getInstance()->sendPurchase(sku);
}

void DailyBonusPopup::onClose()
{
	BasePopup::onClose();
}

void DailyBonusPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void DailyBonusPopup::setTextLanguage()
{
	m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    //TextBMFont* bmfClose = static_cast<TextBMFont*>(btnClose->getChildByName("bmfClose"));
    //bmfClose->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CLOSE));
}