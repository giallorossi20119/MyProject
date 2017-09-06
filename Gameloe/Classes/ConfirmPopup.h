//
//  ConfirmPopup.h
//  IndoGame
//
//  Created by longnh on 8/7/14.
//
//
#ifndef CONFIRM_POPUP_H
#define CONFIRM_POPUP_H

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

class ConfirmPopup : public BasePopup
{
public:
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;

	ConfirmPopup();
	ConfirmPopup(std::string sMsr);
	~ConfirmPopup();
	static ConfirmPopup* create();
	static ConfirmPopup* create(std::string sMsr);

	void onOpen();
	void onClose();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
    void changeToAlert();
private:
	void onTouchCancel(Ref* pSender, Widget::TouchEventType type);
	void onTouchConfirm(Ref* pSender, Widget::TouchEventType type);
	std::string m_sMsr;
    bool m_bConvert2Alert;
};


#endif // !CONFIRM_POPUP_H
