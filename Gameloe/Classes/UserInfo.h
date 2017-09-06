//
//  UserInfo.cpp
//  IndoGame
//
//  Created by longnh on 8/14/14.
//
//

#ifndef IndoGame_UserInfo_h
#define IndoGame_UserInfo_h

#include <iostream>
#include "BaseCom.h"

class UserInfo : public BaseCom
{
public:
	static std::string COLOR_STAR_BLUE;
	static std::string COLOR_STAR_RED;
	static std::string COLOR_STAR_PURPLE;
	static std::string COLOR_STAR_YELLOW;
	static std::string COLOR_STAR_CYAN;

	UserInfo();
	virtual ~UserInfo();
	void fillDataUserInfo();
    void updateMoney(double p_dMoney);
    void updateName();
    void updateAccount();
	bool isLoadedAva;
    void visibleHost(bool bHost);
private:
	void initStar();

	std::string getColorStar();
	int getNoStar();

	Sprite* m_symbol;
	vector<Sprite*> m_vStar;
	void updateUserInfo(Ref* sender);
    void updateUserMoney(Ref* sender);
    void onImgAvatarClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnWarningClick(Ref *pSender, Widget::TouchEventType type);

    TextBMFont* m_bmfUsername;
    Button* btnWarning;
};

#endif /* defined(IndoGame_UserInfo_h) */
