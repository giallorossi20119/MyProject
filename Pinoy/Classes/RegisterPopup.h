#ifndef REGISTER_POPUP_H
#define REGISTER_POPUP_H

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

class RegisterPopup : public BasePopup
{
public:
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;

	RegisterPopup();
	RegisterPopup(std::string sMsr);
	~RegisterPopup();
	static RegisterPopup* create();
	static RegisterPopup* create(std::string sMsr);

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
    TextField* m_txtPassword;
    TextField* m_txtRePassword;
};


#endif // !REGISTER_POPUP_H
