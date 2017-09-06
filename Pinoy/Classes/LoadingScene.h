//
//  LoadingScene.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__LoadingScene__
#define __IndoGame__LoadingScene__

#include <iostream>
#include "BaseScene.h"
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;

class LoadingScene : public BaseScene
{
public:

    LoadingScene();
    ~LoadingScene();
    virtual void onEnter();
    virtual void onExit();
    virtual void update(float dt);
    void relayout();
    virtual void addEventlistener();
	void loadingCallBack(cocos2d::Texture2D *texture);
	void updateLoadingBar(float dt);
    bool m_bIsResourceLoaded;
    void loadResource();
};
#endif /* defined(__IndoGame__LoadingScene__) */
