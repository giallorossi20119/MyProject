#ifndef CHATPOPUP_H
#define CHATPOPUP_H

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"

#include "Constant.h"
#include "EventConst.h"
#include "BasePopup.h"
#include "SFSConnection.h"

class BasePopup;

USING_NS_CC;
USING_NS_STD;

class ChatPopup : public BasePopup
{
public:
	ChatPopup();
	~ChatPopup();
	static ChatPopup* create();

	void onOpen();
	void onClose();

	static std::string ON_SEND_MSR;
	static std::string ON_SEND_EMOTICON;
private:
	Button* m_bgInputMsr;
	Button* m_btnSend;
    Button* m_btnClose;
	TextField* m_inputMsr;
	Vector<Widget*>* m_vEmoticon;
    ui::ListView* m_lvMessage;
    ui::ListView* m_lvKeyboard;
	void onTouchBgInputMsr(Ref* sender, Widget::TouchEventType type);
	void onTouchBtnSend(Ref* sender, Widget::TouchEventType type);
	void onTouchIcon(Ref* sender, Widget::TouchEventType type);
    void onTouchOverlay(Ref* sender, Widget::TouchEventType type);
};


#endif // !CHATPOPUP_H
