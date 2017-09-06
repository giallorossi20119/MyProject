#ifndef __IndoGame__TongitsGameScene__
#define __IndoGame__TongitsGameScene__

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"

#include "BaseScene.h"
#include "CardTongHelper.h"
#include "UserInfo.h"
#include "UserInfoOther.h"
#include "ChatToast.h"
#include "SceneManager.h"
#include "Constant.h"
#include "CMDTongitsData.h"
#include "SSUserInfo.h"
#include "ChatToast.h"
#include "InvitationPopupT.h"
#include "EndGamePopupT.h"
#include "FiredCardPopup.h"
#include "SettingRoomPopupT.h"

USING_NS_CC;
USING_NS_UI;
USING_NS_STD;
USING_NS_CC_EXT;

class TongitsGameScene :
public BaseScene
{
public:
    TongitsGameScene();
    ~TongitsGameScene();
    
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
    void onDrawConfirm(Ref* obj);
    void onUpdateUserPosition(Ref* obj);
    void confirmDraw(EventCustom* event);
    //play
    void onBtnStartClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnMeldClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnSortClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnCallClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnSendClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnDumpClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnTongitsClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnDeckClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnEatClick(Ref *pSender, Widget::TouchEventType type);
    void onBtnLookClick(Ref *pSender, Widget::TouchEventType type);
    
    void onUserJoinRoom(Ref* obj);
    void onUserLeftRoom(Ref* obj);
    void onClientFinishGame(Ref* obj);
    void onStartedGame(Ref* obj);
    void onClientGetStart(Ref* obj);
    void onFireCard(Ref* obj);
    void onMeldCard(Ref* obj);
    void onSendCard(Ref* obj);
    void onClientError(Ref* obj);
    void onIgnoreCard(Ref* obj);
    void onGetCardFromDeck(Ref* obj);
    void onChangeRound(Ref* obj);
    void onChangePot(Ref* obj);
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
    void checkU();
    void checkDraw();
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
    void finishGame(vector<CMDFinishDataT*>* vCMDFinishData);
    void showMessage(bool bVisible, const char* messageid);
    
    Button* m_btnStraight;
    Button* m_btnFlush;
    Button* m_btnFullhouse;
    Button* m_btnFourOfAKind;
    Button* m_btnStraightFlush;
    Button* m_btnRoyalStraightFlush;
    Button* btnStart;
    Button* btnDump;
    Button* btnTongits;
    Button* btnCall;
    Button* btnSend;
    Button* btnMeld;
    Button* btnSort;
    Layout* pnlTableArea;
    Layout* pnlPlayerAreas[3];
    Layout* pnlPhomPlayer[3];
    Layout* pnlPhom[4];
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
    CMDMinMaxStakeT* m_pDataMinMaxStake;
    TextBMFont* bmBet;
    TextBMFont* bmTime;
    TextBMFont* bmfPot;
    TextBMFont* bmfDeckNo;
    Text* lblInvite;
    Button* btnDeck;
    Button* btnEat;
    Button* btnLook;
//    vector<Card*>* m_vFiredCards;
    vector<Card*>* m_vDroppedCards;
private:
    bool onCardTouchBegan(Touch* touch, Event* event);
    void onCardTouchMoved(Touch* touch, Event* event);
    void onCardTouchEnded(Touch* touch, Event* event);
    Card* m_selectingCard;
    Card* m_targetCard;
    bool m_bMovingCard;
    bool m_bTouchBeganCard;
    Vec2 m_diffPos;
    Vec2 m_startPos;
    void swapCard(Card* cardA,Card* cardB);
    void addCardsTouchHandler();
    void verifyHand();
    
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
    void relayoutPhom(int value,int distance);
    
    vector<Vec2> m_vChatToastPosition;
    void onNetworkSendPublishMsrTongits(Ref* obj);
    void onNetworkGetPublishMsrTongits(Ref* obj);
    
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

#endif /* defined(__IndoGame__TongitsGameScene__) */
