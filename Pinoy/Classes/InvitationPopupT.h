#ifndef __IndoGame__InvitationPopupT__
#define __IndoGame__InvitationPopupT__

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
#include "CMDTongitsData.h"
#include "TTutil.h"

class InvitationPopupT : public BasePopup
{
public:
    InvitationPopupT();
    ~InvitationPopupT();
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;
	InvitationPopupT(vector<CMDWaitingDataT*>* vWaitingData);
	static InvitationPopupT* create();
	static InvitationPopupT* create(vector<CMDWaitingDataT*>* vWaitingData);

	void onOpen();
	void onClose();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
private:
	void onTouchCancel(Ref* pSender, Widget::TouchEventType type);
	void onTouchConfirm(Ref* pSender, Widget::TouchEventType type);
    void selectedRowEvent(Ref *pSender, ListView::EventType type);
    vector<CMDWaitingDataT*>* m_vWaitingDatas;
    ListView* lvInvitations;
    Button* btnCancel;
    Button* btnConfirm;
    int m_iNOUserWaiting;
};
#endif /* defined(__IndoGame__InvitationPopupT__) */
