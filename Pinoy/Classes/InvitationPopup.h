//
//  InvitationPopup.h
//  IndoGame
//
//  Created by Rainy on 9/30/14.
//
//

#ifndef __IndoGame__InvitationPopup__
#define __IndoGame__InvitationPopup__

#include <iostream>
#include "BasePopup.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "BasePopup.h"
#include "BaseScene.h"
#include "ResourceManager.h"
#include "TextData.h"
#include "CMDBantingData.h"
#include "TTutil.h"

class InvitationPopup : public BasePopup
{
public:
    InvitationPopup();
    ~InvitationPopup();
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;
	InvitationPopup(vector<CMDWaitingData*>* vWaitingData);
	static InvitationPopup* create();
	static InvitationPopup* create(vector<CMDWaitingData*>* vWaitingData);

	void onOpen();
	void onClose();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
private:
	void onTouchCancel(Ref* pSender, Widget::TouchEventType type);
	void onTouchConfirm(Ref* pSender, Widget::TouchEventType type);
    void selectedRowEvent(Ref *pSender, ListView::EventType type);
    vector<CMDWaitingData*>* m_vWaitingDatas;
    ListView* lvInvitations;
    Button* btnCancel;
    Button* btnConfirm;
    int m_iNOUserWaiting;
};
#endif /* defined(__IndoGame__InvitationPopup__) */
