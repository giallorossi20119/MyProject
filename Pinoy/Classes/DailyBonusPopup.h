#ifndef __IndoGame__DailyBonusPopup__
#define __IndoGame__DailyBonusPopup__

#include <iostream>
#include "BaseScene.h"
#include "Constant.h"
#include "rapidjson.h"
#include "document.h"
#include "network/HttpClient.h"
#include "IAPItem.h"
#include "CMDErrorData.h"

class DailyBonusPopup : public BasePopup
{
public:
    
	DailyBonusPopup();
	~DailyBonusPopup();

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

    static DailyBonusPopup* create(CMDDailyBonusData* data);
    bool init(string csbFileName);
};

#endif /* defined(__IndoGame__DailyBonusPopup__) */