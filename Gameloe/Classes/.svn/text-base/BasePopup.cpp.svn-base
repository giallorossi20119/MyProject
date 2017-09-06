//
//  BasePopup.cpp
//  IndoGame
//
//  Created by Rainy on 27/Mar/15.
//
//
#include "BasePopup.h"

BasePopup::BasePopup()
{
	m_bInitialized = false;
}

BasePopup::~BasePopup()
{
}

void BasePopup::onOpen()
{
	m_pSpecialEventDispatcher = new EventDispatcher();
	m_pSpecialEventDispatcher->autorelease();
	m_pSpecialEventDispatcher->retain();
	m_pSpecialEventDispatcher->setEnabled(true);

	// This function should be called only one time 
	if (m_bInitialized) return;
	m_bInitialized = true;

    LayerColor* overlay = LayerColor::create(Color4B(0, 0, 0, 170));
	Size deviceSize = Director::getInstance()->getWinSize();
	addChild(overlay);
    overlay->setContentSize(Size(deviceSize.width, deviceSize.height));
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);
    listener->onTouchBegan = CC_CALLBACK_2(BasePopup::onTouchBegan, this);
    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
}

bool BasePopup::onTouchBegan(Touch* touch, Event* event)
{
	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closeLastPopup();
    return true;
}

void BasePopup::setLightPosition()
{
    ImageView* background = static_cast<ImageView*>(m_pLayout->getChildByName("background"));
    background->setTouchEnabled(true);
    auto lightLeft = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLight]->getSkeleton()->data);
    lightLeft->setMix("trai", "trai", 1.0f);
    lightLeft->addAnimation(0, "trai", true);
    background->addChild(lightLeft);
    lightLeft->setPosition(Vec2(background->getContentSize().width / 2, 15));

    auto lightRight = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLight]->getSkeleton()->data);
    lightRight->setMix("phai", "phai", 1.0f);
    lightRight->addAnimation(0, "phai", true);
    background->addChild(lightRight);
    lightRight->setPosition(Vec2(background->getContentSize().width / 2, background->getContentSize().height - 5));
}

void BasePopup::onClose()
{
	m_pSpecialEventDispatcher->removeAllEventListeners();
	m_pSpecialEventDispatcher->release();
    NotificationCenter::getInstance()->removeAllObservers(this);
}
/* end pragma base of onOpen/onClose		  */

EventDispatcher* BasePopup::getSpecialEventDispatcher()
{
	return m_pSpecialEventDispatcher;
}

void BasePopup::fadeInContent()
{
	m_pLayout->setScale(0.2f);
	m_pLayout->setOpacity(51);

	ScaleTo* scaleAct = ScaleTo::create(0.2f, 1.0f);
	FadeTo* fadeAct = FadeTo::create(0.3f, 255);
	EaseIn* scaleEaseAct = EaseIn::create(scaleAct, 0.3f);
	EaseIn* fadeEaseAct = EaseIn::create(fadeAct, 0.5f);

	m_pLayout->runAction(scaleEaseAct);
	m_pLayout->runAction(fadeEaseAct);
}

void BasePopup::fadeOutContent()
{

}

void BasePopup::onTouchOverlay(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;

	BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->closeLastPopup();
}

void BasePopup::onTouchBackground(Ref* sender, Widget::TouchEventType type)
{
	if (Widget::TouchEventType::ENDED != type) return;
	return;
}

/* end pragma template effect functions		  */
