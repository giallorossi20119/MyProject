#ifndef CARDHAND_H
#define CARDHAND_H

#include <iostream>
#include "cocos2d.h"

#include "Card.h"

class Card;

USING_NS_CC;
using namespace std;

class CardHand :
	public Ref
{
public:
	CardHand();
	CardHand(vector<int> vCardId);
	CardHand(int type, vector<int> vCardId);
	virtual ~CardHand();

	static CardHand* create();
	static CardHand* create(vector<int> vCardId);
	static CardHand* create(int type, vector<int> vCardId);

	static const int HIGH_CARD;
	static const int PAIR;
	static const int TWO_PAIR;
	static const int THREE_OF_A_KIND;
	static const int STRAIGHT;
	static const int FLUSH;
	static const int FULL_HOUSE;
	static const int FOUR_OF_A_KIND;
	static const int STRAIGHT_FLUSH;
	static const int ROYAL_FLUSH;

	vector<int> getCardIds();
	int getType();
	int getNoCard();

private:
	vector<int> m_vCardId;
	int m_iType;
};


#endif // !CARDHAND_H
