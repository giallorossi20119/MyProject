//
//  SettingRoomPopup.h
//  IndoGame
//
//  Created by longnh on 16/9/14.
//
//
#ifndef __IndoGame__SettingRoomPopup__
#define __IndoGame__SettingRoomPopup__

#include "BasePopup.h"
#include "cocos2d.h"
#include "Constant.h"
#include "CMDBantingData.h"
#include "SFSConnection.h"

using namespace cocos2d;
using namespace ui;

class SettingRoomPopup : public BasePopup
{
public:
	SettingRoomPopup(CMDMinMaxStake* stake, int curStake, int time, bool bFirst = false);
	~SettingRoomPopup();

	void onOpen();
	void sliderEvent(Ref *pSender, Slider::EventType type);
	void setNumberPlayers(int players);
	void setNumberTime(int time);
	void setStake(int stake);
    void setDefaultSetting();
	void chk2PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chk3PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chk4PlayerSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime10sSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime15sSelectedEvent(Ref* pSender, CheckBox::EventType type);
	void chkTime20sSelectedEvent(Ref* pSender, CheckBox::EventType type);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
	int stepStake;

	//static SettingRoomPopup* create();

	CheckBox* m_pChkTime10s;
	CheckBox* m_pChkTime15s;
	CheckBox* m_pChkTime20s;
	CheckBox* m_pChk2Players;
	CheckBox* m_pChk3Players;
	CheckBox* m_pChk4Players;
	Slider* m_pSliderStake;
	TextBMFont* m_bmfStake;
	Button* btnOk;
	Button* btnClose;

	CMDMinMaxStake* m_pStake;
	int m_iCurStake;
	int m_iCurPlayers;
	int m_iCurTime;
    bool m_bFirst;
	void requestChangeSetting(Ref *pSender, Widget::TouchEventType type);
	void closePopup(Ref *pSender, Widget::TouchEventType type);
};

#endif /* defined(__IndoGame__SettingRoomPopup__) */
