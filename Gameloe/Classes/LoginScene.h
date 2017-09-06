//
//  LoginScene.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__LoginScene__
#define __IndoGame__LoginScene__

#include <iostream>
#include "BaseScene.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "spine/spine.h"
#include "LoginPopup.h"
#include "LoginHandler.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    #include "cocos/platform/android/jni/JniHelper.h"
    #include <jni.h>
    #include "LoginHandler.h"
#endif

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

class LoginScene : public BaseScene
{
public:
    LoginScene();
    ~LoginScene();
    virtual void onEnter();
    virtual void onExit();
    virtual void update(float dt);
    virtual void addEventlistener();
	virtual void onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event);
    void onBtnDeviceID(Ref *pSender, Widget::TouchEventType type);
    void onBtnLoginFacebook(Ref* sender, Widget::TouchEventType type);
    void onBtnLoginGoogle(Ref *pSender, Widget::TouchEventType type);
    void onTouchBtnAccountBase(Ref* sender, Widget::TouchEventType type);
    void changeLanguage(Ref* obj);
	void openStore(EventCustom* event);
    void confirmInvite(EventCustom* event);
    void checkVersion();
    RenderTexture* createStroke(Sprite* sprite, int size, Color3B color, GLubyte opacity);
    Button* m_btnFacebookLogin;
    Button* m_btnGoogleLogin;
    Button* m_btnDeviceIDLogin;
    Button* m_btnAccountBaseLogin;
};
#endif /* defined(__IndoGame__LoginScene__) */

