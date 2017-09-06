//
//  SceneManager.cpp
//  IndoGame
//
//  Created by Rainy on 8/19/14.
//
//

#include "SceneManager.h"

SceneManager::SceneManager()
{
    m_iCurrentScene = 0;
}

SceneManager::~SceneManager()
{
}

void SceneManager::switchScene(int p_iNewSceneId, Ref* data)
{
    m_iCurrentScene = p_iNewSceneId;
    switch(p_iNewSceneId)
    {
        case kSceneLoading:
        {
            LoadingScene* scene = new LoadingScene();
            scene->autorelease();
            Director::getInstance()->replaceScene(scene);
            break;
        }

        case kSceneLogin:
        {
            LoginScene* scene = new LoginScene();
            scene->autorelease();
            Director::getInstance()->replaceScene(scene);
            break;
        }

        case kSceneChooseGame:
        {
            ChooseGameScene* scene = new ChooseGameScene();
            scene->autorelease();
			Director::getInstance()->replaceScene(scene);
            break;
        }

        case kSceneLobby:
        {
            LobbyScene* scene = new LobbyScene();
            scene->autorelease();
			Director::getInstance()->replaceScene(scene);
            break;
        }
        case kSceneInGame1:
        {
            CapsaBantingScene* scene = new CapsaBantingScene();
            scene->autorelease();
            Director::getInstance()->replaceScene(scene);
            break;
        }

        case kSceneInGame2:
        {
            CapsaSusunScene* scene = new CapsaSusunScene();
            scene->autorelease();
            Director::getInstance()->replaceScene(scene);
            break;
        }
    }
}

void SceneManager::run(int p_iSceneId)
{
    m_iCurrentScene = p_iSceneId;
    switch(p_iSceneId)
    {
        case kSceneLoading:
        {
            LoadingScene* scene = new LoadingScene();
            scene->autorelease();
            Director::getInstance()->runWithScene(scene);
            break;
        }

        case kSceneLogin:
        {
            LoginScene* scene = new LoginScene();
            scene->autorelease();
            Director::getInstance()->runWithScene(scene);
            break;
        }

        case kSceneChooseGame:
        {
            ChooseGameScene* scene = new ChooseGameScene();
            scene->autorelease();
            Director::getInstance()->runWithScene(scene);
            break;
        }

        case kSceneLobby:
        {
            LobbyScene* scene = new LobbyScene();
            scene->autorelease();
            Director::getInstance()->runWithScene(scene);
            break;
        }

        case kSceneInGame2:
        {
            CapsaSusunScene* scene = new CapsaSusunScene();
            scene->autorelease();
            Director::getInstance()->runWithScene(scene);
            break;
        }
        default:
            break;
    }
}