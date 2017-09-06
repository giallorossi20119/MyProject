#include "IAPHandler.h"
#include "BaseScene.h"
#include "GlobalVariable.h"
#include "AlertPopup.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "jni.h"
#include "cocos/platform/android/jni/JniHelper.h"
extern "C"
{
	void Java_com_Pinoy_CapsaSusun_AppActivity_onNativePurchaseSucceed(JNIEnv *env, jobject obj, jstring money)
    {
        CCLOG("onNativePurchaseSucceed");
        jboolean isCopy = 1;
        string strMoney = env->GetStringUTFChars(money, &isCopy);
        GlobalVariable::m_sMoneyPurchase=strMoney;
        char* end;
        CCLOG("onNativePurchaseSucceed %s", strMoney.c_str());
        double dMoney = std::strtod(strMoney.c_str(), &end);
        CMDDoubleData* data = new CMDDoubleData(dMoney);
        data->autorelease();
        NotificationCenter::getInstance()->postNotification("UPDATE_USER_MONEY", data);
    }

    void Java_com_Pinoy_CapsaSusun_AppActivity_onNativePurchaseFail(JNIEnv *env, jobject obj, jstring msrError)
    {
        CCLOG("onNativePurchaseFail");
        jboolean isCopy = 1;
        string strError = env->GetStringUTFChars(msrError, &isCopy);
        CCLOG("onNativePurchaseFail %s", strError.c_str());
    }
}
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
extern void sendIAP(string sku);
#endif

void IAPHandler::sendPurchase(string sku)
{
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
	scene->showLoading();
    CCLOG("GamePinoy %s", sku.c_str());
#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
	JniMethodInfo t;
    GlobalVariable::m_sDevice = 1;
    
	if (JniHelper::getStaticMethodInfo(t, GlobalVariable::m_sAppPackage.c_str(), "sendIAP", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"))
	{
        jstring arg1 = t.env->NewStringUTF(GlobalVariable::m_sSID.c_str());
        jstring arg2 = t.env->NewStringUTF(ccsf("%1.0f", GlobalVariable::m_pUser->m_dId));
        jstring arg3 = t.env->NewStringUTF(GlobalVariable::m_sAppIDPurchase.c_str());
        jstring arg4 = t.env->NewStringUTF(sku.c_str());
		t.env->CallStaticVoidMethod(t.classID, t.methodID, arg1, arg2, arg3, arg4);
		t.env->DeleteLocalRef(arg1);
        t.env->DeleteLocalRef(arg2);
        t.env->DeleteLocalRef(arg3);
        t.env->DeleteLocalRef(arg4);
		t.env->DeleteLocalRef(t.classID);
	}
#elif CC_TARGET_PLATFORM == CC_PLATFORM_IOS
    GlobalVariable::m_sDevice = 2;
    sendIAP(sku);
#else

#endif
}