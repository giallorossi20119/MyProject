//
//  BaseScene.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__BaseScene__
#define __IndoGame__BaseScene__

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include <vector>
#include "BasePopup.h"
#include "Toast.h"
#include "SimpleAudioEngine.h"
#include "AudioManager.h"
#include "ChatToast.h"
#include "MsgConst.h"
#include "CMDBantingData.h"

class BasePopup;
class RankPopup;

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;
USING_NS_STD;

class BaseScene : public Scene
{
public:
    float m_fTimeLeft;
    BaseScene();
    virtual ~BaseScene();
	
    virtual void onEnter();
    virtual void onExit();
	virtual void update(float delta);
    void exitScene();
	void showLoading();
	void hideLoading();
    void idleGame();
	void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);
	void showToast(std::string sMessenger, float fTime);
	void hideToast();

	void openPopup(BasePopup* popup);
	void closePopup(BasePopup* popup);
	void closeLastPopup();
	void closeAllPopups();
    void relayout();
    virtual void initUI(std::string p_sSceneJsonFile);
    virtual void addEventlistener(){};
	void onNetworkSignInFail(Ref* obj);
	void onNetworkSignUpFail(Ref* obj);
    void onNetworkConnection(Ref* obj);
    void onNetworkNotAvailble(Ref* obj);
    void onNetworkConnectionLost(Ref* obj);
    void onNetworkConnecting(Ref* obj);
    void onNetworkLoginSuccessful(Ref* obj);
    void onNetworkResponse(Ref* obj);
    void onNetworkDisconnect(Ref* obj);
    void onNetworkLogging(Ref* obj);
    void onNetworkUserInfo(Ref* obj);
    void onNetworkClientLobbyRecieved(Ref* obj);
	void onNetworkLoginError(Ref* obj);
    void onResponseDailyBonus(Ref* obj);
    void onResponseBonusTime(Ref* obj);
    void onResponseNameUpdated(Ref* obj);
    void onResponseAccountUpdated(Ref* obj);
    void showPlayerInfo(Ref* obj);
	void extensionResponseError(Ref* obj);
    void onResponseClientPositionData(Ref* obj);
	void captureScreen();
	void recieveRankData(Ref* obj);
    void onSSResponseUserData(Ref* obj);
    void pingCount(float dt);
    void onNetworkLag();
	void showAlert(Ref* obj);
    Layout* m_pLayout;
    EventListenerKeyboard* m_listenerKeyboard;
protected:
    Layer* m_pBGLayer;
	Layer* m_pUILayer;
	Layer* m_pPopupLayer;
	Layer* m_pLoadingLayer;
    vector<BasePopup*>* m_vPopups;
private:
	Toast* m_pToast;

	EventListenerTouchOneByOne* m_pListenerLoadingLayer;
	void autoRemoveToast(float dt);
	void onCapturedScreen(bool succeed, const std::string& outputFile);
};

#endif /* defined(__IndoGame__BaseScene__) */
