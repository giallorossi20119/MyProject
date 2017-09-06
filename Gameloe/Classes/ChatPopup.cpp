#include "ChatPopup.h"

std::string ChatPopup::ON_SEND_MSR = "on_send_msr";
std::string ChatPopup::ON_SEND_EMOTICON = "on_send_emoticon";

/*************************************************************/
/* @author longnh												 */
/* CONSTRUCTOR/DESCTRUCTOR functions						 */
/*************************************************************/
ChatPopup::ChatPopup()
{

}

ChatPopup::~ChatPopup()
{

}

void ChatPopup::onOpen()
{
	BasePopup::onOpen();
	m_vEmoticon = new Vector<Widget*>();

	//m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ChatPopup.json"));
    m_pLayout = ResourceManager::getInstance()->m_loChatPopup;
    if (m_pLayout->getParent())
    {
        m_pLayout->removeFromParent();
    }
    this->addChild(m_pLayout);
	Size deviceSize = Director::getInstance()->getWinSize();

	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
    m_pLayout->setContentSize(Size(deviceSize.width, deviceSize.height ));
	m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    ImageView* imgBarBg = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgBarBg"));
    imgBarBg->setContentSize(Size(deviceSize.width, imgBarBg->getContentSize().height));
    imgBarBg->setPositionX(deviceSize.width / 2);

    m_btnSend = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSend"));
    m_btnSend->setPositionX(deviceSize.width - m_btnSend->getContentSize().width / 2 - 20);

	m_bgInputMsr = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgInputMsr"));
    m_bgInputMsr->setPositionX(deviceSize.width - m_bgInputMsr->getContentSize().width / 2 - m_btnSend->getContentSize().width - 20);


    m_inputMsr = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "inputMsr"));
    m_inputMsr->setMaxLengthEnabled(true);
    m_inputMsr->setMaxLength(60);
    m_inputMsr->setString("");
    //m_inputMsr->setString("//c [4,5,8,9,12,13,16,19,20,21,22,23,49]");
    float factor = (float)deviceSize.width/deviceSize.height;
    int distance = 20 * (factor - 1);
    for(int i = 0; i < 8; i += 2)
    {
        auto button1 = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, ccsf("emo_%d", i)));
        button1->setPositionX(deviceSize.width / 2 - button1->getContentSize().width / 2 - distance);
        button1->setTitleText(ChatToast::defaultMessage[GlobalVariable::m_iCurrentLanguage][i]);
        button1->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));

        auto button2 = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, ccsf("emo_%d", i + 1)));
        button2->setPositionX(deviceSize.width / 2 + button2->getContentSize().width / 2 + distance);
        button2->setTitleText(ChatToast::defaultMessage[GlobalVariable::m_iCurrentLanguage][i + 1]);
        button2->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));
    }

    m_inputMsr->setPositionX(m_bgInputMsr->getPositionX() - m_inputMsr->getContentSize().width / 2 - 5);
    m_lvMessage = static_cast<ui::ListView*>(Helper::seekWidgetByName(m_pLayout, "lvMessage"));
    m_lvMessage->setClippingType(LayoutClippingType::SCISSOR);
    m_lvMessage->scrollToBottom(0.1f, false);
    m_lvMessage->setContentSize(Size(deviceSize.width, m_lvMessage->getContentSize().height));

	m_btnSend->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));
	m_bgInputMsr->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBgInputMsr, this));
    m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    m_btnClose->setPositionX(deviceSize.width - m_btnClose->getContentSize().width / 2 - 20);
    m_btnClose->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchOverlay, this));
	//m_inputMsr->attachWithIME();
}

void ChatPopup::onClose()
{
	BasePopup::onClose();
}

ChatPopup* ChatPopup::create()
{
	ChatPopup* popup = new ChatPopup();
	popup->autorelease();
	return popup;
}


void ChatPopup::onTouchBgInputMsr(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    m_inputMsr->setString("");
	m_inputMsr->attachWithIME();
}

void ChatPopup::onTouchBtnSend(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    string msg = "";
    bool isEmoticon = false;
    Button* btnSend = dynamic_cast<Button*>(sender);
    int index = -1;
    if(btnSend->getName() == "btnSend")
    {
        if (m_inputMsr->getString().size() > 0)
        {
            msg = m_inputMsr->getString();
        }
    }
    else
    {
        msg = btnSend->getName();
        string strIndex = msg.substr(4, 5);
        index = atoi(strIndex.c_str());
        isEmoticon = true;
    }

	if (msg.length() > 0)
	{
		NotificationCenter::getInstance()->postNotification(EVENT_NETWORK_SEND_MSR, __String::create(msg));
		SFSConnection::getInstance()->sendMsg(msg.c_str());
        Layout* item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ChatItem.json"));
        Text* lbUsername = static_cast<Text*>(Helper::seekWidgetByName(item, "lbName"));
        lbUsername->setString(GlobalVariable::m_pUser->m_sName);
        Text* lbMessage  = static_cast<Text*>(Helper::seekWidgetByName(item, "lbMessage"));
        ImageView* imgEmo  = static_cast<ImageView*>(Helper::seekWidgetByName(item, "imgEmo"));
        if(isEmoticon)
        {
            lbMessage->setVisible(false);
            imgEmo->loadTexture(ccsf("emotion%d.png", index));
        }
        else
        {
            imgEmo->setVisible(false);
            lbMessage->setString(msg);
        }
        lbMessage->setString(msg);
        m_lvMessage->pushBackCustomItem(item);
	}
	
	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closePopup(this);
}

void ChatPopup::onTouchOverlay(Ref* sender, Widget::TouchEventType type)
{
    m_inputMsr->setDetachWithIME(false);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closePopup(this);
}

void ChatPopup::onTouchIcon(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;

	// Which emoticon is choosed
	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closePopup(this);
}
