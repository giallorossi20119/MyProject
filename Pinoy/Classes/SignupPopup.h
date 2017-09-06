#ifndef SIGNUP_POPUP_H
#define SIGNUP_POPUP_H

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "Constant.h"
#include "TextData.h"
#include "CocosGUI.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "TTutil.h"

#include "BasePopup.h"
#include "LoginPopup.h"
#include "BaseScene.h"
#include "ResourceManager.h"
#include "SFSConnection.h"
#include "LoginHandler.h"

class LoginPopup;

class SignUpPopup :
	public BasePopup
{
public:
	SignUpPopup();
	~SignUpPopup();

	void onOpen();
	void onClose();
private:
	Button* m_btnConfirm;
	Button* m_btnBack;
	TextField* m_inputUsername;
	TextField* m_inputPassword;
	TextField* m_inputConfirmPassword;
	TextField* m_inputEmail;
	TextField* m_textWarning;

	void onTouchConfirmBtn(Ref* sender, Widget::TouchEventType type);
	void onTouchBackBtn(Ref* sender, Widget::TouchEventType type);
	void onTextFieldEvent(Ref* sender, TextField::EventType type);

	void onTouchInputUsername(Ref* sender, Widget::TouchEventType type);
	void onTouchInputPassword(Ref* sender, Widget::TouchEventType type);
	void onTouchInputConfirmPassword(Ref* sender, Widget::TouchEventType type);
	void onTouchInputEmail(Ref* sender, Widget::TouchEventType type);

	void onSignUpFailed(Ref* sender);
};


#endif
