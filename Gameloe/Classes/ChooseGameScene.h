//
//  ChooseGameScene.h
//  MyGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __MyGame__ChooseGameScene__
#define __MyGame__ChooseGameScene__

#include <iostream>
#include "BaseScene.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "UserInfo.h"
#include "ConfirmPopup.h"
#include "AlertPopup.h"
#include "SceneManager.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

class ChooseGameScene : public BaseScene
{
public:
	ChooseGameScene();
	virtual ~ChooseGameScene();
	virtual void onEnter();
	virtual void onExit();
	virtual void update(float dt);
	virtual void addEventlistener();
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onEnterTransitionDidFinish();
	void onBtnChangeLanguageClick(Ref *pSender, Widget::TouchEventType type);
	void changeLanguage(Ref* obj);
	void onBtnGame1Click(Ref *pSender, Widget::TouchEventType type);
    void onBtnGame2Click(Ref *pSender, Widget::TouchEventType type);
    void onBtnGame3Click(Ref *pSender, Widget::TouchEventType type);
	void relayout();
	void onBtnBackHomeClick(Ref *pSender, Widget::TouchEventType type);
	void backScene();
    void chooseGame();

	Button* m_p_bGame1;
	Button* m_p_bGame2;
	Button* m_p_bGame3;
	Button* m_p_bBtnMoney;
	Button* m_p_bBtnRanking;
	Button* m_p_bBtnSettings;
	Layout* m_p_lSettingBtnsDropDown;
	Button* m_p_bBackHome;
};

#endif /* defined(__MyGame__ChooseGameScene__) */
