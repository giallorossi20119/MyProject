#include "CardHand.h"

const int CardHand::HIGH_CARD		  = 1;
const int CardHand::PAIR              = 2;
const int CardHand::TWO_PAIR          = 3;
const int CardHand::THREE_OF_A_KIND   = 4;
const int CardHand::STRAIGHT          = 5;
const int CardHand::FLUSH             = 6;
const int CardHand::FULL_HOUSE        = 7;
const int CardHand::FOUR_OF_A_KIND    = 8;
const int CardHand::STRAIGHT_FLUSH    = 9;
const int CardHand::ROYAL_FLUSH       = 10;

/*************************************************************/
/* @author longnh
/* CONSTRUCTOR/DESTRUCTOR
/*************************************************************/
CardHand::CardHand()
{
}
CardHand::CardHand(vector<int> vCardId)
{
	m_vCardId = vCardId;
}
CardHand::CardHand(int type, vector<int> vCardId)
{
	m_iType = type;
	m_vCardId = vCardId;
}
CardHand::~CardHand()
{
	
}

CardHand* CardHand::create()
{
	CardHand* hand = new CardHand();
	hand->autorelease();
	return hand;
}

CardHand* CardHand::create(vector<int> vCardId)
{
	CardHand* hand = new CardHand(vCardId);
	hand->autorelease();
	return hand;
}

CardHand* CardHand::create(int type, vector<int> vCardId)
{
	CardHand* hand = new CardHand(type, vCardId);
	hand->autorelease();
	return hand;
}

vector<int> CardHand::getCardIds()
{
	return m_vCardId;
}

int CardHand::getType()
{
	return m_iType;
}

int CardHand::getNoCard()
{
	return m_vCardId.size();
}
