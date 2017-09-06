//
//  UserInfoOther.h
//  IndoGame
//
//  Created by Rainy on 8/22/14.
//
//

#ifndef __IndoGame__SSUserInfoOther__
#define __IndoGame__SSUserInfoOther__

#include <iostream>
#include "BaseCom.h"
#include "PlayerData.h"

USING_NS_CC;
USING_NS_UI;
USING_NS_STD;
USING_NS_CC_EXT;

class SSUserInfo : public BaseCom
{
public:
	SSUserInfo();
	~SSUserInfo();
	static SSUserInfo* create();
	void fillDataUserInfo(const PlayerData* playerData);
    void updateMoney(double p_dMoney);
    void setSortState(bool bSortState);
    void visibleSortStateBg(bool bVisible);
    void setBgAlign(bool isAlignRight = false);
    void onBtnKickClick(Ref *pSender, Widget::TouchEventType type);
    void onPnlAvatarClick(Ref *pSender, Widget::TouchEventType type);
    void confirmKick(EventCustom* event);
	void setVisibleKickBtn(bool bValue);
    void updateUserInfo(Ref* obj);
    void setVisibleHost(bool bValue);
    void visibleBGState(bool bVisible);
    ImageView* m_imgBtBg;
    TextBMFont* m_bmfState;
    Layout* m_pnlCards;
    double m_dUserId;
    long    m_iSFSId;
};
#endif /* defined(__IndoGame__SSUserInfoOther__) */
