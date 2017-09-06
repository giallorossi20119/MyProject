#ifndef CARD_SUSUN_HELPER_H
#define CARD_SUSUN_HELPER_H

#include <iostream>
#include "cocos2d.h"
#include "Card.h"
#include "SSCard.h"
#include "CardHand.h"
#include "CardHelper.h"

class SSCard;
class Card;
class CardHand;

USING_NS_CC;
using namespace std;

namespace CardSusunHelper
{
	vector<vector<int>> getCombinations(int k, vector<int> group);
	int getCard(int rank, int suit);
	int getRank(int iCardId);
	int getSuit(int iCardId);
	int getStrongestCardWithRank(int rank, vector<int> cardIds);
	int getStrongestCardWithSuit(int suit, vector<int> cardIds);
	int getStrongestRank(vector<int> cardIds);
	int getStrongestSuit(vector<int> cardIds);
	int getNextRank(int rank);
	int getPrevRank(int rank);
	int getStrongestCardExcept2(vector<int> cardIds);
	bool hasRank(int rank, vector<int> cardIds);
	bool hasSuit(int suit, vector<int> cardIds);
	bool validRank(int rank);
	bool validSuit(int suit);
	vector<int> getAllCardIds();
	vector<int> getCardsWithSameRank(int rank, vector<int> cardIds);
	vector<int> getCardsWithSameSuit(int suit, vector<int> cardIds);
	vector<int> getAllRanks(vector<int> cardIds);
	vector<int> getAllSuits(vector<int> cardIds);
	
	void sortByHand(vector<int> &cardIds);
	void sortByUpRank(vector<int> &cardIds);
	void sortByDownRank(vector<int> &cardIds);
	void sortBySuit(vector<int> &cardIds);
	inline void sortByStraightHand(vector<int> &cardIds);
	inline void sortByFlushHand(vector<int> &cardIds);
	inline void sortByFullHouseHand(vector<int> &cardIds);
	inline void sortByFourOfAKindHand(vector<int> &cardIds);
	inline void sortByStraighFlushHand(vector<int> &cardIds);
	
	int getStrongerCard(int cardId, vector<int> cardIds);
	int getStrongestCard(vector<int> cardIds);
	int getComplexHandLevel(int type);
	int getHandLevel(int type);
	bool compare(CardHand* handA, CardHand* handB);
	CardHand* getStrongerHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds);
	inline CardHand* getStrongerComplexHandByType(int type, CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerComplexHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerPairHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerTwoPairHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerThreeOfAKindHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerStraightHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerFlushHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerFullhouseHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerFourOfAKindHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});
	inline CardHand* getStrongerStraightFlushHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds = {});

	CardHand* getHand(vector<int> cardIds);
	CardHand* getSusunHand(vector<int> cardIds);
	CardHand* getPairHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getTwoPairHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getThreeOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getFourOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getStraightHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getFlushHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getFullHouseHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getStraightFlushHand(vector<int> allCardIds, vector<int> requiredCardIds = {});
	CardHand* getExactFourOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds = {});

	vector<CardHand*> getAllPairHands(vector<int> allCardIds);
	vector<CardHand*> getAllThreeOfAKindHands(vector<int> allCardIds);
	vector<CardHand*> getAllTwoPairHands(vector<int> allCardIds);
	vector<CardHand*> getAllFlushHands(vector<int> allCardIds, CardHand* hand = nullptr);
	vector<CardHand*> getAllStraightHands(vector<int> allCardIds, CardHand* hand = nullptr);
	vector<CardHand*> getAllFullhouseHands(vector<int> allCardIds, CardHand* hand = nullptr);
	vector<CardHand*> getAllFourOfAKindHands(vector<int> allCardIds, CardHand* hand = nullptr);
	vector<CardHand*> getAllStraightFlushHands(vector<int> allCardIds, CardHand* hand = nullptr);
	vector<CardHand*> getAllExactFourOfAKindHands(vector<int> allCardIds, CardHand* hand = nullptr);

	bool checkDragonSameSuit(vector<int> allCardIds);
	bool checkDragon(vector<int> allCardIds);
	bool checkSameSuit(vector<int> allCardIds);
	bool checkFivePairsOneTriple(vector<int> allCardIds);
	bool checkSixPairs(vector<int> allCardIds);
	bool checkThreeFlushes(vector<int> allCardIds);
	bool checkThreeStraights(vector<int> allCardIds);

    bool compareHighHands(vector<int> cardsA, vector<int> cardsB);
}
#endif // !CARD_SUSUN_HELPER_H
