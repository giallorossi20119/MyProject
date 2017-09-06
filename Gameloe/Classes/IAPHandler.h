//
//  IAPHandler.h
//  IndoGame
//
//  Created by Rainy on 3/21/15.
//
//

#ifndef __IndoGame__IAPHandler__
#define __IndoGame__IAPHandler__

#include <iostream>
#include "singleton.h"
#include "cocos2d.h"

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
#include "jni.h"
#include "cocos/platform/android/jni/JniHelper.h"
#endif
class SFSConnection;

#if CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID
extern "C"
{
	extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativePurchaseSucceed(JNIEnv *env, jobject obj, jstring money);
	extern void Java_com_Gameloe_CapsaSusun_AppActivity_onNativePurchaseFail(JNIEnv *env, jobject obj, jstring msrError);
}
#endif
using namespace std;
class IAPHandler : public Singleton<IAPHandler>
{
    public:
    IAPHandler(){};
    ~IAPHandler(){};
    static void sendPurchase(string sku);
};
#endif /* defined(__IndoGame__IAPHandler__) */
