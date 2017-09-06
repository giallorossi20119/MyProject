//
//  ResourceManager.h
//  IndoGame
//
//  Created by Rainy on 8/4/14.
//
//

#ifndef __IndoGame__ResourceManager__
#define __IndoGame__ResourceManager__

#include <iostream>
#include "Constant.h"
#include "cocos2d.h"
#include "Singleton.h"
#include "rapidjson.h"
#include "document.h"
#include "TextData.h"
#include <vector>
#include "extensions/cocos-ext.h"
#include "network/HttpClient.h"
#include "AudioManager.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "spine/SkeletonAnimation.h"

USING_NS_CC;
USING_NS_NET;
USING_NS_CC_EXT;
USING_NS_UI;
USING_NS_STD;

class ResourceManager : public Singleton<ResourceManager>
{
public:
    ResourceManager();
    ~ResourceManager();
    static bool m_bLoadConfigFinish;
    static spine::SkeletonRenderer* m_aSkeletonRendererCache[kNOAnims];
    static spine::SkeletonAnimation* m_aSkeletonAnimation[kNOAnims];
    rapidjson::Document m_jTextData;
    rapidjson::Document m_jTextMessage;
    std::string getTextByName(const char* p_sTextName);
    void loadConfig();
    void loadTextData();
    void setLanguage(int p_iLanguageId);
    void loadSoundData();
    void loadSceneData();
    void loadTextureData();
    void loadTextureEffect();
    void checkAccountMode();
    void loadTextMessage();
    void onResponseAccountMode(HttpClient *sender, HttpResponse *response);
    void onHttpRequestCompleted(HttpClient *sender, HttpResponse *response);
	void onResponseLang(HttpClient* sender, HttpResponse* response);
	void loadLanguagesData();
    void cacheScene();
    void cacheSpine();
	HttpRequest* m_requestLang;
    //cache game scene
    Layout* m_aLayouts[10];
	ListView* m_p_lListRoom;
    Layout* m_p_lItemListView;
    Layout* m_loChatPopup;
};

#endif /* defined(__IndoGame__ResourceManager__) */
