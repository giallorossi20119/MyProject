//
//  CapsaBantingGameScene.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__CapsaBantingGameScene__
#define __IndoGame__CapsaBantingGameScene__

#include <iostream>
#include "BaseScene.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "UserInfo.h"
#include "SceneManager.h"
#include "PlayerData.h"
#include "ChatToast.h"
#include "CardHelper.h"
#include "UserInfoOther.h"
#include "EndGamePopup.h"
#include "CMDBantingData.h"
#include "CMDErrorData.h"
#include "LobbyScene.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "ResourceManager.h"
#include "GlobalVariable.h"
#include "ImageLoader.h"
#include "ZoneData.h"
#include "UserInfo.h"
#include "Card.h"
#include "UserInfoOther.h"
#include "InvitationPopup.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_WP8
#include "\\psf\Home\Desktop\Projects\SVN\indo\mobile\trunk\proj.wp8-xaml\AppComponent\src\SmartfoxInterop.h"
using namespace PhoneDirect3DXamlAppComponent;
extern SmartfoxClientCallback^ g_smartfoxClientCallback;
#else
#include "SFSConnection.h"
#endif

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

class CapsaBantingGameScene : public BaseScene
{
public:
	CapsaBantingGameScene();
	~CapsaBantingGameScene();
	virtual void onEnter();
	virtual void onExit();
	virtual void update(float dt);
	virtual void addEventlistener();
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);
	void onBtnChangeLanguageClick(Ref *pSender, Widget::TouchEventType type);
	void changeLanguage(Ref* obj);
	void relayout();
    void placePlayers();
	void showSettingRoom(Ref* obj);
	void closeSettingRoom(Ref *obj);
	void updateNewSetting(Ref* obj);
	void showInvite();
    void onResetGame(Ref* obj);
    //play
    void onBtnPlaceClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnSortClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnPassClick(Ref *pSender, Widget::TouchEventType type);
	void onBtnStartClick(Ref *pSender, Widget::TouchEventType type);

    void onTouchBtnStraight(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnFlush(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnFullhouse(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnFourOfAKind(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnStraightFlush(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnRoyalStraightFlush(Ref *pSender, Widget::TouchEventType type);

    void onUserJoinRoom(Ref* obj);
    void onUserLeftRoom(Ref* obj);
    void onClientFinishGame(Ref* obj);
    void onStartedGame(Ref* obj);
    void onClientGetStart(Ref* obj);
    void onFireCard(Ref* obj);
    void onClientError(Ref* obj);
    void onIgnoreCard(Ref* obj);
    void onChangeRound(Ref* obj);
    void onPrgTimer(float dt);
	void onNetworkAutoFire(Ref* obj);
	void onRoomSettingChanged(Ref* obj);
    void onWaitingList(Ref* obj);
    void onKillDead(Ref* obj);
    void onBtnInviteClick(Ref *pSender, Widget::TouchEventType type);
    void moveLight();
    void onDead2(Ref* obj);
    void onEndShowResult(Ref* obj);
    void joinRoom();
    void leftRoom(double iTTID);
    double leftTTID;
    //playing
    void setTurnId(double p_iTurnId, bool p_bFirst);
    void displayCards();
    void clearCards();
    void sortCards();
    void dealCards();
    void setActiveButtons(double iTurnID, bool bFirst = false);
    void setActiveStartButton();
    void animFinishMe(Node* node, int indexCard);
    void animFinishOther(Node* node, int indexUser, int indexCard);
    void finishAction(Node* node);
    void finishWinAction();
    void setVisibleGameButtons(bool bVisible);
    void showKickUser(bool bShow);
    void showHostUser();
    void showItemsRoom();
    void spectator();
    void reconnect();
    void unselectedCards(Ref *pSender, Widget::TouchEventType type);
    void finishGame(vector<CMDFinishData*>* vCMDFinishData);
    void showMessage(bool bVisible, const char* messageid);
    
	Button* m_btnStraight;
	Button* m_btnFlush;
	Button* m_btnFullhouse;
	Button* m_btnFourOfAKind;
	Button* m_btnStraightFlush;
    Button* m_btnRoyalStraightFlush;
    Button* btnStart;
    Button* btnPlace;
    Button* btnPass;
    Button* btnSort;
    Layout* pnlTableArea;
    Layout* pnlPlayerAreas[4];
    Layout* pnlTimer;
    Layout* pnlRoomInfo;
    Layout* pnlUserInfo;
    Layout* pnlInvite;
    Layout* pnlGameBar;
    Layout* pnlSuggest;
    LoadingBar* prgTime;
    ImageView* imgLight;
    ImageView* imgTimeBg;
    ImageView* imgCountDown;
    vector<UserInfoOther*>* m_vUserInfoOthers;
	CMDMinMaxStake* m_pDataMinMaxStake;
	TextBMFont* bmBet;
    TextBMFont* bmTime;
    vector<Card*>* m_vFiredCards;

private:
	void activateHintHands();
	void inactivateHintHands();
	CardHand* m_attackerHand;
	Sprite* m_hintArrow;
	vector<int> m_v_iAttackerCardId;
	vector<int> m_v_iDefenderCardId;
	vector<CardHand*> m_vStraightHand;
	vector<CardHand*> m_vFlushHand;
	vector<CardHand*> m_vFullhouseHand;
	vector<CardHand*> m_vFourOfAKindHand;
	vector<CardHand*> m_vStraightFlushHand;
    vector<CardHand*> m_vRoyalStraightFlushHand;

	int m_iIndexStraightHand;
	int m_iIndexFlushHand;
	int m_iIndexFullhouseHand;
	int m_iIndexFourOfAKindHand;
	int m_iIndexStraightFlushHand;
    int m_iIndexRoyalStraightFlushHand;

	void onNetworkSendPublishMsr(Ref* obj);
	void onNetworkGetPublishMsr(Ref* obj);
	void onSelectedCard(Ref* obj);
	void deleteHintHands();

	vector<Vec2> m_vChatToastPosition;

    double m_dStartId;
    bool m_bFinishGame;
    bool m_bCanJoinRoom;
    bool m_bCanLeftRoom;

    int m_iHandPosX;
    int m_iHandPosY;
    int m_iHandCount;
    int m_iCountDown;
    int m_iTimeLeft;
    int m_iTypeSort;//0:increase, 1:decrease
    Sprite* m_sprDeadEffect;
    TextBMFont* m_bmfCountDown;
    Layout*     m_pnlCountDown;
    float m_fCountTimeLeft;
    int m_iLastCount;
    int m_iCurrentCount;
    void onCountDownTimer(float dt);
    int m_iCountTurns;
};
#endif /* defined(__IndoGame__CapsaBantingGameScene__) */
