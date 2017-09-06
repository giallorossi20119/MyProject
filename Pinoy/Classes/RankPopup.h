//
//  RankPopup.h
//  IndoGame
//
//  Created by longnh on 9/26/14.
//
//
#ifndef __IndoGame__RankPopup__
#define __IndoGame__RankPopup__

#include <iostream>
#include "CMDBantingData.h"
#include "BaseScene.h"
#include "Constant.h"

class RankPopup : public BasePopup
{
public:
	RankPopup();
	~RankPopup();

	void onOpen();
	void onClose();
	void fillRanks(int type);
	void onBtnEClick(Ref *pSender, Widget::TouchEventType type);
	void onBtnMClick(Ref *pSender, Widget::TouchEventType type);
	void recieveRankData(CMD2Rank* obj);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
	Layout* m_pItemRank;
	ListView* m_pListView;
	vector<CMDRankData*>* rankM;
	vector<CMDRankData*>* rankE;
	Button* m_pBtnM;
	Button* m_pBtnE;
};

#endif /* defined(__IndoGame__RankPopup__) */
