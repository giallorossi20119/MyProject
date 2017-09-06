//
//  SceneManager.h
//  IndoGame
//
//  Created by Rainy on 8/19/14.
//
//

#ifndef __IndoGame__SceneManager__
#define __IndoGame__SceneManager__

#include <iostream>
#include "Singleton.h"
#include "Constant.h"
#include "LoadingScene.h"
#include "LoginScene.h"
#include "ChooseGameScene.h"
#include "LobbyScene.h"
#include "CapsaBantingScene.h"
#include "CapsaSusunScene.h"
#include "GlobalVariable.h"
#include "CMDSusunData.h"
class SceneManager : public Singleton<SceneManager>
{
public:
    SceneManager();
    ~SceneManager();
    int m_iCurrentScene;
    void switchScene(int p_iNewSceneId, Ref* data = NULL);
    void run(int p_iSceneId);

};
#endif /* defined(__IndoGame__SceneManager__) */
