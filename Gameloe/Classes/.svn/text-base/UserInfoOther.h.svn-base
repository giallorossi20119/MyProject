//
//  UserInfoOther.h
//  IndoGame
//
//  Created by Rainy on 8/22/14.
//
//

#ifndef __IndoGame__UserInfoOther__
#define __IndoGame__UserInfoOther__

#include <iostream>
#include "BaseCom.h"
#include "PlayerData.h"

class UserInfoOther : public BaseCom
{
public:
	UserInfoOther();
	~UserInfoOther();
	static UserInfoOther* create();
	void fillDataUserInfo(const PlayerData* playerData);
    void updateMoney(double p_dMoney);
    void updateNOCardsRemain(int p_iNOCardsRemain);
    void setTurnEffect(bool visible, int duration = 0);
    void setVisibleNOCard(bool bValue = false);
    void onBtnKickClick(Ref *pSender, Widget::TouchEventType type);
    void onImgAvatarClick(Ref *pSender, Widget::TouchEventType type);
    void setVisibleHost(bool bValue);
    void confirmKick(EventCustom* event);
    void setVisibleKickBtn(bool bValue);
    void updateUserInfo(Ref* obj);
    void alignRight();
    double m_dUserId;
    int    m_iSFSId;
};
#endif /* defined(__IndoGame__UserInfoOther__) */
