//
//  SSCard.h
//  IndoGame
//
//  Created by Rainy on 8/20/14.
//
//

#ifndef __IndoGame__SSCard__
#define __IndoGame__SSCard__

#include <iostream>
#include "cocos2d.h"
#include "ui/UIWidget.h"
#include "CardSusunHelper.h"
#include "Card.h"


USING_NS_CC;
using namespace std;


class SSCard : public Sprite, public Clonable
{
private:
    int m_iTouchPaddingLeft;
    int m_iTouchPaddingTop;
	int m_iRank;
	int m_iSuit;
	int m_iSize;
	
public:
	static const int RANK_NONE;
	static const int RANK_ACE;
	static const int RANK_2;
	static const int RANK_3;
	static const int RANK_4;
	static const int RANK_5;
	static const int RANK_6;
	static const int RANK_7;
	static const int RANK_8;
	static const int RANK_9;
	static const int RANK_10;
	static const int RANK_JACK;
	static const int RANK_QUEEN;
	static const int RANK_KING;
		   
 	static const int SUIT_CLUB;
	static const int SUIT_DIAMOND;
	static const int SUIT_HEART;
	static const int SUIT_SPADE;

	static const int SIZE_MEDIUM;
	static const int SIZE_SMALL;

	static SSCard* create();
	static SSCard* create(int cardId);

    CardState m_iState;
    int       m_iId;

    SSCard(void);
    virtual ~SSCard(void);

	int getRank();
	int getSuit();

	Vec2 m_posOrigin;
	float m_fRotationOrigin;
    cocos2d::Rect getRect();
    void init(int p_iResourceId);
    bool initWithTexture(Texture2D* aTexture);
    virtual void onEnter() override;
    virtual void onExit() override;
    bool containsTouchLocation(Touch* touch);
    bool onTouchBegan(Touch* touch, Event* event);
    void onTouchMoved(Touch* touch, Event* event);
    void onTouchEnded(Touch* touch, Event* event);
	void setState(CardState iState);
    virtual SSCard* clone() const;
    static SSCard* createWithTexture(Texture2D* aTexture);

    void setId (const int id);
	void setCardSize(int cardSize);
};
#endif /* defined(__IndoGame__SSCard__) */
