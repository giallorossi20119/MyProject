#include "CardHelper.h"

const int kRank[] = {
	Card::RANK_3, Card::RANK_4, Card::RANK_5, Card::RANK_6, Card::RANK_7, Card::RANK_8, Card::RANK_9, Card::RANK_10, Card::RANK_JACK, Card::RANK_QUEEN, Card::RANK_KING, Card::RANK_ACE, Card::RANK_2
};
const int kSuit[] = {
	 Card::SUIT_CLUB, Card::SUIT_SPADE, Card::SUIT_HEART, Card::SUIT_DIAMOND
};
const int kComplexHand[] = {
	CardHand::STRAIGHT, CardHand::FLUSH, CardHand::FULL_HOUSE, CardHand::FOUR_OF_A_KIND, CardHand::STRAIGHT_FLUSH
};
const int kHands[] = {CardHand::HIGH_CARD, CardHand::PAIR, CardHand::TWO_PAIR, CardHand::THREE_OF_A_KIND, CardHand::STRAIGHT, CardHand::FLUSH, CardHand::FULL_HOUSE, CardHand::FOUR_OF_A_KIND, CardHand::STRAIGHT_FLUSH};

// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// GET RANK, SUIT AND CONVENIENCE FUNCTIONS
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
int aCombinationIndex[100];

bool sortIncrease(int a, int b)
{
	return (a < b) ? true : false;
}

vector<int> getCombination(vector<int> &group, int m)
{
	vector<int> result = {};
	for (int i = 1; i <= m; i++)
	{
		result.push_back(group.at(aCombinationIndex[i] - 1));
	}
	return result;
}

void findCombination(int i, vector<int> &group, int m, vector<vector<int>> &result)
{
	int n = group.size();
	for (int j = aCombinationIndex[i - 1] + 1; j <= n - m + i; j++)
	{
		aCombinationIndex[i] = j;
		if (i == m) result.push_back(getCombination(group, m));
		else findCombination(i + 1, group, m, result);
	}
}

vector<vector<int>> getStraightCardsFromRanks(vector<int> vFoundRanks, vector<int> allCardIds)
{
	vector<vector<int>> vCombination = {};
	vector<int> wantedCards = {};
	for (int i = 0, l = vFoundRanks.size(); i < l; i++)
	{
		int rank = vFoundRanks.at(i);
		vector<int> foundCards = CardHelper::getCardsWithSameRank(rank, allCardIds);
		int noCombination = vCombination.size();
		if (noCombination == 0)
		{
			vCombination.push_back(vector<int> {});
			noCombination = 1;
		}

		for (int j = 1; j < foundCards.size(); j++)
		{
			for (int m = 0; m < noCombination; m++)
			{
				vector<int> wantedCards = vCombination.at(m);
				wantedCards.push_back(foundCards.at(j));
				vCombination.push_back(wantedCards);
			}
		}

		for (int m = 0; m < noCombination; m++)
		{
			vector<int> &wantedCards = vCombination.at(m);
			wantedCards.push_back(foundCards.at(0));
		}
	}
	return vCombination;
}

vector<vector<int>> CardHelper::getCombinations(int noElementRequired, vector<int> group)
{
	aCombinationIndex[0] = 0;
	vector<vector<int>> vFoundCombination = {};
	findCombination(1, group, noElementRequired, vFoundCombination);
	return vFoundCombination;
}

int CardHelper::getCard(int rank, int suit)
{
	int ind = (rank - 3) * 4 + suit;
	return ind;
}
int CardHelper::getRank(int iCardId)
{
	int rankInd = (((iCardId - 1) / 4) >> 0);
	return kRank[rankInd];
}
int CardHelper::getSuit(int iCardId)
{
	int suitInd = (iCardId - 1) % 4;
	return kSuit[suitInd];
}

int CardHelper::getStrongestCardWithRank(int rank, vector<int> cardIds)
{
	vector<int> cardsWithSameRank = getCardsWithSameRank(rank, cardIds);
	if (cardsWithSameRank.size() == 0) return -1;
	std::sort(cardsWithSameRank.begin(), cardsWithSameRank.end(), sortIncrease);
	return cardsWithSameRank.at(cardsWithSameRank.size() - 1);
}
int CardHelper::getStrongestCardWithSuit(int suit, vector<int> cardIds)
{
	vector<int> cardsWithSameSuit = getCardsWithSameSuit(suit, cardIds);
	if (cardsWithSameSuit.size() == 0) return -1;
	std::sort(cardsWithSameSuit.begin(), cardsWithSameSuit.end(), sortIncrease);
	return cardsWithSameSuit.at(cardsWithSameSuit.size() - 1);
}

int CardHelper::getStrongestRank(vector<int> cardIds)
{
	vector<int> ranks = getAllRanks(cardIds);
	return (*(max_element(ranks.begin(), ranks.end())));
}
int CardHelper::getStrongestSuit(vector<int> cardIds)
{
	vector<int> suits = getAllSuits(cardIds);
	return (*(max_element(suits.begin(), suits.end())));
}

vector<int> CardHelper::getCardsWithSameRank(int rank, vector<int> cardIds)
{
	vector<int> resultIds;
	int id;
	int foundRank;
	for (int i = 0, l = cardIds.size(); i < l; i++)
	{
		id = cardIds.at(i);
		foundRank = getRank(id);
		if (foundRank == rank)
		{
			resultIds.push_back(id);
		}
	}
	return resultIds;
}
vector<int> CardHelper::getCardsWithSameSuit(int suit, vector<int> cardIds)
{
	vector<int> resultIds;
	int id; 
	int foundSuit;
	for (int i = 0, l = cardIds.size(); i < l; i++)
	{
		id = cardIds.at(i);
		foundSuit = getSuit(id);
		if (foundSuit == suit)
		{
			resultIds.push_back(id);
		}
	}
	return resultIds;
}
vector<int> CardHelper::getAllCardIds()
{
	vector<int> vCard;
	int rank;
	int suit;
	int id;
	for (int i = 0, li = 13; i < li; i++)
	{
		rank = kRank[i];
		for (int j = 0, lj = 4; j < lj; j++)
		{
			suit = kSuit[j];
			id = getCard(rank, suit);
			vCard.push_back(id);
		}
	}
	return vCard;
}
vector<int> CardHelper::getAllRanks(vector<int> cardIds)
{
	vector<int> resultRanks;
	int id;
	int rank;
	vector<int>::iterator it;
	for (int i = 0, l = cardIds.size(); i < l; i++)
	{
		id = cardIds.at(i);
		rank = getRank(id);

		it = std::find(resultRanks.begin(), resultRanks.end(), rank);
		if (it == resultRanks.end())
		{
			resultRanks.push_back(rank);
		}
	}

	return resultRanks;
}
vector<int> CardHelper::getAllSuits(vector<int> cardIds)
{
	vector<int> resultSuits;
	int id;
	int suit;
	vector<int>::iterator it;

	for (int i = 0, l = cardIds.size(); i < l; i++)
	{
		id = cardIds.at(i);
		suit = getSuit(id);

		it = std::find(resultSuits.begin(), resultSuits.end(), suit);
		if (it == resultSuits.end())
		{
			resultSuits.push_back(suit);
		}
	}
	
	return resultSuits;
}

int CardHelper::getNextRank(int rank)
{
	if (Card::RANK_2 == rank) return Card::RANK_3;
	return (++rank);
}
int CardHelper::getPrevRank(int rank)
{
	if (Card::RANK_3 == rank) return Card::RANK_2;
	return (--rank);
}

bool CardHelper::hasRank(int rank, vector<int> cardIds)
{
	vector<int> ranks = getAllRanks(cardIds);
	vector<int>::iterator it = std::find(ranks.begin(), ranks.end(), rank);
	if (it != ranks.end()) return true;
	else return false;
}
bool CardHelper::hasSuit(int suit, vector<int> cardIds)
{
	vector<int> suits = getAllSuits(cardIds);
	vector<int>::iterator it = std::find(suits.begin(), suits.end(), suit);
	if (it != suits.end()) return true;
	return false;
}

bool CardHelper::validRank(int rank)
{
	return ((Card::RANK_3 <= rank && rank <= Card::RANK_2) ? true : false);
}
bool CardHelper::validSuit(int suit)
{
	return ((Card::SUIT_CLUB <= suit && suit <= Card::SUIT_SPADE) ? true : false);
}

int CardHelper::getComplexHandLevel(int type)
{
	for (int i = 0, l = sizeof(kComplexHand); i < l; i++)
	{
		if (type == kComplexHand[i])
		{
			return i;
		}
	}
	return (-1);
}

int CardHelper::getHandLevel(int type)
{
	for (int i = 0, l = sizeof(kHands); i < l; i++)
	{
		if (type == kHands[i])
		{
			return i;
		}
	}
	return (-1);
}

int CardHelper::getStrongestCardExcept2(vector<int> cardIds)
{
	vector<int> cards = cardIds;
	int invalidCard;
	for (int i = 0, l = cards.size(); i < l; i++)
	{
		if (getRank(cards.at(i)) == Card::RANK_2)
		{
			invalidCard = cards.at(i);
		}
	}
	vector<int>::iterator it = std::find(cards.begin(), cards.end(), invalidCard);
	if (it != cards.end()) cards.erase(it, it + 1);
	int foundCard = (*(std::max_element(cards.begin(), cards.end())));
	return foundCard;
}


// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// GET CARD FUNCTIONS
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
int CardHelper::getStrongerCard(int cardId, vector<int> cardIds){ return 0; }
int CardHelper::getStrongestCard(vector<int> cardIds)
{
	return (*(std::max_element(cardIds.begin(), cardIds.end())));
}


// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
// GET HAND FUNCTIONS
// -------------------------------------------------------------------------------
// -------------------------------------------------------------------------------
CardHand* CardHelper::getStrongerHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds)
{
	// At least we must have enough number of required cards
	if (hand->getNoCard() > cardIds.size()) return nullptr;

	// Which kind of hand we want to get
	int type = hand->getType();

	// Simple cases: pair, three of a kind or
	// Complex cases: straight, flush, fullhouse, four of a kind, straight  flush
	CardHand* foundHand = nullptr;
	if (CardHand::PAIR == type)
	{
		foundHand = getStrongerPairHand(hand, cardIds, requiredCardIds);
	}
	else if (CardHand::THREE_OF_A_KIND == type)
	{
		foundHand = getStrongerThreeOfAKindHand(hand, cardIds, requiredCardIds);
	}
	else
	{
		foundHand = getStrongerComplexHand(hand, cardIds, requiredCardIds);
	}
	return foundHand;
}


/**
Get complex hand, it's can be: STRAIGHT, FLUSH, FOUR OF A KIND, STRAIGHT FLUSH. Each hand has special
algorithm to check. They've special level and be sorted to get. The sequence as list above.
*/
inline CardHand* CardHelper::getStrongerComplexHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds)
{ 
	int type;
	CardHand* foundHand = nullptr;
	int begin = getComplexHandLevel(hand->getType());

	// We only need fo find hand which have same or higher level than passed hand
	for (int level = begin, end = sizeof(kComplexHand); level < end; level++)
	{
		type = kComplexHand[level];
		foundHand = getStrongerComplexHandByType(type, hand, cardIds, requiredCardIds);
		if (foundHand != nullptr) {
			break;
		}
	}
	return foundHand;
}

inline CardHand* CardHelper::getStrongerComplexHandByType(int type, CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds)
{
	CardHand* foundHand = nullptr;
	int orderLevel = getComplexHandLevel(type);
	int handLevel = getComplexHandLevel(hand->getType());
	bool bHigherLevel = (orderLevel > handLevel ? true : false);

	if (CardHand::STRAIGHT == type)
	{
		if (!bHigherLevel) foundHand = getStrongerStraightHand(hand, cardIds, requiredCardIds);
		else foundHand = getStraightHand(cardIds, requiredCardIds);
	}
	else if (CardHand::FLUSH == type)
	{
		if (!bHigherLevel) foundHand = getStrongerFlushHand(hand, cardIds, requiredCardIds);
		else foundHand = getFlushHand(cardIds, requiredCardIds);
	}
	else if (CardHand::FULL_HOUSE == type)
	{
		if (!bHigherLevel) foundHand = getStrongerFullhouseHand(hand, cardIds, requiredCardIds);
		else foundHand = getFullHouseHand(cardIds, requiredCardIds);
	}
	else if (CardHand::FOUR_OF_A_KIND == type)
	{
		if (!bHigherLevel) foundHand = getStrongerFourOfAKindHand(hand, cardIds, requiredCardIds);
		else foundHand = getFourOfAKindHand(cardIds, requiredCardIds);
	}
	else if (CardHand::STRAIGHT_FLUSH == type)
	{
		if (!bHigherLevel) foundHand = getStrongerStraightFlushHand(hand, cardIds, requiredCardIds);
		else getStraightFlushHand(cardIds, requiredCardIds);
	}

	return foundHand;
}

inline CardHand* CardHelper::getStrongerPairHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds)
{
	// User selected one card with lower rank
	int orderRank = getRank(hand->getCardIds().at(0));
	int checkingRank;
	vector<int> allRanks;
	if (requiredCardIds.size() > 0)
	{
		checkingRank = getRank(requiredCardIds.at(0));
		// Selected card has lower rank, then ignore
		if (orderRank > checkingRank)
		{
			return nullptr;
		}
		// Selected card has same rank, condition has pair with same rank and higher suit (stronger card)
		else if (orderRank == checkingRank)
		{
			int strongestCardWithRank = getStrongestCardWithRank(checkingRank, allCardIds);
			int strongestCardInHand = getStrongestCard(hand->getCardIds());
			vector<int> cardsWithSameRank = getCardsWithSameRank(checkingRank, allCardIds);
			if (strongestCardWithRank > strongestCardInHand && cardsWithSameRank.size() == 2)
			{
				return new CardHand(CardHand::PAIR, cardsWithSameRank);
			}
		}
		// Other cases just check whether user has pair with target rank
		allRanks = vector<int> {checkingRank};
	}
	else
	{
		allRanks = getAllRanks(allCardIds);
	}
	
	vector<int> foundIds;
	CardHand* foundHand = nullptr;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		checkingRank = allRanks.at(i);

		// Ignore ranks which are lower than order rank
		if (checkingRank < orderRank) continue;
		
		// Checking rank can make one three of a kind hand?
		foundIds = getCardsWithSameRank(checkingRank, allCardIds);
		if (foundIds.size() >= 2)
		{
			vector<int> lastIds = {};
			if (requiredCardIds.size() > 0) lastIds.push_back(requiredCardIds.at(0));
			
			for (int j = 0; j < foundIds.size(); j++) {
				if (std::find(lastIds.begin(), lastIds.end(), foundIds.at(j)) == lastIds.end()) {
					lastIds.push_back(foundIds.at(j));
					if (lastIds.size() == 2) break;
				}
			}
			
			if (getStrongestCard(lastIds) > getStrongestCard(hand->getCardIds()))
			{
				foundHand = new CardHand(CardHand::PAIR, lastIds);
				break;
			}
		}
	}

	return foundHand;
}
inline CardHand* CardHelper::getStrongerTwoPairHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds)
{
	return nullptr;
}
inline CardHand* CardHelper::getStrongerThreeOfAKindHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds)
{
	int orderRank = getRank(hand->getCardIds().at(0));
	int checkingRank;
	vector<int> allRanks;
	
	if (requiredCardIds.size() > 0) 
	{
		checkingRank = getRank(requiredCardIds.at(0));
		// Ignore if selected card has same or lower rank
		if (orderRank >= checkingRank) return nullptr;
		// Only checking with target rank
		else allRanks = vector<int> {checkingRank};
	}
	else 
	{
		// Check all ranks possible
		allRanks = getAllRanks(allCardIds);
	}
	
	vector<int> foundIds;
	CardHand* foundHand = nullptr;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		checkingRank = allRanks.at(i);

		// Ignore ranks which are lower than order rank
		if (checkingRank <= orderRank) continue;

		// Checking rank can make one three of a kind hand?
		foundIds = getCardsWithSameRank(checkingRank, allCardIds);
		if (foundIds.size() >= 3)
		{
			// Can, not only three but also four of a kind hand. But we need only 3 cards
			if (foundIds.size() > 3) foundIds.pop_back();
			foundHand = new CardHand(CardHand::THREE_OF_A_KIND, foundIds);
			break;
		}
	}

	return foundHand;
}
inline CardHand* CardHelper::getStrongerStraightHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds)
{
	//TODO: lack checking required card ids
	vector<int> allValidRanks = getAllRanks(allCardIds);
	// Not enough rank?
	if (allValidRanks.size() < 5) return nullptr;

	// We must check all rank in deck util begin rank in straight reach begin rank in deck again
	// First start from lowest rank in deck. We continue util find enougth 5 card with in-line rank
	// or reach the begining.
	CardHand* foundHand = nullptr;
	vector<int> attackedCards = hand->getCardIds();
	int requiredRank = getRank(requiredCardIds.at(0));
	int beginRankDeck = allValidRanks.at(0);
	int beginRankStraight = allValidRanks.at(0);
	int lastRank = beginRankDeck;
	int wantedRank;
	int curRank;
	int strongestAttackedCard;
	int bStrongestStraight = false;
	int bWeakestStraight = false;
	// Strongest card, rank 6 is the king
	if (hasRank(Card::RANK_2, attackedCards) && hasRank(Card::RANK_6, attackedCards))
	{
		bStrongestStraight = true;
		strongestAttackedCard = getCardsWithSameRank(Card::RANK_6, attackedCards).at(0);
	}
	// Weakest card, rank 5 is the king
	else if (hasRank(Card::RANK_2, attackedCards) && hasRank(Card::RANK_5, attackedCards))
	{
		bWeakestStraight = true;
		strongestAttackedCard = getCardsWithSameRank(Card::RANK_5, attackedCards).at(0);
	}	
	// The highest rank except 2 is the king
	else
	{
		strongestAttackedCard = getStrongestCardExcept2(attackedCards);
	}

	// PSUADO CODE:
	// Get next rank in deck
	// It's the wanted rank?
	// -- Y: enough 5 cards?
	// ---- Y: we found straight hand
	// ---- N: continue finding
	// -- N: cut line from current count, continue with next one
	vector<int> vFoundRanks = { beginRankDeck };
	int count = 0;
	bool overEndRank = false;

	// Sanity! we dont want bad algorithm crash our app
	int times = 0;
	vector<int> wantedCards;
	while (true)
	{
		times++;
		count++;
		// Dont forget to set reachEnd if we over the last rank
		if (count > allValidRanks.size() - 1)
		{
			overEndRank = true;
			count = 0;
		}

		curRank = allValidRanks.at(count);
		wantedRank = getNextRank(lastRank);

		// Do we have which rank we want?
		if (curRank == wantedRank)
		{
			vFoundRanks.push_back(wantedRank);
			// Do we find the wanted straight?
			if (vFoundRanks.size() == 5)
			{
				// Ignore if found straight do not have required rank
				if (std::find(vFoundRanks.begin(), vFoundRanks.end(), requiredRank) == vFoundRanks.end())
				{
					vFoundRanks.erase(vFoundRanks.begin(), vFoundRanks.begin() + 1);
					beginRankStraight = vFoundRanks.at(0);
					lastRank = wantedRank;
					continue;
				}
				// Ok now we should know whether straight hand we found is stronger attacked hand?
				// Attacked straight is strongest(include card 2 and 6)
				if (bStrongestStraight)
				{
					// Found straight must have rank 2, 6 and also card suit of rank 6 is higher than attacker card
					// We have stronger hand
					if (std::find(vFoundRanks.begin(), vFoundRanks.end(), Card::RANK_2) == vFoundRanks.end()
						|| std::find(vFoundRanks.begin(), vFoundRanks.end(), Card::RANK_6) == vFoundRanks.end()
						|| getStrongestCardWithRank(Card::RANK_6, allCardIds) > strongestAttackedCard)
					{
						wantedCards = vector<int> {};
						for (int i = 0, l = vFoundRanks.size(); i < l; i++)
						{
							vector<int> foundCards = getCardsWithSameRank(vFoundRanks.at(i), allCardIds);
							// With 6 we get the highest card
							if (vFoundRanks.at(i) == Card::RANK_6) wantedCards.push_back(*(max_element(foundCards.begin(), foundCards.end())));
							else wantedCards.push_back(foundCards.at(0));
						}
						foundHand = new CardHand(CardHand::STRAIGHT, wantedCards);
						break;
					}
					// We have weaker hand
					else
					{
						vFoundRanks.erase(vFoundRanks.begin(), vFoundRanks.begin() + 1);
						beginRankStraight = vFoundRanks.at(0);
					}
				}

				// If attacked straight is weakest(include card 2 and 5)
				else if (bWeakestStraight)
				{
					// We have weaker hand
					if (std::find(vFoundRanks.begin(), vFoundRanks.end(), Card::RANK_2) == vFoundRanks.end()
						|| std::find(vFoundRanks.begin(), vFoundRanks.end(), Card::RANK_5) == vFoundRanks.end()
						|| getStrongestCardWithRank(Card::RANK_5, allCardIds) < strongestAttackedCard)
					{
						vFoundRanks.erase(vFoundRanks.begin(), vFoundRanks.begin() + 1);
						beginRankStraight = vFoundRanks.at(0);
					}
					// We haver stronger hand
					else
					{
						wantedCards = vector<int> {};
						for (int i = 0, l = vFoundRanks.size(); i < l; i++)
						{
							vector<int> foundCards = getCardsWithSameRank(vFoundRanks.at(i), allCardIds);
							// With 5 we get the strongest card
							if (vFoundRanks.at(i) == Card::RANK_5) wantedCards.push_back(*(max_element(foundCards.begin(), foundCards.end())));
							else wantedCards.push_back(foundCards.at(0));
						}
						foundHand = new CardHand(CardHand::STRAIGHT, wantedCards);
						break;
					}
				}

				// Normal case
				else
				{
					vector<int> vTmpRank = vFoundRanks;
					vector<int>::iterator it = std::find(vTmpRank.begin(), vTmpRank.end(), Card::RANK_2);
					if (it != vTmpRank.end()) vTmpRank.erase(it, it+1);
					int highestRank = (*(max_element(vTmpRank.begin(), vTmpRank.end())));
					int strongestCardWithRankInDeck = getStrongestCardWithRank(highestRank, allCardIds);

					// We have stronger hand
					if (strongestCardWithRankInDeck > strongestAttackedCard)
					{
						wantedCards = vector<int> {};
						for (int i = 0, l = vFoundRanks.size(); i < l; i++)
						{
							vector<int> foundCards = getCardsWithSameRank(vFoundRanks.at(i), allCardIds);
							if (vFoundRanks.at(i) == highestRank) wantedCards.push_back(strongestCardWithRankInDeck);
							else wantedCards.push_back(foundCards.at(0));
						}
						foundHand = new CardHand(CardHand::STRAIGHT, wantedCards);
						break;
					}
					// We have weaker hand
					else
					{
						vFoundRanks.erase(vFoundRanks.begin(), vFoundRanks.begin() + 1);
						beginRankStraight = vFoundRanks.at(0);
					}
				}
			}
			// Else continue finding next one
			lastRank = wantedRank;
		}
		// It's not wanted rank, cut line and begin from new rank if we can
		else
		{
			if (overEndRank)
			{
				break;
			}
			beginRankStraight = curRank;
			lastRank = beginRankStraight;
			vFoundRanks = vector<int>{beginRankStraight};
		}

		if (times > 20)
		{
			cocos2d::log("Bad find straight algorithm");
			break;
		}
	}

	return foundHand;
}
inline CardHand* CardHelper::getStrongerFlushHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds )
{
	vector<int> attackedCards = hand->getCardIds();
	int orderSuit = getSuit(attackedCards.at(0));
	int strongestAttackedCard = getStrongestCard(attackedCards);

	// Condition in case has required cards
	vector<int> needCheckSuits;
	if (requiredCardIds.size() > 0)
	{
		needCheckSuits = vector<int> {getSuit(requiredCardIds.at(0))};
	}
	else
	{
		needCheckSuits = getAllSuits(allCardIds);
	}

	int suit;
	CardHand* foundHand;
	vector<int> cardsWithSameSuit;
	// Iterate every suits in our deck
	for (int i = 0, l = needCheckSuits.size(); i < l; i++)
	{
		suit = needCheckSuits.at(i);

		// Ignore lower suit
		if (orderSuit > suit) continue;

		cardsWithSameSuit = getCardsWithSameSuit(suit, allCardIds);
		// We have one flush hand, but it's suit is same or higher?
		if (cardsWithSameSuit.size() >= 5)
		{
			// Same suit, we must have one card with higher rank or stronger(of course it's same suit now)
			if (orderSuit == suit && getStrongestCard(cardsWithSameSuit) < strongestAttackedCard)
			{
				continue;
			}
			foundHand = new CardHand(CardHand::FLUSH, cardsWithSameSuit);
		}
	}


	return nullptr;
}
inline CardHand* CardHelper::getStrongerFullhouseHand(CardHand* hand, vector<int> allCardIds, vector<int> requiredCardIds)
{
	CardHand* foundHand = nullptr;

	// Get rank of three of a kind in attacked hand
	int attackedHand;
	vector<int> attackedCards = hand->getCardIds();
	vector<int> attackedRanks = getAllRanks(attackedCards);
	int rank;
	int beginRank;
	for (int i = 0, l = attackedRanks.size(); i < l; i++)
	{
		rank = attackedRanks.at(i);
		if (getCardsWithSameRank(rank, attackedCards).size() == 3)
		{
			break;
		}
	}
	beginRank = rank + 1;

	int requiredRank;
	vector<int> vTmpCard = {};
	CardHand* threeHand;
	if (requiredCardIds.size() > 0)
	{
		requiredRank = getRank(requiredCardIds.at(0));
		// Selected card is in valid
		if (requiredRank <= beginRank)
		{
			return nullptr;
		}
		threeHand = getThreeOfAKindHand(allCardIds, requiredCardIds);
	}
	else
	{
		// Ignore all cards with lower rank
		for (int i = 0, l = allCardIds.size(); i < l; i++)
		{
			if (getRank(allCardIds.at(i) >= beginRank))
			{
				vTmpCard.push_back(allCardIds.at(i));
			}
		}
		threeHand = getThreeOfAKindHand(vTmpCard, requiredCardIds);
	}

	if (threeHand == nullptr) return nullptr;

	// Ignore all cards in three of a kind hand
	vector<int> threeHandCards = threeHand->getCardIds();
	vector<int>::iterator it;
	int checkingCard;
	for (int i = 0, l = threeHandCards.size(); i < l; i++)
	{
		checkingCard = threeHandCards.at(i);
		it = std::find(allCardIds.begin(), allCardIds.end(), checkingCard);
		if (it != allCardIds.end()) allCardIds.erase(it, it + 1);
	}

	// Continue with a pair
	CardHand* pairHand = getPairHand(allCardIds, requiredCardIds);
	if (pairHand != nullptr)
	{
		vector<int> pairHandCards = pairHand->getCardIds();
		vector<int> foundCards = threeHandCards;
		foundCards.push_back(pairHandCards.at(0));
		foundCards.push_back(pairHandCards.at(1));
		foundHand = new CardHand(CardHand::FULL_HOUSE, foundCards);
	}

	return foundHand;
}
inline CardHand* CardHelper::getStrongerFourOfAKindHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds ){return nullptr;}
inline CardHand* CardHelper::getStrongerStraightFlushHand(CardHand* hand, vector<int> cardIds, vector<int> requiredCardIds ){return nullptr;}

CardHand* CardHelper::getHand(vector<int> cardIds)
{
	CardHand* foundHand = getStraightFlushHand(cardIds);
	if (foundHand == nullptr) foundHand = getFourOfAKindHand(cardIds);
	if (foundHand == nullptr) foundHand = getFullHouseHand(cardIds);
	if (foundHand == nullptr) foundHand = getFlushHand(cardIds);
	if (foundHand == nullptr) foundHand = getStraightHand(cardIds);
	if (foundHand == nullptr) foundHand = getThreeOfAKindHand(cardIds);
	if (foundHand == nullptr) foundHand = getTwoPairHand(cardIds);
	if (foundHand == nullptr) foundHand = getPairHand(cardIds);
	if (foundHand == nullptr) foundHand = new CardHand(CardHand::HIGH_CARD, vector<int> {getStrongestCard(cardIds)});
	return foundHand;
}

CardHand* CardHelper::getSusunHand(vector<int> cardIds)
{
	CardHand* foundHand = getStraightFlushHand(cardIds);
	if (foundHand == nullptr) foundHand = getExactFourOfAKindHand(cardIds);
	if (foundHand == nullptr) foundHand = getFullHouseHand(cardIds);
	if (foundHand == nullptr) foundHand = getFlushHand(cardIds);
	if (foundHand == nullptr) foundHand = getStraightHand(cardIds);
	if (foundHand == nullptr) foundHand = getThreeOfAKindHand(cardIds);
	if (foundHand == nullptr) foundHand = getTwoPairHand(cardIds);
	if (foundHand == nullptr) foundHand = getPairHand(cardIds);
	if (foundHand == nullptr) foundHand = new CardHand(CardHand::HIGH_CARD, vector<int> {getStrongestCard(cardIds)});
	return foundHand;
}

CardHand* CardHelper::getPairHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	int noCard = allCardIds.size();
	if (noCard < 2) return nullptr;

	CardHand* foundHand = nullptr;
	vector<int> allRanks = getAllRanks(allCardIds);
	vector<int> foundIds;
	int rank;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		rank = allRanks.at(i);
		foundIds = getCardsWithSameRank(rank, allCardIds);
		if (foundIds.size() == 2)
		{
			foundHand = new CardHand(CardHand::PAIR, foundIds);
			break;
		}
	}

	return foundHand;
}

CardHand* CardHelper::getTwoPairHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	vector<CardHand*> vHand = getAllTwoPairHands(allCardIds);
	return (vHand.size() > 0 ? vHand.at(0) : nullptr);
}

CardHand* CardHelper::getThreeOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	int noCard = allCardIds.size();
	if (noCard < 3) return nullptr;

	CardHand* foundHand = nullptr;
	vector<int> allRanks;

	if (requiredCardIds.size() > 0)
	{
		allRanks = vector<int> {getRank(requiredCardIds.at(0))};
	}
	else
	{
		allRanks = getAllRanks(allCardIds);
	}

	vector<int> foundIds;
	int rank;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		rank = allRanks.at(i);
		foundIds = getCardsWithSameRank(rank, allCardIds);
		if (foundIds.size() == 3)
		{
			foundHand = new CardHand(CardHand::THREE_OF_A_KIND, foundIds);
			break;
		}
	}

	return foundHand;
}
CardHand* CardHelper::getFourOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	int noCard = allCardIds.size();
	if (noCard < 5) return nullptr;

	// First we should find one four cards with same suit
	CardHand* foundHand = nullptr;
	vector<int> allRanks = getAllRanks(allCardIds);
	vector<int> foundIds;
	int rank;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		rank = allRanks.at(i);
		foundIds = getCardsWithSameRank(rank, allCardIds);
		if (foundIds.size() == 4)
		{
			break;
		}
	}

	if (foundIds.size() != 4) return nullptr;

	// Then we need one more random card which is not same as one of found four cards
	int id;
	vector<int>::iterator it;
	for (int i = 0; i < noCard; i++)
	{
		id = allCardIds.at(i);
		it = std::find(foundIds.begin(), foundIds.end(), id);
		if (it == foundIds.end())
		{
			foundIds.push_back(id);
			break;
		}
	}
	foundHand = new CardHand(CardHand::FOUR_OF_A_KIND, foundIds);
	return foundHand;
}

CardHand* CardHelper::getStraightHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	vector<int> allValidRanks = getAllRanks(allCardIds);
	// Not enough rank?
	if (allValidRanks.size() < 5) return nullptr;
	std::sort(allValidRanks.begin(), allValidRanks.end());

	// We must check all rank in deck util begin rank in straight reach begin rank in deck again
	// First start from lowest rank in deck. We continue util find enougth 5 card with in-line rank
	// or reach the begining.
	CardHand* foundHand = nullptr;
	int beginRankDeck = allValidRanks.at(0);
	int beginRankStraight = allValidRanks.at(0);
	int lastRank = beginRankDeck;
	int wantedRank;
	int curRank;

	// PSUADO CODE:
	// Get next rank in deck
	// It's the wanted rank?
	// -- Y: enough 5 cards?
	// ---- Y: we found straight hand
	// ---- N: continue finding
	// -- N: cut line from current count, continue with next one
	vector<int> vFoundRanks = { beginRankDeck };
	int count = 0;
	bool overEndRank = false;

	// Sanity! we dont want bad algorithm crash our app
	int times = 0;
	while (true)
	{
		times++;
		count++;
		// Dont forget to set reachEnd if we over the last rank
		if (count > allValidRanks.size() - 1)
		{
			overEndRank = true;
			count = 0;
		}

		curRank = allValidRanks.at(count);
		wantedRank = getNextRank(lastRank);	

		// Do we have which rank we want?
		if (curRank == wantedRank)
		{
			vFoundRanks.push_back(wantedRank);
			// Do we find the wanted straight?
			if (vFoundRanks.size() == 5)
			{
				// Ok now we should get cards with target rank, it should be the smallest one
				vector<int> wantedCards = {};
				for (int i = 0, l = vFoundRanks.size(); i < l; i++)
				{
					vector<int> foundCards = getCardsWithSameRank(vFoundRanks.at(i), allCardIds);
					wantedCards.push_back(foundCards.at(0));
				}
				foundHand = new CardHand(CardHand::STRAIGHT, wantedCards);
				break;
			}
			// Else continue finding next one
			lastRank = wantedRank;
		}
		// It's not wanted rank, cut line and begin from new rank if we can
		else 
		{
			if (overEndRank)
			{
				break;
			}
			beginRankStraight = curRank;
			lastRank = beginRankStraight;
			vFoundRanks = vector<int>{beginRankStraight};
		}
		
		if (times > 20)
		{
			cocos2d::log("Bad find straight algorithm");
			break;
		}
	}

	return foundHand;
}
CardHand* CardHelper::getFlushHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	CardHand* foundHand = nullptr;
	vector<int> checkingSuits;
	if (requiredCardIds.size() > 0)
	{
		checkingSuits = vector<int> {getSuit(requiredCardIds.at(0))};
	}
	else
	{
		checkingSuits = getAllSuits(allCardIds);
	}
	
	int suit;
	for (int i = 0, l = checkingSuits.size(); i < l; i++)
	{
		suit = checkingSuits.at(i);
		vector<int> cardsWithSuit = getCardsWithSameSuit(suit, allCardIds);
		if (cardsWithSuit.size() >= 5)
		{
			// We just get 5 smallest cards
			std::sort(cardsWithSuit.begin(), cardsWithSuit.end(), sortIncrease);
			cardsWithSuit.erase(cardsWithSuit.begin() + 5, cardsWithSuit.end());
			foundHand = new CardHand(CardHand::FLUSH, cardsWithSuit);
		}
	}
	return foundHand;
}
CardHand* CardHelper::getFullHouseHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	CardHand* foundHand = nullptr;

	CardHand* threeHand = getThreeOfAKindHand(allCardIds, requiredCardIds);
	if (threeHand == nullptr) return nullptr;

	// Ignore all cards in three of a kind hand
	vector<int> threeHandCards = threeHand->getCardIds();
	vector<int>::iterator it;
	int checkingCard;
	for (int i = 0, l = threeHandCards.size(); i < l; i++)
	{
		checkingCard = threeHandCards.at(i);
		it = std::find(allCardIds.begin(), allCardIds.end(), checkingCard);
		if (it!=allCardIds.end()) allCardIds.erase(it, it + 1);
	}

	// Continue with a pair
	CardHand* pairHand = getPairHand(allCardIds, requiredCardIds);
	if (pairHand != nullptr)
	{
		vector<int> pairHandCards = pairHand->getCardIds();
		vector<int> foundCards = threeHandCards;
		foundCards.push_back(pairHandCards.at(0));
		foundCards.push_back(pairHandCards.at(1));
		foundHand = new CardHand(CardHand::FULL_HOUSE, foundCards);
	}

	return foundHand;
}
CardHand* CardHelper::getStraightFlushHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	vector<CardHand*> vHand = getAllStraightFlushHands(allCardIds);
	if (vHand.size() > 0) return vHand.at(0);
	return nullptr;
}


vector<CardHand*> CardHelper::getAllPairHands(vector<int> allCardIds)
{
	vector<CardHand*> vHand = {};

	vector<int> vAllRank = getAllRanks(allCardIds);
	for (int i = 0, li = vAllRank.size(); i < li; i++)
	{
		int rank = vAllRank.at(i);
		vector<int> cardsSameRank = getCardsWithSameRank(rank, allCardIds);
		int noCard = cardsSameRank.size();
		if (noCard >= 2)
		{
			std::reverse(cardsSameRank.begin(), cardsSameRank.end());
			vector<vector<int>> vFoundCombination = getCombinations(2, cardsSameRank);
			std::reverse(vFoundCombination.begin(), vFoundCombination.end());
			for (int j = 0, lj = vFoundCombination.size(); j < lj; j++)
			{
				vHand.push_back(new CardHand(CardHand::PAIR, vFoundCombination.at(j)));
			}
		}
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllThreeOfAKindHands(vector<int> allCardIds)
{
	vector<CardHand*> vHand = {};

	// Get all three of a kind 
	vector<int> vAllRank = getAllRanks(allCardIds);
	for (int i = 0, li = vAllRank.size(); i < li; i++)
	{
		int rank = vAllRank.at(i);
		vector<int> cardsSameRank = getCardsWithSameRank(rank, allCardIds);
		int noCard = cardsSameRank.size();
		if (noCard >= 3)
		{
			std::reverse(cardsSameRank.begin(), cardsSameRank.end());
			vector<vector<int>> vFoundCombination = getCombinations(3, cardsSameRank);
			std::reverse(vFoundCombination.begin(), vFoundCombination.end());
			for (int j = 0, lj = vFoundCombination.size(); j < lj; j++)
			{
				vector<int> combination = vFoundCombination.at(j);
				vHand.push_back(new CardHand(CardHand::THREE_OF_A_KIND, vFoundCombination.at(j)));
			}
		}
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllTwoPairHands(vector<int> allCardIds)
{
	vector<CardHand*> vHand = {};
	vector<CardHand*> allPairHands = getAllPairHands(allCardIds);

	for (int i = 0, l = allPairHands.size(); i < l-1; i++)
	{
		CardHand* originHand = allPairHands.at(i);
		vector<int> originCardIds = originHand->getCardIds();
		int originRank = getRank(originCardIds.at(0));
		for (int j = i + 1; j < l; j++)
		{
			CardHand* bonusHand = allPairHands.at(j);
			vector<int> bonusCardIds = bonusHand->getCardIds();
			int bonusRank = getRank(bonusCardIds.at(0));
			if (originRank != bonusRank)
			{
				vector<int> lastCardIds = originCardIds;
				lastCardIds.insert(lastCardIds.end(), bonusCardIds.begin(), bonusCardIds.end());
				vHand.push_back(new CardHand(CardHand::TWO_PAIR, lastCardIds));
			}
		}
	}
	return vHand;
}

vector<CardHand*> CardHelper::getAllFlushHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;

	int attackerLv = -1;
	int flushLv = getComplexHandLevel(CardHand::FLUSH);
	if (attackerHand != nullptr)
	{
		int attackerType = attackerHand->getType();
		attackerLv = getComplexHandLevel(attackerType);

		if (attackerLv == -1 || flushLv < attackerLv) return vHand;
	}

	vector<int> checkingSuits = getAllSuits(allCardIds);
	CardHand* hand;
	int suit;
	for (int i = 0, l = checkingSuits.size(); i < l; i++)
	{
		suit = checkingSuits.at(i);
		vector<int> cardsWithSuit = getCardsWithSameSuit(suit, allCardIds);
		if (cardsWithSuit.size() >= 5)
		{
			std::sort(cardsWithSuit.begin(), cardsWithSuit.end(), sortIncrease);
			std::reverse(cardsWithSuit.begin(), cardsWithSuit.end());
			vector<vector<int>> vFoundCombination = getCombinations(5, cardsWithSuit);
			std::reverse(vFoundCombination.begin(), vFoundCombination.end());
			for (int j = 0, lj = vFoundCombination.size(); j < lj; j++)
			{
				vHand.push_back(new CardHand(CardHand::FLUSH, vFoundCombination.at(j)));
			}
		}
	}

	if (flushLv == attackerLv)
	{
		vector<int> attackerCards = attackerHand->getCardIds();
		int attackerSuit = getSuit(attackerCards.at(0));
		int strongestAttackerCard = getStrongestCard(attackerCards);
		int i, li;
		for (i = 0, li = vHand.size(); i < li; i++)
		{
			hand = vHand.at(i);
			vector<int> handCards = hand->getCardIds();
			suit = getSuit(handCards.at(0));
			int strongestHandCard = getStrongestCard(hand->getCardIds());
			if (suit > attackerSuit || (suit == attackerSuit && strongestHandCard > strongestAttackerCard))
			{
				break;
			}
		}
		vHand.erase(vHand.begin(), vHand.begin() + i);
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllStraightHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;

	vector<int> allValidRanks = getAllRanks(allCardIds);
	// Not enough rank?
	if (allValidRanks.size() < 5) return vHand;

	int straightLv = getComplexHandLevel(CardHand::STRAIGHT);
	int attackerLv = -1;
	int strongestAttackerCard = -1;
	bool bStrongest = false;
	bool bSmallest = false;
	if (attackerHand != nullptr)
	{
		attackerLv = getComplexHandLevel(attackerHand->getType());
		if (attackerLv > straightLv) return vHand;
		else if (attackerLv == straightLv)
		{
			vector<int> attackerCards = attackerHand->getCardIds();
			vector<int> attackerRanks = getAllRanks(attackerCards);
			// Incase smallest straight
			if (hasRank(Card::RANK_ACE, attackerCards) && hasRank(Card::RANK_5, attackerCards))
			{
				bSmallest = true;
				strongestAttackerCard = getCardsWithSameRank(Card::RANK_5, attackerCards).at(0);
			}
			// Incase strongest straight
			else if (hasRank(Card::RANK_2, attackerCards) && hasRank(Card::RANK_6, attackerCards))
			{
				bStrongest = true;
				strongestAttackerCard = getCardsWithSameRank(Card::RANK_6, attackerCards).at(0);
			}
			// In normal case
			else
			{
				strongestAttackerCard = getStrongestCard(attackerHand->getCardIds());
			}
		}
	}

	CardHand* foundHand = nullptr;
	int beginRankDeck = allValidRanks.at(0);
	int beginRankStraight = allValidRanks.at(0);
	int lastRank = beginRankDeck;
	int wantedRank;
	int curRank = -1;

	// PSUADO CODE:
	// Get next rank in deck
	// It's the wanted rank?
	// -- Y: enough 5 cards?
	// ---- Y: we found straight hand
	// ---- N: continue finding
	// -- N: cut line from current count, continue with next one
	vector<int> vFoundRanks = { beginRankDeck };
	int count = 0;
	curRank = allValidRanks.at(count);

	// First round from 3->ACE
	vector<vector<int>> vFirstCombination = {};
	while (curRank != Card::RANK_ACE && count < allValidRanks.size()-1)
	{
		count++;
		curRank = allValidRanks.at(count);
		wantedRank = getNextRank(lastRank);

		// Do we have which rank we want?
		if (curRank == wantedRank)
		{
			vFoundRanks.push_back(wantedRank);
			// Do we find the wanted straight?
			if (vFoundRanks.size() == 5)
			{
				// Ok now we should get cards with target rank, it should be the smallest one
				vector<vector<int>> vCombination = getStraightCardsFromRanks(vFoundRanks, allCardIds);
				
				for (int j = 0, lj = vCombination.size(); j < lj; j++)
				{
					vFirstCombination.push_back(vCombination.at(j));
				}

				// Continue with next rank
				vFoundRanks.erase(vFoundRanks.begin(), vFoundRanks.begin() + 1);
				beginRankStraight = vFoundRanks.at(0);
			}
			// Else continue finding next one
			lastRank = wantedRank;
		}
		// It's not wanted rank, cut line and begin from new rank if we can
		else
		{
			beginRankStraight = curRank;
			lastRank = beginRankStraight;
			vFoundRanks = vector<int>{beginRankStraight};
		}
	}

	for (int i = 0, li = vFirstCombination.size(); i < li; i++)
	{
		vector<int> foundCards = vFirstCombination.at(i);
		vHand.push_back(new CardHand(CardHand::STRAIGHT, foundCards));
	}

	// Do we have strongest straight?
	vector<int> vSecondValidRanks = {};
	for (int i = 0, li = allValidRanks.size(); i < li; i++)
	{
		int rank = allValidRanks.at(i);
		if (rank > Card::RANK_ACE || rank < Card::RANK_7) vSecondValidRanks.push_back(rank);
	}
	if (vSecondValidRanks.size() == 5)
	{
		// Ok now we should get cards with target rank, it should be the smallest one
		vector<vector<int>> vCombination = getStraightCardsFromRanks(vSecondValidRanks, allCardIds);

		for (int j = 0, lj = vCombination.size(); j < lj; j++)
		{
			vHand.push_back(new CardHand(CardHand::STRAIGHT, vCombination.at(j)));
		}
	}

	// Do we have smallest straight?
	vSecondValidRanks = {};
	for (int i = 0, li = allValidRanks.size(); i < li; i++)
	{
		int rank = allValidRanks.at(i);
		if (rank > Card::RANK_KING || rank < Card::RANK_6) vSecondValidRanks.push_back(rank);
	}
	if (vSecondValidRanks.size() == 5)
	{
		// Ok now we should get cards with target rank, it should be the smallest one
		vector<vector<int>> vCombination = getStraightCardsFromRanks(vSecondValidRanks, allCardIds);

		for (int j = 0, lj = vCombination.size(); j < lj; j++)
		{
			vHand.insert(vHand.begin(), new CardHand(CardHand::STRAIGHT, vCombination.at(j)));
		}
	}
	
	// Found hands are stronger than attacker?
	if (attackerLv == straightLv)
	{
		int i, li;
		for (i = 0, li = vHand.size(); i < li; i++)
		{
			vector<int> foundCards = vHand.at(i)->getCardIds();
			int strongestHandCard;

			if (hasRank(Card::RANK_ACE, foundCards) && hasRank(Card::RANK_5, foundCards))
			{
				strongestHandCard = getCardsWithSameRank(Card::RANK_5, foundCards).at(0);
				if (bSmallest && strongestHandCard > strongestAttackerCard) break;
			}
			else if (hasRank(Card::RANK_2, foundCards) && hasRank(Card::RANK_6, foundCards))
			{
				strongestHandCard = getCardsWithSameRank(Card::RANK_6, foundCards).at(0);
				if (!bStrongest || strongestHandCard > strongestAttackerCard) break;
			}
			else
			{
				strongestHandCard = getStrongestCard(foundCards);
				if (bSmallest || (!bStrongest && strongestHandCard > strongestAttackerCard)) break;
			}
		}
		vHand.erase(vHand.begin(), vHand.begin() + i);
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllFullhouseHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;

	vector<CardHand*> vThreeKindHand = getAllThreeOfAKindHands(allCardIds);

	int fullhouseLv = getComplexHandLevel(CardHand::FULL_HOUSE);
	int attackerLv = -1;

	if (attackerHand != nullptr)
	{
		attackerLv = getComplexHandLevel(attackerHand->getType());
		if (attackerLv > fullhouseLv) return vHand;
	}

	int noThreeKind = vThreeKindHand.size();
	for (int i = 0; i < noThreeKind; i++)
	{
		// We must ignore all cards in triad before finding pair
		vector<int> validCards = {};
		vector<int> invalidCards = vThreeKindHand.at(i)->getCardIds();
		for (int j = 0, lj = allCardIds.size(); j < lj; j++)
		{
			if (std::find(invalidCards.begin(), invalidCards.end(), allCardIds.at(j)) == invalidCards.end())
			{
				validCards.push_back(allCardIds.at(j));
			}
		}

		// Then we find all pair we can
		vector<CardHand*> vPairHand = getAllPairHands(validCards);
		vector<int> vBeginCard = invalidCards;
		for (int j = 0, lj = vPairHand.size(); j < lj; j++)
		{
			vector<int> foundCards = vBeginCard;
			vector<int> extraCards = vPairHand.at(j)->getCardIds();
			for (int k = 0, lk = extraCards.size(); k < lk; k++)
			{
				foundCards.push_back(extraCards.at(k));
			}
			vHand.push_back(new CardHand(CardHand::FULL_HOUSE, foundCards));
		}
	}

	if (fullhouseLv == attackerLv)
	{
		vector<int> vAttackerCard = attackerHand->getCardIds();
		vector<int> vRank = getAllRanks(vAttackerCard);
		vector<int> cardsInTriad = getCardsWithSameRank(vRank.at(0), vAttackerCard);
		if (cardsInTriad.size() != 3) cardsInTriad = getCardsWithSameRank(vRank.at(1), vAttackerCard);
		int strongestAttackerCard = getStrongestCard(cardsInTriad);

		int i, li;
		for (i = 0, li = vHand.size(); i < li; i++)
		{
			CardHand* hand = vHand.at(i);
			vector<int> foundCards = hand->getCardIds();
			vRank = getAllRanks(foundCards);
			cardsInTriad = getCardsWithSameRank(vRank.at(0), foundCards);
			if (cardsInTriad.size() != 3) cardsInTriad = getCardsWithSameRank(vRank.at(1), foundCards);
			int strongestHandCard = getStrongestCard(cardsInTriad);
			if (strongestHandCard > strongestAttackerCard)
			{
				break;
			}
		}
		vHand.erase(vHand.begin(), vHand.begin() + i);
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllFourOfAKindHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;

	int fourOfAKindLv = getComplexHandLevel(CardHand::FOUR_OF_A_KIND);
	int attackerLv = -1;
	int attackerRank = -1;
	if (attackerHand != nullptr && attackerHand->getType() != CardHand::HIGH_CARD)
	{
		attackerLv = getComplexHandLevel(attackerHand->getType());
		if (attackerLv > fourOfAKindLv)
		{
			return vHand;
		}
		else if (attackerLv == fourOfAKindLv)
		{
			vector<int> vAttackerCard = attackerHand->getCardIds();
			vector<int> vAttackerRank = getAllRanks(vAttackerCard);
			attackerRank = getCardsWithSameRank(vAttackerRank.at(0), vAttackerCard).size() == 4 ? vAttackerRank.at(0) : vAttackerRank.at(1);
		}
	}

	vector<int> vRank = getAllRanks(allCardIds);
	vector<int> foundCards;
	for (int i = 0, l = vRank.size(); i < l; i++)
	{
		int rank = vRank.at(i);
		vector<int> cardsSameRank = getCardsWithSameRank(rank, allCardIds);
		if (cardsSameRank.size() == 4 && rank > attackerRank)
		{
			// Get hand with four found cards and plus one another card
			for (int j = 0, lj = allCardIds.size(); j < lj; j++)
			{
				int id = allCardIds.at(j);
				if (std::find(cardsSameRank.begin(), cardsSameRank.end(), id) == cardsSameRank.end())
				{
					foundCards = cardsSameRank;
					foundCards.push_back(id);
					CardHand* hand = new CardHand(CardHand::FOUR_OF_A_KIND, foundCards);
					vHand.push_back(hand);
					break;
				}
			}
		}
	}

	return vHand;
}

vector<CardHand*> CardHelper::getAllRoyalStraightFlushHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;
    vHand = getAllStraightFlushHands(allCardIds, attackerHand);
    for(int i = 0; i < vHand.size(); i++)
    {
        if(CardHelper::getRank(vHand.at(i)->getCardIds().at(0)) != Card::RANK_10)
        {
            vHand.erase(vHand.begin() + i);
        }
    }
    return vHand;
}

vector<CardHand*> CardHelper::getAllStraightFlushHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 5) return vHand;

	vector<int> allSuits = getAllSuits(allCardIds);

	int straightFlushLv = getComplexHandLevel(CardHand::STRAIGHT_FLUSH);
	int attackerLv = -1;
	int attackerSuit = -1;
	int strongestAttackerCard = -1;
	if (attackerHand != nullptr)
	{
		attackerLv = getComplexHandLevel(attackerHand->getType());
		if (attackerLv > straightFlushLv) return vHand;
		if (attackerLv == straightFlushLv)
		{
			strongestAttackerCard = getStrongestCard(attackerHand->getCardIds());
			attackerSuit = getSuit(strongestAttackerCard);
		}
	}

	std::reverse(allSuits.begin(), allSuits.end());
	for (int i = 0, li = allSuits.size(); i < li; i++)
	{
		int suit = allSuits.at(i);
		vector<int> vCardSameSuit = getCardsWithSameSuit(suit, allCardIds);
		int strongestHandCard = getStrongestCard(vCardSameSuit);
		if (vCardSameSuit.size() >= 5 && (suit > attackerSuit || (suit == attackerSuit && strongestHandCard > strongestAttackerCard)))
		{
			vector<CardHand*> vTmpHand = getAllStraightHands(vCardSameSuit);
			for (int j = 0, lj = vTmpHand.size(); j < lj; j++)
			{
				CardHand* hand = vTmpHand.at(j);
				vHand.push_back(new CardHand(CardHand::STRAIGHT_FLUSH, hand->getCardIds()));
			}
		}
	}
	return vHand;
}

CardHand* CardHelper::getExactFourOfAKindHand(vector<int> allCardIds, vector<int> requiredCardIds)
{
	int noCard = allCardIds.size();
	if (noCard < 4) return nullptr;

	// First we should find one four cards with same suit
	CardHand* foundHand = nullptr;
	vector<int> allRanks = getAllRanks(allCardIds);
	vector<int> foundIds;
	int rank;
	for (int i = 0, l = allRanks.size(); i < l; i++)
	{
		rank = allRanks.at(i);
		foundIds = getCardsWithSameRank(rank, allCardIds);
		if (foundIds.size() == 4)
		{
			foundHand = new CardHand(CardHand::FOUR_OF_A_KIND, foundIds);
			break;
		}
	}
	return foundHand;
}

vector<CardHand*> CardHelper::getAllExactFourOfAKindHands(vector<int> allCardIds, CardHand* attackerHand)
{
	vector<CardHand*> vHand = {};

	// Not enough cards
	if (allCardIds.size() < 4) return vHand;

	int fourOfAKindLv = getComplexHandLevel(CardHand::FOUR_OF_A_KIND);
	int attackerLv = -1;
	int attackerRank = -1;
	if (attackerHand != nullptr)
	{
		attackerLv = getComplexHandLevel(attackerHand->getType());
		if (attackerLv > fourOfAKindLv)
		{
			return vHand;
		}
		else if (attackerLv == fourOfAKindLv)
		{
			vector<int> vAttackerCard = attackerHand->getCardIds();
			vector<int> vAttackerRank = getAllRanks(vAttackerCard);
			attackerRank = getCardsWithSameRank(vAttackerRank.at(0), vAttackerCard).size() == 4 ? vAttackerRank.at(0) : vAttackerRank.at(1);
		}
	}

	vector<int> vRank = getAllRanks(allCardIds);
	vector<int> foundCards;
	for (int i = 0, l = vRank.size(); i < l; i++)
	{
		int rank = vRank.at(i);
		vector<int> cardsSameRank = getCardsWithSameRank(rank, allCardIds);
		if (cardsSameRank.size() == 4 && rank > attackerRank)
		{
			CardHand* hand = new CardHand(CardHand::FOUR_OF_A_KIND, foundCards);
			vHand.push_back(hand);	
		}
	}

	return vHand;
}

bool CardHelper::compare(CardHand* handA, CardHand* handB)
{
	int levelHandA = getHandLevel(handA->getType());
	int levelHandB = getHandLevel(handB->getType());
	if (levelHandA < levelHandB) return false;
	else if (levelHandA > levelHandB) return true;

	// Two hands with equal level
	int type = handA->getType();
	vector<int> cardsHandA = handA->getCardIds();
	vector<int> cardsHandB = handB->getCardIds();
	if (CardHand::HIGH_CARD     	 == type 
		|| CardHand::PAIR            == type 
		|| CardHand::TWO_PAIR        == type
		|| CardHand::THREE_OF_A_KIND == type 
		|| CardHand::STRAIGHT        == type)
	{
        vector<int> cardsA = handA->getCardIds();
        vector<int> cardsB = handB->getCardIds();
        std::sort(cardsA.begin(), cardsA.end());
        std::sort(cardsB.begin(), cardsB.end());
        bool hasResult = false;

        // First check by ranks
        while (cardsA.size() > 0 && cardsB.size() > 0) {
            int rankA = getRank(cardsA.at(cardsA.size() - 1));
            int rankB = getRank(cardsB.at(cardsB.size() - 1));
            if (rankA > rankB) {
                hasResult = true;
                return true;
            }
            else if (rankA < rankB){
                hasResult = true;
                return false;
            }
            cardsA.pop_back();
            cardsB.pop_back();
        }
        // All ranks are same, we use the strongest cards
		return (getStrongestCard(cardsHandA) > getStrongestCard(cardsHandB) ? true : false);
	}
	else if (CardHand::FLUSH == type || CardHand::STRAIGHT_FLUSH == type)
	{
		int suitHandA = getSuit(cardsHandA.at(0));
		int suitHandB = getSuit(cardsHandB.at(0));
		if (suitHandA > suitHandB) return true;
		else if (suitHandA < suitHandB) return false;
		else return (getStrongestCard(cardsHandA) > getStrongestCard(cardsHandB) ? true : false);
	}
	else if (CardHand::FOUR_OF_A_KIND == type)
	{
		int rankHandA = getRank(cardsHandA.at(0));
		if (getCardsWithSameRank(rankHandA, cardsHandA).size() != 4) rankHandA = getRank(cardsHandA.at(1));
		int rankHandB = getRank(cardsHandB.at(0));
		if (getCardsWithSameRank(rankHandB, cardsHandB).size() != 4) rankHandB = getRank(cardsHandB.at(1));
		return (rankHandA > rankHandB ? true : false);
	}
	return false;
}

// ---------------------------------------------------------
// ---------------------------------------------------------
// SORT DECK FUNCTIONS
// ---------------------------------------------------------
// ---------------------------------------------------------
void CardHelper::sortByHand(int type, vector<int> &cardIds){}

void CardHelper::sortByUpRank(vector<int> &cardIds)
{
	std::sort(cardIds.begin(), cardIds.end(), sortIncrease);
}

void CardHelper::sortByDownRank(vector<int> &cardIds)
{

}

void CardHelper::sortBySuit(vector<int> &cardIds)
{
	vector<int> cardsWithDiamondSuit = getCardsWithSameSuit(Card::SUIT_DIAMOND, cardIds);
	vector<int> cardsWithClubSuit = getCardsWithSameSuit(Card::SUIT_CLUB, cardIds);
	vector<int> cardsWithHeartSuit = getCardsWithSameSuit(Card::SUIT_HEART, cardIds);
	vector<int> cardsWithSpadeSuit = getCardsWithSameSuit(Card::SUIT_SPADE, cardIds);
	cardIds.clear();
	cardIds.insert(cardIds.end(), cardsWithDiamondSuit.begin(), cardsWithDiamondSuit.end());
	cardIds.insert(cardIds.end(), cardsWithClubSuit.begin(), cardsWithClubSuit.end());
	cardIds.insert(cardIds.end(), cardsWithHeartSuit.begin(), cardsWithHeartSuit.end());
	cardIds.insert(cardIds.end(), cardsWithSpadeSuit.begin(), cardsWithSpadeSuit.end());
}

void CardHelper::sortByStraight(vector<int> &cardIds)
{
	CardHand* straightHand = getStraightHand(cardIds);

	// Iterate until finding the last straight hand
	vector<int> foundCards = {};
	vector<int> leftCards = cardIds;
	while (straightHand != nullptr) {
		vector<int> straightCards = straightHand->getCardIds();
		foundCards.insert(foundCards.begin(), straightCards.begin(), straightCards.end());

		vector<int> tmpCards = leftCards;
		leftCards = {};
		for (int i = 0, l = tmpCards.size(); i < l; i++) {
			if (std::find(straightCards.begin(), straightCards.end(), tmpCards.at(i)) == straightCards.end()) {
				leftCards.push_back(tmpCards.at(i));
			}
		}
		straightHand = getStraightHand(leftCards);
	}

	std::sort(cardIds.begin(), cardIds.end());
	for (int i = 0, l = cardIds.size(); i < l; i++){
		if (std::find(foundCards.begin(), foundCards.end(), cardIds.at(i)) == foundCards.end()) {
			foundCards.push_back(cardIds.at(i));
		}
	}

	cardIds.clear();
	cardIds.insert(cardIds.end(), foundCards.begin(), foundCards.end());
}

