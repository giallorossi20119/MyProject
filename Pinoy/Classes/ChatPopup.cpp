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
    m_inputMsr->setText("");
    //m_inputMsr->setText("//c [2,4,19,22,24,28,29,37,44,45,47,48,49]");

    m_inputMsr->setPositionX(m_bgInputMsr->getPositionX() - m_inputMsr->getContentSize().width / 2 - 5);

    m_lvMessage = static_cast<ui::ListView*>(Helper::seekWidgetByName(m_pLayout, "lvMessage"));
    m_lvMessage->setClippingType(LayoutClippingType::SCISSOR);
    m_lvMessage->scrollToBottom(0.1f, false);
    m_lvMessage->setContentSize(Size(deviceSize.width, m_lvMessage->getContentSize().height));
    m_lvKeyboard = static_cast<ui::ListView*>(Helper::seekWidgetByName(m_pLayout, "lvKeyboard"));
    m_lvKeyboard->setClippingType(LayoutClippingType::SCISSOR);
    m_lvKeyboard->setContentSize(Size(deviceSize.width, m_lvKeyboard->getContentSize().height));
    m_lvKeyboard->removeAllChildrenWithCleanup(true);
    for(int i = 0; i < 20; i += 2)
    {
        Layout* item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ChatDefaultItem.json"));
        Button* button1 = (Button*)item->getChildByName("btnDefault1");
        button1->setTitleText(ResourceManager::getInstance()->getTextByName(ccsf("MSG_DEFAULT_%d", i + 1)));
        button1->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));

        Button* button2 = (Button*)item->getChildByName("btnDefault2");
        button2->setTitleText(ResourceManager::getInstance()->getTextByName(ccsf("MSG_DEFAULT_%d", i + 2)));
        button2->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));

        m_lvKeyboard->pushBackCustomItem(item);
    }
	m_btnSend->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBtnSend, this));
	m_bgInputMsr->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchBgInputMsr, this));
    m_btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    m_btnClose->setPositionX(deviceSize.width - m_btnClose->getContentSize().width / 2 - 20);
    m_btnClose->addTouchEventListener(CC_CALLBACK_2(ChatPopup::onTouchOverlay, this));
	//Button* bgPanel = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "bgPanel"));
/*
	// Create emoticon widget, it's data include: id, animations name
	//TODO: should move these initialize emoticon statements to ResourceManager
	SpriteBatchNode* spriteBatch = SpriteBatchNode::create("emoticon_wonder.png");
	addChild(spriteBatch);
	SpriteFrameCache* cache = SpriteFrameCache::getInstance();
	cache->addSpriteFramesWithFile("emoticon_wonder.plist");

	Vector<SpriteFrame*> animFrames;
	Animation* animation;
	Animate* animate;
	SpriteFrame* frame;
	int offX = deviceSize.width / 2 - bgPanel->getContentSize().width / 2 + 40.0f;
	int offY = deviceSize.height / 2 + 40.0f;
	char frameName[100] = { 0 };
	int i, j;
	float tx, ty;
	float padX = 80.0f;
	float padY = 80.0f;

	for (i = 0; i < 18; i++)
    {
		animFrames = Vector<SpriteFrame*>();
		for (j = 0; j < 9999; j++) {
			sprintf(frameName, "emoticon_wonder_%d.png", j);
			frame = cache->getSpriteFrameByName(frameName);
			if (frame == nullptr) {
				break;
			}
			animFrames.pushBack(frame);
		}
		animation = Animation::createWithSpriteFrames(animFrames, 0.1);
		animate = Animate::create(animation);
		Sprite* sprite = Sprite::createWithSpriteFrameName("emoticon_wonder_0.png");
		spriteBatch->addChild(sprite);
		sprite->runAction(RepeatForever::create(animate));
		tx = offX + padX * (i % 7);
		ty = offY - padY * ((i / 7) | 0);
		sprite->setPosition(Vec2(tx, ty));
		animFrames.clear();
	}
*/
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


/*************************************************************/
/* @author longnh                                              */
/* Event handlers                                            */
/*************************************************************/
void ChatPopup::onTouchBgInputMsr(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    m_inputMsr->setText("");
	m_inputMsr->attachWithIME();
}

void ChatPopup::onTouchBtnSend(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
    string msg = "";
    Button* btnSend = dynamic_cast<Button*>(sender);
    if(btnSend->getName() == "btnSend")
    {
        if (m_inputMsr->getStringValue().size() > 0)
        {
            msg = m_inputMsr->getStringValue();
        }
    }
    else
    {
        msg = btnSend->getTitleText();
    }

	if (msg.length() > 0)
	{
		NotificationCenter::getInstance()->postNotification(EVENT_NETWORK_SEND_MSR, new String(msg));
		SFSConnection::getInstance()->sendMsg(msg.c_str());
        Layout* item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ChatItem.json"));
        Text* lbUsername = static_cast<Text*>(Helper::seekWidgetByName(item, "lbName"));
        lbUsername->setString(GlobalVariable::m_pUser->m_sName);
        Text* lbMessage  = static_cast<Text*>(Helper::seekWidgetByName(item, "lbMessage"));
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
