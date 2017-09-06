#include "ChatToast.h"

ChatToast::ChatToast()
{
	m_iMaxChar = 20;
	//this->setOnEnterCallback(CC_CALLBACK_0(ChatToast::onShowed, this));
	//this->setOnExitCallback(CC_CALLBACK_0(ChatToast::onHided, this));
}

ChatToast::ChatToast(std::string sMsr)
{
	m_iMaxChar = 20;
	m_sMsr = sMsr;
	//this->setOnEnterCallback(CC_CALLBACK_0(ChatToast::onShowed, this));
	//this->setOnExitCallback(CC_CALLBACK_0(ChatToast::onHided, this));
}

ChatToast::~ChatToast()
{
	
}

ChatToast* ChatToast::create(std::string sMsr)
{
	ChatToast* toast = new ChatToast(sMsr);
	toast->autorelease();
	return toast;
}

void ChatToast::onEnter()
{
	Node::onEnter();
    cocos2d::extension::Scale9Sprite* background = cocos2d::extension::Scale9Sprite::create("toast.png", Rect(0, 0, 64, 64), Rect(10, 10, 44, 44));
    background->setOpacity(200);
    Text* tfContent  = Text::create(m_sMsr, "Arial", 24);
    tfContent->setString(m_sMsr);
	this->addChild(background);
	this->addChild(tfContent);

	Size sizeContent = tfContent->getContentSize();
    background->setContentSize(Size(sizeContent.width + 40, 60));

	this->setScale(0.4f);
	
	ScaleTo* scaleAct = ScaleTo::create(0.2f, 1.0f);
	EaseIn* scaleEaseAct = EaseIn::create(scaleAct, 0.3f);
	
	this->runAction(scaleEaseAct);

	schedule(schedule_selector(ChatToast::onRemove), 3.0f);
}

void ChatToast::onExit()
{
	Node::onExit();
	unschedule(schedule_selector(ChatToast::onRemove));
	removeAllChildrenWithCleanup(true);
}

void ChatToast::onRemove(float dt)
{
	this->removeFromParent();
}

//void ChatToast::onShowed()
//{
//	Sprite* background = Sprite::create("button-xanh.png");
//	background->setAnchorPoint(Vec2(0.5f, 0.5f));
//
//	ui::TextField* tf = ui::TextField::create();
//	tf->setMaxLength(m_iMaxChar);
//	tf->setColor(Color3B(255, 255, 255));
//	tf->setFontSize(14.0f);
//	tf->setAnchorPoint(Vec2(0.0f, 0.5f));
//	tf->setPosition(Vec2(-background->getContentSize().width/2 + 4.0f, 0.0f));
//
//	std::string finalMsr;
//	int count = m_sMsr.size();
//	if (count > m_iMaxChar)
//	{
//		finalMsr = m_sMsr.substr(0, m_iMaxChar);
//	}
//	else 
//	{
//		finalMsr = m_sMsr;
//	}
//	
//	tf->setText(finalMsr);
//	addChild(background);
//	addChild(tf);
//
//	this->setScale(0.2f);
//
//	ScaleTo* scaleAct = ScaleTo::create(0.2f, 1.0f);
//	EaseIn* scaleEaseAct = EaseIn::create(scaleAct, 0.3f);
//
//	this->runAction(scaleEaseAct);
//}
//
//void ChatToast::onHided()
//{
//	removeAllChildrenWithCleanup(true);
//}