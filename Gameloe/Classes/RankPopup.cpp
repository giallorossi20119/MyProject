#include "RankPopup.h"
#include "TTutil.h"
#include "GlobalVariable.h"

RankPopup::RankPopup()
{
}


RankPopup::~RankPopup()
{
}

void RankPopup::onOpen()
{
	BasePopup::onOpen();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kRankPopup));
	this->addChild(m_pLayout);

	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2,deviceSize.height/2));

	m_pItemRank = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kItemRank));

	//Layout* lt = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlMain"));
	m_pListView = static_cast<ListView*>(Helper::seekWidgetByName(m_pLayout, "listRank"));
    m_pListView->setClippingType(Layout::ClippingType::SCISSOR);
    m_pListView->setInertiaScrollEnabled(true);
	m_pListView->setItemModel(m_pItemRank);

	for (int i = 0; i < 30; ++i)
	{
		m_pListView->pushBackDefaultItem();
	}

	m_pBtnE = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLevel"));
	m_pBtnM = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnMoney"));
	m_pBtnE->addTouchEventListener(CC_CALLBACK_2(RankPopup::onBtnEClick, this));
	m_pBtnM->addTouchEventListener(CC_CALLBACK_2(RankPopup::onBtnMClick, this));
	Button* btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
	btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(RankPopup::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    setTextLanguage();
    setLightPosition();
}
void RankPopup::onBtnEClick(Ref *pSender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    m_pBtnM->setEnabled(true);
    m_pBtnE->setEnabled(false);
    int z = m_pBtnE->getZOrder();
    m_pBtnE->setZOrder(z + 3);
    fillRanks(2);
}
void RankPopup::onBtnMClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    m_pBtnM->setEnabled(false);
    m_pBtnE->setEnabled(true);
    fillRanks(1);

}
void RankPopup::recieveRankData(CMD2Rank* obj)
{
	//CMD2Rank* data = (CMD2Rank*)obj;
	rankM = obj->m_pVecM;
	rankE = obj->m_pVecE;
	fillRanks(1);
}
void RankPopup::fillRanks(int type) //1:Money,2:Level
{
	vector<CMDRankData*>* rankArr;
	if (type == 1) rankArr = rankM;
	else rankArr = rankE;
    TextBMFont* bmValue = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmValue"));
    ImageView* imgRank = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgRank"));
    TextBMFont* bmName = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmValue_0"));
    string name = UserDefault::getInstance()->getStringForKey("name", GlobalVariable::m_pUser->m_sName);
    if(GlobalVariable::m_pUser->m_sName.length() > 16)
    {
        bmName->setString(ccsf("%s..", GlobalVariable::m_pUser->m_sName.substr(0, 13).c_str()));
    }
    else
    {
        bmName->setString(GlobalVariable::m_pUser->m_sName);
    }
    if (type != 1)
    {
        bmValue->setString(ccsf("Level %ld", GlobalVariable::m_pUser->m_iLevel));
        imgRank->setVisible(false);
    }
    else
    {
        bmValue->setString(TTutil::addDot(ccsf("%1.0f", GlobalVariable::m_pUser->m_dMoney)));
        imgRank->setVisible(true);
    }


	for (int i = 0; i < m_pListView->getItems().size(); i++)
	{
		Widget* item = m_pListView->getItem(i);
		TextBMFont* txtRank = static_cast<TextBMFont*>(Helper::seekWidgetByName(item, "bmRank"));
		TextBMFont* txtName = static_cast<TextBMFont*>(Helper::seekWidgetByName(item, "bmName"));
		TextBMFont* txtMoney = static_cast<TextBMFont*>(Helper::seekWidgetByName(item, "bmMoney"));
        ImageView* imgRank = static_cast<ImageView*>(Helper::seekWidgetByName(item, "imgRank"));
        imgRank->setVisible(false);
        ImageView* imgMoneyIcon = static_cast<ImageView*>(Helper::seekWidgetByName(item, "imgMoneyIcon"));
        if (type != 1)
        {
            imgMoneyIcon->setVisible(false);
        }
        else
        {
            imgMoneyIcon->setVisible(true);
        }

        CMDRankData* data = rankArr->at(i);
        if(i == 0 || i == 20)
        {
            txtRank->setString(ccsf("%dst", i + 1));
        }
        else if(i == 1 || i == 21)
        {
            txtRank->setString(ccsf("%dnd", i + 1));
        }
        else if(i == 2 || i == 22)
        {
            txtRank->setString(ccsf("%drd", i + 1));
        }
        else
        {
            txtRank->setString(ccsf("%dth", i + 1));
        }
        CCLOG("fillRanks-money: %1.0f", data->m_uMoney);
        if (type == 1) txtMoney->setString(TTutil::addDot(ccsf("%1.0f", data->m_uMoney)));
        else txtMoney->setString(ccsf("Level %ld", data->m_uLevel));

        if(data->m_uName.length() < 14)
        {
            txtName->setString(data->m_uName);
        }
        else
        {
            txtName->setString(ccsf("%s..", data->m_uName.substr(0, 14).c_str()));
        }
        imgRank->setVisible(false);
        CCLOG("fillRanks-money: %1.0f", data->m_uMoney);
        if (type == 1) txtMoney->setString(TTutil::addDot(ccsf("%1.0f", data->m_uMoney)));
        else txtMoney->setString(ccsf("Level %ld", data->m_uLevel));

	}
	//m_pListView->scrollToPercentVertical(0,0.1,false);
}

void RankPopup::onClose()
{
	BasePopup::onClose();
}

void RankPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void RankPopup::setTextLanguage()
{
	Button* btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    TextBMFont* bmClose = static_cast<TextBMFont*>(btnClose->getChildByName("bmClose"));
    bmClose->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CLOSE));
}