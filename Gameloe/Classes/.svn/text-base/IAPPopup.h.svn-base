//
//  IAPPopup.h
//  IndoGame
//
//  Created by Rainy on Mar.21.2015.
//
//
#ifndef __IndoGame__IAPPopup__
#define __IndoGame__IAPPopup__

#include <iostream>
#include "BaseScene.h"
#include "Constant.h"
#include "rapidjson.h"
#include "document.h"
#include "network/HttpClient.h"
#include "IAPItem.h"
class IAPPopup : public BasePopup
{
public:
    
	IAPPopup();
	~IAPPopup();

	void onOpen();
	void onClose();
	void fillData(vector<IAPItem*> vItems);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
    void onTouchBtnAdd(Ref *pSender, Widget::TouchEventType type);
	ListView* m_ltvIAP;
	Button* m_btnClose;
    void requestIAPList();
    void responseIAPList(HttpClient *sender, HttpResponse *response);
    vector<string> vSKUs;

    static IAPPopup* create();
    bool init(string csbFileName);
};

#endif /* defined(__IndoGame__IAPPopup__) */