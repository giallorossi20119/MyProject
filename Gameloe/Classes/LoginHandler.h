#ifndef LOGINHANDLER_H
#define LOGINHANDLER_H

#include <iostream>
#include "Constant.h"
#include "GlobalVariable.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "HttpClient.h"
#include "AlertPopup.h"
#include "BaseScene.h"
#include "SFSConnection.h"
#include "SceneManager.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    #include "jni.h"
    #include "cocos/platform/android/jni/JniHelper.h"
#endif
class SFSConnection;

USING_NS_CC;
USING_NS_NET;

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
extern "C"
{
	extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativeLoginSucceed(JNIEnv *env, jobject obj, jstring token);
	extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativeLoginFailed(JNIEnv *env, jobject obj, jstring msrError);
	extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativeCheckSFSConnected(JNIEnv *env, jobject obj);
    extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativeSetDeviceID(JNIEnv *env, jobject obj, jstring deviceID);
    extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativeSetFacebookID(JNIEnv *env, jobject obj, jstring facebookID);
}
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#endif

class LoginHandler : public Node
{
public:
	LoginHandler();
	~LoginHandler();
	static LoginHandler* getInstance();

	// SignUp - SignIn
	void signUp(std::string email, std::string password);
	void signIn(std::string email, std::string password);
    void requestChangeName(std::string name);
	void connectToFacebook();
    void connectToGooglePlus();
    void connectByDeviceID();
    void callSupport(std::string number);
    void openFanpage(std::string url);
	static void loginFacebook();
    static void logoutFacebook();
    static void logoutGooglePlus();
	static std::string m_sUserName;
	static std::string m_sPassword;
	static std::string m_sEmail;
	static std::string m_sFacebookToken;
	static std::string m_sMsrError;
	static bool m_bLoginError;
	static bool m_bSave;
    static int  m_iLoginType;
    static int  m_bLoginAgain;
    void getAccountSuccessed(string sid);
    void getAccountFail(string message);
private:
	static bool m_bReady;
	static LoginHandler* m_instance;

	HttpRequest* m_requestSignUp;
	HttpRequest* m_requestSignIn;

	void onResponseSignUp(HttpClient* sender, HttpResponse* response);
	void onResponseLoginFacebook(HttpClient* sender, HttpResponse* response);
    void onResponseChangeName(HttpClient* sender, HttpResponse* response);
    void onLoginSucceed(Ref* obj);
	void onLoginFailed(Ref* obj);
};


#endif // !LOGINHANDLER_H
