#include "LoginHandler.h"
#include "ResourceManager.h"
#define IDS_INVALID_CREDENTIAL "IDS_INVALID_CREDENTIAL"
#define IDS_ACCOUNT_NOT_EXIST_OR_EMAIL "IDS_ACCOUNT_NOT_EXIST_OR_EMAIL"
#define IDS_INVALID_ACCOUNT "IDS_INVALID_ACCOUNT"

LoginHandler* LoginHandler::m_instance = nullptr;
bool LoginHandler::m_bReady            = false;
int  LoginHandler::m_iLoginType        = 0;
int  LoginHandler::m_bLoginAgain       = false;
LoginHandler* LoginHandler::getInstance()
{
    if (!LoginHandler::m_instance)
    {
        m_bReady = true;
        m_instance = new LoginHandler();
        m_bReady = false;
    }
    return m_instance;
}

LoginHandler::LoginHandler()
{
    if (!m_instance)
        NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LoginHandler::onLoginSucceed), EVENT_NETWORK_LOGIN_SUCCESSFUL, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(LoginHandler::onLoginFailed), EVENT_NETWORK_lOGIN_ERROR, nullptr);
}
LoginHandler::~LoginHandler(){}

std::string LoginHandler::m_sUserName = "";
std::string LoginHandler::m_sPassword = "";
std::string LoginHandler::m_sEmail = "";
std::string LoginHandler::m_sMsrError = "";
bool LoginHandler::m_bLoginError = false;
bool LoginHandler::m_bSave = false;

// =============================================================================== //
// FOR ANDROID PLATFORMS
// THESE FUNCTIONS IS USING AS CALLBACKS FROM JAVA TO C++ - USING JNI
// =============================================================================== //

#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
extern void loginByAccountBase(std::string username, std::string password);
extern void loginByFacebook();
extern void logoutByFacebook();
extern void loginByGooglePlus();
extern void logoutByGooglePlus();
extern void loginByDeviceID();
extern void makeCallSupport(std::string number);
extern void makeOpenFanpage(std::string url);
#endif

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
extern "C"
{
    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativeLoginSucceed(JNIEnv *env, jobject obj, jstring token)
    {
        // Token is special data, so we do not have show it in interface
        jboolean isCopy = 1;
        if(ResourceManager::getInstance()->m_bLoadConfigFinish)
        {
//            GlobalVariable::m_sSID = env->GetStringUTFChars(token, &isCopy);
//            ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
//            SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
            
            GlobalVariable::m_sSID = env->GetStringUTFChars(token, &isCopy);
            
            //std::string s_username = env->GetStringUTFChars(username, &isCopy);
            //std::string s_fbid = env->GetStringUTFChars(facebookId, &isCopy);
            //std::string s_email = env->GetStringUTFChars(email, &isCopy);
            
            //LoginHandler::getInstance()->loginByFacebook(s_username, s_fbid, s_email);
            ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
            
            //add only pusoy
//            GlobalVariable::m_iCurrentGame = 0;
//            GlobalVariable::m_iCurrentZone = 1;
            
            SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
        }
    }
    
    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativeLoginFailed(JNIEnv *env, jobject obj, jstring msrError)
    {
        LoginHandler::m_bLoginError = true;
        jboolean isCopy = 1;
        LoginHandler::m_sMsrError = env->GetStringUTFChars(msrError, &isCopy);
    }
    
    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativeCheckSFSConnected(JNIEnv *env, jobject obj)
    {
        bool bConnected = SFSConnection::getInstance()->isConnected();
        if (!bConnected)
        {
            // Stop login task from JAVA
            JniMethodInfo t;
            if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "cancelLogin", "()V"))
            {
                t.env->CallStaticVoidMethod(t.classID, t.methodID);
            }
            
            // Show alert to user
            LoginHandler::m_bLoginError = true;
            LoginHandler::m_sMsrError = ResourceManager::getInstance()->getTextByName(kTEXT_MSG_NETWORK_ERROR).c_str();
            
            // Stop login
        }
    }
    
    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativeSetDeviceID(JNIEnv *env, jobject obj, jstring deviceID)
    {
        jboolean isCopy = 1;
        string deviceId = env->GetStringUTFChars(deviceID, &isCopy);
        CCLOG("Device ID: %s", deviceId.c_str());
        GlobalVariable::m_sDeviceID = deviceId;
    }
    
    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativeSetFacebookID(JNIEnv *env, jobject obj, jstring facebookID)
    {
        jboolean isCopy = 1;
        string id = env->GetStringUTFChars(facebookID, &isCopy);
        CCLOG("Facebook ID: %s", id.c_str());
        GlobalVariable::m_sUserFacebookID = id;
    }
}

#endif

void LoginHandler::signUp(std::string email, std::string password)
{
    CCLOG("signUp %s %s", email.c_str(), password.c_str());
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
    string name = "";
    string action = "updateAccount";
    std::string strRequestData =
    "action=" + action +
    "&email=" + email +
    "&password=" + password +
    "&token=" + GlobalVariable::m_sSID +
    "&name=" + name;
    
    m_sUserName = email;
    m_sPassword = password;
    
    m_requestSignUp = new HttpRequest();
    m_requestSignUp->setRequestType(HttpRequest::Type::POST);
    m_requestSignUp->setRequestData(strRequestData.c_str(), strlen(strRequestData.c_str()));
    m_requestSignUp->setResponseCallback(CC_CALLBACK_2(LoginHandler::onResponseSignUp, this));
    m_requestSignUp->setUrl(kURLGameloeDeviceID);
    HttpClient::getInstance()->sendImmediate(m_requestSignUp);
    m_requestSignUp->release();
}

void LoginHandler::onResponseSignUp(HttpClient* sender, HttpResponse* response)
{
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->hideLoading();
    // Request failed?
    if (!response || !response->isSucceed())
    {
        BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
        scene->openPopup(new AlertPopup("Sign up failed"));
        return;
    }
    
    // Request succeed, get response data as json
    std::vector<char>* l_v_buffer_data = response->getResponseData();
    std::string l_s_data(l_v_buffer_data->begin(), l_v_buffer_data->end());
    
    rapidjson::Document document;
    document.Parse<0>(l_s_data.c_str());
    CCLOG("response data:%s", l_s_data.c_str());
    // Parse response data
    int   status   = document["status"].GetInt();
    string message = document["message"].GetString();
    string name = "";
    // Signup failed, post notification and send alert
    if (status == 0)
    {
        getAccountFail(message);
    }
    else
    {
        scene->closeAllPopups();
        name = document["name"].GetString();
        if(LoginHandler::getInstance()->m_iLoginType == kLoginTypeDeviceID)
        {
            UserDefault::getInstance()->setStringForKey("email", m_sUserName.c_str());
            UserDefault::getInstance()->setStringForKey("password", m_sPassword.c_str());
        }
        NotificationCenter::getInstance()->postNotification(EVENT_ACCOUNT_UPDATED, new __String(name));
        UserDefault::getInstance()->setIntegerForKey("AccountMode", kAccountModePersonal);
        signIn(m_sUserName, m_sPassword);
    }
}

void LoginHandler::requestChangeName(std::string name)
{
    CCLOG("name %s", name.c_str());
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
    string action = "updateName";
    std::string strRequestData =
    "action=" + action +
    "&name=" + name +
    "&token=" + GlobalVariable::m_sSID;
    
    m_sUserName = name;
    
    auto requestChangeName = new HttpRequest();
    requestChangeName->setRequestType(HttpRequest::Type::POST);
    requestChangeName->setRequestData(strRequestData.c_str(), strlen(strRequestData.c_str()));
    requestChangeName->setResponseCallback(CC_CALLBACK_2(LoginHandler::onResponseChangeName, this));
    requestChangeName->setUrl(kURLGameloeDeviceID);
    HttpClient::getInstance()->sendImmediate(requestChangeName);
    requestChangeName->release();
}

void LoginHandler::onResponseChangeName(HttpClient* sender, HttpResponse* response)
{
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->hideLoading();
    // Request failed?
    if (!response || !response->isSucceed())
    {
        BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
        scene->openPopup(new AlertPopup("Change name failed"));
        return;
    }
    
    // Request succeed, get response data as json
    std::vector<char>* l_v_buffer_data = response->getResponseData();
    std::string l_s_data(l_v_buffer_data->begin(), l_v_buffer_data->end());
    
    rapidjson::Document document;
    document.Parse<0>(l_s_data.c_str());
    CCLOG("response data:%s", l_s_data.c_str());
    // Parse response data
    int   status   = document["status"].GetInt();
    string message = document["message"].GetString();
    string name = "";
    if (status == 0)
    {
        getAccountFail(message);
    }
    else
    {
        scene->closeAllPopups();
        name = document["name"].GetString();
        UserDefault::getInstance()->setBoolForKey("NoNeedChangeName", true);
        NotificationCenter::getInstance()->postNotification(EVENT_NAME_UPDATED, new __String(name));
    }
}

void LoginHandler::signIn(std::string email, std::string password)
{
    CCLOG("login by Account Base");
    m_iLoginType = kLoginTypeAccount;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
    
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "loginByAccountBase", "(Ljava/lang/String;Ljava/lang/String;)V"))
    {
        jstring arg1 = t.env->NewStringUTF(email.c_str());
        jstring arg2 = t.env->NewStringUTF(password.c_str());
        t.env->CallStaticVoidMethod(t.classID, t.methodID, arg1, arg2);
        t.env->DeleteLocalRef(arg1);
        t.env->DeleteLocalRef(arg2);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    loginByAccountBase(email, password);
#else
    
#endif
}

void LoginHandler::connectToFacebook()
{
    m_iLoginType = kLoginTypeFacebook;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    GlobalVariable::m_sDevice = 1;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "loginByFacebook", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    loginByFacebook();
#else
    
#endif
    
}

void LoginHandler::connectByDeviceID()
{
    m_iLoginType = kLoginTypeDeviceID;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    GlobalVariable::m_sDevice = 1;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "loginByDeviceID", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    loginByDeviceID();
#else
    
#endif
    
}

void LoginHandler::connectToGooglePlus()
{
    CCLOG("connectToGooglePlus");
    m_iLoginType = kLoginTypeGooglePlus;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->showLoading();
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    GlobalVariable::m_sDevice = 1;
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "loginByGooglePlus", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    loginByGooglePlus();
#else
    
#endif
    
}

void LoginHandler::onLoginSucceed(Ref* obj)
{
    // Stop checking sfs connection from platform code
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "stopCheckSFSConnected", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#endif
}

void LoginHandler::onLoginFailed(Ref* obj)
{
    // Stop checking sfs connection from platfrom code
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "stopCheckSFSConnected", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#endif
}

void LoginHandler::logoutFacebook()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    GlobalVariable::m_sDevice = 1;
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "logoutByFacebook", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    logoutByFacebook();
#endif
}

void LoginHandler::logoutGooglePlus()
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    GlobalVariable::m_sDevice = 1;
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "logoutByGooglePlus", "()V"))
    {
        t.env->CallStaticVoidMethod(t.classID,t.methodID);
        t.env->DeleteLocalRef(t.classID);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    logoutByGooglePlus();
#endif
}

void LoginHandler::getAccountSuccessed(string sid)
{
    GlobalVariable::m_sSID = sid;
    ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
    SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
}

void LoginHandler::getAccountFail(string message)
{
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->hideLoading();
    string alertString = "";
    if(strcmp(message.c_str(), IDS_INVALID_CREDENTIAL) == 0 ||
       strcmp(message.c_str(), IDS_ACCOUNT_NOT_EXIST_OR_EMAIL) == 0 ||
       strcmp(message.c_str(), IDS_INVALID_ACCOUNT) == 0)
    {
        alertString = GlobalVariable::msgConst->getCurMsg(message.c_str());
    }
    else
    {
        alertString = message;
    }
    CCLOG("errorrrrrr %s", alertString.c_str());
    auto alp = AlertPopup::create(alertString);
    scene->openPopup(alp);
}

void LoginHandler::callSupport(std::string number)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "makeCallSupport", "(Ljava/lang/String;)V"))
    {
        jstring arg = t.env->NewStringUTF(number.c_str());
        t.env->CallStaticVoidMethod(t.classID,t.methodID, arg);
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(arg);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    makeCallSupport(number);
#endif
}

void LoginHandler::openFanpage(std::string url)
{
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
    JniMethodInfo t;
    if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "makeOpenFanpage", "(Ljava/lang/String;)V"))
    {
        jstring arg = t.env->NewStringUTF(url.c_str());
        t.env->CallStaticVoidMethod(t.classID,t.methodID, arg);
        t.env->DeleteLocalRef(t.classID);
        t.env->DeleteLocalRef(arg);
    }
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    makeOpenFanpage(url);
#endif
}