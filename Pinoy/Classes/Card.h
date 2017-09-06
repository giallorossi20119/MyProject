//
//  Card.h
//  IndoGame
//
//  Created by Rainy on 8/20/14.
//
//

#ifndef __IndoGame__Card__
#define __IndoGame__Card__

#include <iostream>
#include "cocos2d.h"
#include "ui/UIWidget.h"
#include "CardHelper.h"

USING_NS_CC;
using namespace std;

typedef enum tagCardState
{
    kCardStateGrabbed,
    kCardStateUngrabbed,
    kCardStateSelected,
    kCardStateKicked
} CardState;

class Card : public Sprite, public Clonable
{
private:
    int m_iTouchPaddingLeft;
    int m_iTouchPaddingTop;
	int m_iRank;
	int m_iSuit;
	
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

	static Card* create();
	static Card* create(int cardId);

    CardState m_iState;
    int         m_iId;
    double      m_dIdPlayer;
    int         m_iIdPhom;
    int         m_iTotalCardDrop;

    Card(void);
    virtual ~Card(void);

	int getRank();
	int getSuit();

	Vec2 m_posOrigin;
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
    virtual Card* clone() const;
    static Card* createWithTexture(Texture2D* aTexture);

    void setId (const int id);
    float m_fRotationOrigin;
};
#endif /* defined(__IndoGame__Card__) */
