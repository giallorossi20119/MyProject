//
//  Card.cpp
//  IndoGame
//
//  Created by Rainy on 8/20/14.
//
//

#include "Card.h"

const int Card::RANK_NONE	  = 0;
const int Card::RANK_ACE      = 14;
const int Card::RANK_2        = 15;
const int Card::RANK_3        = 3;
const int Card::RANK_4        = 4;
const int Card::RANK_5        = 5;
const int Card::RANK_6        = 6;
const int Card::RANK_7        = 7;
const int Card::RANK_8        = 8;
const int Card::RANK_9        = 9;
const int Card::RANK_10       = 10;
const int Card::RANK_JACK     = 11;
const int Card::RANK_QUEEN    = 12;
const int Card::RANK_KING     = 13;
	  
const int Card::SUIT_DIAMOND  = 1;
const int Card::SUIT_CLUB     = 2;
const int Card::SUIT_HEART    = 3;
const int Card::SUIT_SPADE    = 4;
/*
const std::string kResourceString[] = {
    "back.png","ro_3.png",  "nhep_3.png","co_3.png",  "bich_3.png", "ro_4.png", "nhep_4.png","co_4.png", "bich_4.png", "ro_5.png", "nhep_5.png", "co_5.png", "bich_5.png", "ro_6.png", "nhep_6.png", "co_6.png", "bich_6.png", "ro_7.png" ,"nhep_7.png", "co_7.png", "bich_7.png", "ro_8.png", "nhep_8.png", "co_8.png", "bich_8.png", "ro_9.png", "nhep_9.png", "co_9.png", "bich_9.png", "ro_10.png", "nhep_10.png", "co_10.png", "bich_10.png", "ro_J.png", "nhep_J.png", "co_J.png", "bich_J.png", "ro_Q.png", "nhep_Q.png",  "co_Q.png", "bich_Q.png", "ro_K.png", "nhep_K.png", "co_K.png", "bich_K.png", "ro_A.png", "nhep_A.png", "co_A.png", "bich_A.png", "ro_2.png", "nhep_2.png", "co_2.png", "bich_2.png"
};
 */
const std::string kResourceString[] = {
    "poker_52.png",
    "poker_10.png", "poker_9.png",  "poker_11.png", "poker_8.png",
    "poker_14.png", "poker_13.png", "poker_15.png", "poker_12.png",
    "poker_18.png", "poker_17.png", "poker_19.png", "poker_16.png",
    "poker_22.png", "poker_21.png", "poker_23.png", "poker_20.png",
    "poker_26.png" ,"poker_25.png", "poker_27.png", "poker_24.png",
    "poker_30.png", "poker_29.png", "poker_31.png", "poker_28.png",
    "poker_34.png", "poker_33.png", "poker_35.png", "poker_32.png",
    "poker_38.png", "poker_37.png", "poker_39.png", "poker_36.png",
    "poker_42.png", "poker_41.png", "poker_43.png", "poker_40.png",
    "poker_46.png", "poker_45.png", "poker_47.png", "poker_44.png",
    "poker_50.png", "poker_49.png", "poker_51.png", "poker_48.png",
    "poker_2.png",  "poker_1.png",  "poker_3.png",  "poker_0.png",
    "poker_6.png",  "poker_5.png",  "poker_7.png",  "poker_4.png"
};
Card::Card(void)
{
    m_iState = kCardStateGrabbed;
    m_iId    = 0;
    m_iTouchPaddingLeft = 0;
    m_iTouchPaddingTop  = 0;
	m_posOrigin = Vec2(0.0f, 0.0f);
}

Card::~Card(void)
{
	_eventDispatcher->resumeEventListenersForTarget (this);
}

Card* Card::create()
{
    Card* card = new Card();
    if (card)
    {
        card->autorelease();
        return card;
    }
    CC_SAFE_DELETE (card);
    return nullptr;
}

Card* Card::create(int cardId)
{
    Card* card = new Card();
    if (card)
    {
        card->init (cardId);
        card->autorelease();
        return card;
    }
    CC_SAFE_DELETE (card);
    return nullptr;
}

void Card::init(int p_iResourceId)
{
    m_iId = p_iResourceId;
	//m_iRank = CardHelper::getRank(m_iId);
	//m_iSuit = CardHelper::getSuit(m_iId);
    initWithTexture( Director::getInstance()->getTextureCache()->addImage(kResourceString[p_iResourceId]));
}
cocos2d::Rect Card::getRect()
{
    auto s = getTexture()->getContentSize();
    return Rect(-s.width / 2, -s.height / 2, s.width, s.height);
}

Card* Card::createWithTexture(Texture2D* aTexture)
{
    Card* pCard = new Card();
    aTexture->setAntiAliasTexParameters();
    pCard->initWithTexture(aTexture);
    pCard->autorelease();

    return pCard;
}

bool Card::initWithTexture(Texture2D* aTexture)
{
    if( Sprite::initWithTexture(aTexture) )
    {
        m_iState = kCardStateUngrabbed;
    }

    return true;
}

void Card::onEnter()
{
    Sprite::onEnter();

    // Register Touch Event
    auto listener = EventListenerTouchOneByOne::create();
    listener->setSwallowTouches(true);

    listener->onTouchBegan = CC_CALLBACK_2(Card::onTouchBegan, this);
    listener->onTouchMoved = CC_CALLBACK_2(Card::onTouchMoved, this);
    listener->onTouchEnded = CC_CALLBACK_2(Card::onTouchEnded, this);

    _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, this);
}

void Card::onExit()
{
    Sprite::onExit();
}

bool Card::containsTouchLocation(Touch* touch)
{
    return getRect().containsPoint(convertTouchToNodeSpaceAR(touch));
}

bool Card::onTouchBegan(Touch* touch, Event* event)
{
    //if (m_iState != kCardStateUngrabbed) return false;
    if ( !containsTouchLocation(touch) ) return false;

    Vec2 touchPoint = touch->getLocation();
    m_iTouchPaddingLeft = touchPoint.x - getPosition().x;
    m_iTouchPaddingTop  = touchPoint.y - getPosition().y;
    if(m_iState == kCardStateSelected)
    {
		setState(kCardStateUngrabbed);
    }
	else if (m_iState == kCardStateUngrabbed)
    {
		setState(kCardStateSelected);
		NotificationCenter::getInstance()->postNotification("select card", (Ref*)this);
    }

    return true;
}

void Card::onTouchMoved(Touch* touch, Event* event)
{
    return;
    auto touchPoint = touch->getLocation();
    setPosition( Vec2(touchPoint.x - m_iTouchPaddingLeft, touchPoint.y - m_iTouchPaddingTop));
}

Card* Card::clone() const
{
    Card* ret = Card::createWithTexture(_texture);
    ret->m_iState = m_iState;
    ret->m_iId    = m_iId;
    ret->setPosition(getPosition());
    ret->setAnchorPoint(getAnchorPoint());
    return ret;
}

void Card::setState(CardState iState)
{
	m_iState = iState;
	if (m_iState == kCardStateSelected)
	{
		if (ceil(m_posOrigin.x) != 0 && ceil(m_posOrigin.y) != 0) setPosition(Vec2(m_posOrigin.x, m_posOrigin.y + 20.0f));
		else setPosition(Vec2(getPosition().x, getPosition().y + 20));
	}
	else if (m_iState == kCardStateUngrabbed)
	{
		if (ceil(m_posOrigin.x) != 0 && ceil(m_posOrigin.y) != 0) setPosition(Vec2(m_posOrigin.x, m_posOrigin.y));
		else setPosition(Vec2(getPosition().x, getPosition().y));
	}
}

void Card::onTouchEnded(Touch* touch, Event* event)
{
    //m_iState = kCardStateUngrabbed;
} 

int Card::getRank()
{
	return CardHelper::getRank(m_iId);
}

int Card::getSuit()
{
	return CardHelper::getSuit(m_iId);
}

void Card::setId(const int id)
{
    m_iId = id;
	setTexture(Director::getInstance()->getTextureCache()->addImage(kResourceString[id]));
}
