#ifndef CHATTOAST_H
#define CHATTOAST_H

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"

USING_NS_CC;
USING_NS_UI;
USING_NS_STD;

class ChatToast :
	public Node
{
public:
	ChatToast();
	ChatToast(std::string sMsr);
	~ChatToast();

	static ChatToast* create(std::string sMsr);
	virtual void onEnter();
	virtual void onExit();
private:
	std::string m_sMsr;
	int m_iMaxChar;
	void onRemove(float dt);
};


#endif // !CHATTOAST_H
