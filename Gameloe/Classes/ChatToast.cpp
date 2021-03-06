#include "ChatToast.h"
#include "GlobalVariable.h"

string ChatToast::defaultEmoticon[8] = {"emo_0", "emo_1", "emo_2", "emo_3", "emo_4", "emo_5", "emo_6", "emo_7"};

string ChatToast::defaultMessage[2][8] =
{
    {
        "Kurang beruntung!",
        "Uangku",
        "Kamu masih muda dan terlalu buruk",
        "Ayo Cepatlah!",
        "Bukan kekurangan uang",
        "Sedih",
        "Maaf karena kamu terlalu malang",
        "Tidak pernah terlampat untuk...",//Tidak pernah terlampat untuk pembalasan"
    },
    {
        "Bad luck!",
        "My money",
        "Well played!",
        "Hurry up!",
        "Not lack of money",
        "So sad!",
        "Relax",
        "Never too late to avenger!"
    }
};
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
    CCLOG("ChatToast msg:%s", m_sMsr.c_str());
	Node::onEnter();
    cocos2d::extension::Scale9Sprite* background = cocos2d::extension::Scale9Sprite::create("toast.png", Rect(0, 0, 64, 64), Rect(10, 10, 44, 44));
    background->setOpacity(200);
    Text* tfContent  = Text::create(m_sMsr, "Arial", 24);
    tfContent->setString(m_sMsr);

    int index = getEmotion(m_sMsr);
    CCLOG("ChatToast index:%d", index);
    if(index != -1)
    {
        auto animEmo = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[12 + index]->getSkeleton()->data);
        animEmo->setScale(0.6f);
        animEmo->setName(m_sMsr);
        animEmo->setMix(m_sMsr, m_sMsr, 1.0f);
        animEmo->addAnimation(0, m_sMsr, true);
        animEmo->setPosition(this->getContentSize().width / 2, this->getContentSize().height / 2);
        this->addChild(animEmo);
    }
    else
    {
        this->addChild(background);
        this->addChild(tfContent);
        Size sizeContent = tfContent->getContentSize();
        background->setContentSize(Size(sizeContent.width + 40, 60));
    }

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

int ChatToast::getEmotion(string msg)
{
    for(int i = 0; i < 8; i++)
    {
        if(std::strcmp(defaultEmoticon[i].c_str(), msg.c_str()) == 0)
        {
               return i;
        }
    }
    return -1;
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