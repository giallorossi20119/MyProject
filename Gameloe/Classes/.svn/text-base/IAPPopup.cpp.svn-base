#include "IAPPopup.h"
#include "TTutil.h"
#include "GlobalVariable.h"
#include "IAPHandler.h"

IAPPopup::IAPPopup()
{
    vSKUs = {};
}


IAPPopup::~IAPPopup()
{
}

IAPPopup* IAPPopup::create()
{
    IAPPopup* popup = new (std::nothrow) IAPPopup();
    if (popup)
    {
        popup->autorelease();
        return popup;
    }
    CC_SAFE_DELETE(popup);
    return nullptr;
}

bool IAPPopup::init(string csbFileName)
{
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(csbFileName.c_str()));
	this->addChild(m_pLayout);

	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2,deviceSize.height/2));

	m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    m_ltvIAP = static_cast<ListView*>(m_pLayout->getChildByName("ltvIAP"));
    auto item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kIAPItem));

    m_ltvIAP->setInertiaScrollEnabled(true);
    m_ltvIAP->setClippingType(Layout::ClippingType::SCISSOR);
	m_ltvIAP->setItemModel(item);

	m_btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));

    return true;
}

void IAPPopup::onOpen()
{
	BasePopup::onOpen();
    init(kIAPPopup);
    setTextLanguage();
    setLightPosition();
    requestIAPList();
}

void IAPPopup::fillData(vector<IAPItem*> vItems)
{

	for (int i = 0; i < vItems.size(); ++i)
	{
		m_ltvIAP->pushBackDefaultItem();
	}

	for (int i = 0; i < m_ltvIAP->getItems().size(); i++)
	{
		Widget* item = m_ltvIAP->getItem(i);
		TextBMFont* bmfMoney = static_cast<TextBMFont*>(item->getChildByName("bmfMoney"));
        bmfMoney->setString(TTutil::addSemi(ccsf("%1.0f", vItems.at(i)->m_dMoney)));
		TextBMFont* bmfCash  = static_cast<TextBMFont*>(item->getChildByName("bmfCash"));
        bmfCash->setString(TTutil::addSemi(ccsf("%1.0f", vItems.at(i)->m_dCash)));
        Text* lblSKU  = static_cast<Text*>(item->getChildByName("lblSKU"));
        lblSKU->setString(ccsf("%s", vItems.at(i)->m_sID.c_str()));
        lblSKU->setVisible(false);
        vSKUs.push_back(vItems.at(i)->m_sID);
		Button* btnAdd = static_cast<Button*>(item->getChildByName("btnAdd"));
        if(i == 0)
        {
            btnAdd->loadTextureNormal("gold1.png");
            btnAdd->loadTexturePressed("gold1_tap.png");
            btnAdd->loadTextureDisabled("gold1.png");
        }
        else if (i > 0 && i < 4)
        {
            btnAdd->loadTextureNormal("gold2.png");
            btnAdd->loadTexturePressed("gold2_tap.png");
            btnAdd->loadTextureDisabled("gold2.png");
        }
        else if (i >= 4)
        {
            btnAdd->loadTextureNormal("gold3.png");
            btnAdd->loadTexturePressed("gold3_tap.png");
            btnAdd->loadTextureDisabled("gold3.png");
        }
        btnAdd->setName(ccsf("%s", vItems.at(i)->m_sID.c_str()));
        btnAdd->addTouchEventListener(CC_CALLBACK_2(IAPPopup::onTouchBtnAdd, this));
    }
}

void IAPPopup::requestIAPList()
{
	auto request = new HttpRequest();
	request->setRequestType(HttpRequest::Type::GET);
	request->setResponseCallback(CC_CALLBACK_2(IAPPopup::responseIAPList, this));
    string strIAPListURL = kBaseURL;
    strIAPListURL.append("IAPList.txt");
	request->setUrl(strIAPListURL.c_str());
	HttpClient::getInstance()->sendImmediate(request);
    request->release();
}

void IAPPopup::responseIAPList(HttpClient *sender, HttpResponse *response)
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

    std::vector<char>* vData = response->getResponseData();

    int i = 0;
    while(vData->at(i) != '{')
    {
        i++;
    }
    std::string strData(vData->begin() + i, vData->end());
    rapidjson::Document document;
    document.Parse<0>(strData.c_str());
    std::string app_id = document["app_id"].GetString();
    vector<IAPItem*> vItems = {};
    for(int i = 0; i < document["data"].Size(); i++)
    {
        auto item  = new IAPItem();
        item->m_sID    = document["data"][i]["item_id"].GetString();
        item->m_dCash  = document["data"][i]["cash"].GetDouble();
        item->m_dMoney = document["data"][i]["money"].GetDouble();
        item->m_dBonus = document["data"][i]["bonus"].GetDouble();
        vItems.push_back(item);
    }
    //dump data
    fillData(vItems);
}

void IAPPopup::onTouchBtnAdd(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);

    Button* button = static_cast<Button*>(pSender);
    string sku = button->getName();
    CCLOG("onTouchBtnAdd sku %s", sku.c_str());
    IAPHandler::getInstance()->sendPurchase(sku);
}

void IAPPopup::onClose()
{
	BasePopup::onClose();
}

void IAPPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void IAPPopup::setTextLanguage()
{
	m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    //TextBMFont* bmfClose = static_cast<TextBMFont*>(btnClose->getChildByName("bmfClose"));
    //bmfClose->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CLOSE));
}