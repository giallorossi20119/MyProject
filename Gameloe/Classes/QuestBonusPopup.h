//
//  QuestBonusPopup.h
//  IndoGame
//
//  Created by Rainy on Mar.21.2015.
//
//
#ifndef __IndoGame__QuestBonusPopup__
#define __IndoGame__QuestBonusPopup__

#include <iostream>
#include "BaseScene.h"
#include "Constant.h"
#include "rapidjson.h"
#include "document.h"
#include "network/HttpClient.h"
#include "IAPItem.h"
#include "CMDErrorData.h"

class QuestBonusPopup : public BasePopup
{
public:
    
	QuestBonusPopup();
	~QuestBonusPopup();

	void onOpen();
	void onClose();
	bool fillData(CMDDailyBonusData* data);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
    void onTouchBtnAdd(Ref *pSender, Widget::TouchEventType type);
	ListView* m_ltvBonus;
	Button* m_btnClose;
    void requestIAPList();
    void responseIAPList(HttpClient *sender, HttpResponse *response);

    static QuestBonusPopup* create(CMDDailyBonusData* data);
    bool init(string csbFileName);
};

#endif /* defined(__IndoGame__QuestBonusPopup__) */