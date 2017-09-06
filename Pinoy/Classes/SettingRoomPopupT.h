#ifndef __IndoGame__SettingRoomPopupT__
#define __IndoGame__SettingRoomPopupT__

#include "BasePopup.h"
#include "cocos2d.h"
#include "Constant.h"
#include "CMDTongitsData.h"
#include "SFSConnection.h"

using namespace cocos2d;
using namespace ui;

class SettingRoomPopupT : public BasePopup
{
public:
    SettingRoomPopupT(CMDMinMaxStakeT* stake, int curStake, int time, bool bFirst = false);
	~SettingRoomPopupT();

	void onOpen();
	void sliderEvent(Ref *pSender, Slider::EventType type);
	void setNumberPlayers(int players);
	void setNumberTime(int time);
	void setStake(int stake);
	void chk2PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chk3PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chk4PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime15sSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime20sSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime30sSelectedEvent(Ref* pSender, CheckBox::EventType type);
    void chkTime40sSelectedEvent(Ref* pSender, CheckBox::EventType type);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
	int stepStake;

	//static SettingRoomPopup* create();

	CheckBox* m_pChkTime15s;
	CheckBox* m_pChkTime20s;
	CheckBox* m_pChkTime30s;
    CheckBox* m_pChkTime40s;
	CheckBox* m_pChk2Players;
	CheckBox* m_pChk3Players;
	CheckBox* m_pChk4Players;
	Slider* m_pSliderStake;
	TextBMFont* m_bmfStake;
	Button* btnOk;
	Button* btnClose;

    CMDMinMaxStakeT* m_pStakeT;
	int m_iCurStake;
	int m_iCurPlayers;
	int m_iCurTime;
    bool m_bFirst;
	void requestChangeSetting(Ref *pSender, Widget::TouchEventType type);
	void closePopup(Ref *pSender, Widget::TouchEventType type);
};

#endif /* defined(__IndoGame__SettingRoomPopupT__) */