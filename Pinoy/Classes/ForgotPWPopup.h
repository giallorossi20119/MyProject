#ifndef FORGOTPW_POPUP_H
#define FORGOTPW_POPUP_H

#include <iostream>
#include <vector>
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

class BasePopup;
class BaseScene;

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_STD;
USING_NS_UI;

class ForgotPWPopup : public BasePopup
{
public:
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;

	ForgotPWPopup();
	ForgotPWPopup(std::string sMsr);
	~ForgotPWPopup();
	static ForgotPWPopup* create();
	static ForgotPWPopup* create(std::string sMsr);

	void onOpen();
	void onClose();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
private:
	void onTouchCancel(Ref* pSender, Widget::TouchEventType type);
	void onTouchConfirm(Ref* pSender, Widget::TouchEventType type);
	std::string m_sMsr;

    TextBMFont* m_bmfTitle;
    Button* m_btnCancel;
    Button* m_btnConfirm;
    TextField* m_txtEmail;
};


#endif // !FORGOTPW_POPUP_H

