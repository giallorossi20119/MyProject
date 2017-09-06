//
//  LobbyScene.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__LobbyScene__
#define __IndoGame__LobbyScene__

#include <iostream>
#include "BaseScene.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "CMDBantingData.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

class LobbyScene : public BaseScene
{
public:
	LobbyScene();
	virtual ~LobbyScene();
	virtual void onEnter();
	virtual void onExit();
	//virtual void update(float dt);
	virtual void addEventlistener();
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);
	virtual void onEnterTransitionDidFinish();
	void changeLanguage(Ref* obj);
	void onBtnBackHomeClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnPlayClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnCreateClick(Ref *pSender, Widget::TouchEventType type);
	void fillListRoomData();
    void getZone(Ref *pSender, Widget::TouchEventType type);
	void update(float dt);
	void relayout();
	void setPointPos();
	void requestGoToGame(Ref* obj);
	void selectedRoomEvent(Ref *pSender, ListView::EventType type);
	void backScene();
    //network event
    void onRoomJoining(Ref* obj);
    void onRoomJoinError(Ref* obj);
    void onInvition(Ref* obj);
    void onKillDead(Ref* obj);
    void onBtnInviteClick(Ref *pSender, Widget::TouchEventType type);
    void confirmInvite(EventCustom* event);
    void setTextLanguage();
    void onReminds(Ref* obj);
    void onWasKicked(Ref* obj);
    void onNetworkCheckReconnect(Ref* obj);
    void confirmReconnect(EventCustom* event);
    void checkAlert();
	Button* m_p_bBackHome;
	Button* m_p_bPlay;
	Button* m_p_bCreate;
    Button* m_aBtZones[4];
	ListView* m_p_lListRoom;
	Layout* m_p_lItemListView;
	Slider* m_p_sScrollListView;
	int m_WidthList;
	int m_HeightList;
	Layout* m_pPanelTitleListRoom;
	Layout* m_pPanelRooms;
	ImageView* m_pPointView;
    ImageView* m_ivGame;
    ImageView* m_ivGameName;
	float m_fListScaleX;
	Layout* m_pPanelTitleStakes;
	Layout* m_pPanelTitlePlayer;
	TextField* txtRoomNumber;
	TextField* txtRoomName;
	TextField* txtRoomBet;
	TextField* txtRoomPlayer;
	TextField* txtZone1;
	TextField* txtZone2;
	TextField* txtZone3;
	TextField* txtZone4;
	TextField* txtMinigames;

private:
	int m_noItem;
	int m_countItem;
    void onTryAddNewItem(float delta);
	void renderItem(int index);
};

#endif /* defined(__IndoGame__LobbyScene__) */
