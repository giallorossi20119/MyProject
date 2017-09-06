//
//  ChangeNamePopup.h
//  IndoGame
//
//  Created by rainy on 8/7/14.
//
//
#ifndef __CHANGE_NAME_POPUP_H__
#define __CHANGE_NAME_POPUP_H__

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
#include "network/HttpClient.h"

class BasePopup;
class BaseScene;

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_STD;
USING_NS_UI;

class ChangeNamePopup : public BasePopup
{
public:
	static std::string ON_CONFIRM;
	static std::string ON_CANCEL;

	ChangeNamePopup();
	ChangeNamePopup(std::string sMsr);
	~ChangeNamePopup();
	static ChangeNamePopup* create();
	static ChangeNamePopup* create(std::string sMsr);

	void onOpen();
	void onClose();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
private:
	void onTouchCancel(Ref* pSender, Widget::TouchEventType type);
	void onTouchConfirm(Ref* pSender, Widget::TouchEventType type);
    void onInputUsernameEvent(Ref* sender, TextField::EventType type);
	std::string m_sMsr;

    TextBMFont* m_bmfTitle;
    Text*       m_lblMessage;
    Button*     m_btnCancel;
    Button*     m_btnConfirm;
    TextField*  m_txtNewName;
};


#endif // __CHANGE_NAME_POPUP_H__

