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
            LoadingScene* pLoadingScene = new LoadingScene();
            Director::getInstance()->replaceScene(pLoadingScene);
            break;
        }

        case kSceneLogin:
        {
            LoginScene* pLoginScene = new LoginScene();
            Director::getInstance()->replaceScene(pLoginScene);
            break;
        }

        case kSceneChooseGame:
        {
            ChooseGameScene* pChooseGameScene = new ChooseGameScene();
			Director::getInstance()->replaceScene(pChooseGameScene);
            break;
        }

        case kSceneLobby:
        {
            LobbyScene* pLobbyScene = new LobbyScene();
            pLobbyScene->autorelease();
			Director::getInstance()->replaceScene(pLobbyScene);
            break;
        }
        case kSceneInGame1:
        {
            CapsaBantingScene* pCapsaBantingGameScene = new CapsaBantingScene();
            pCapsaBantingGameScene->autorelease();
            Director::getInstance()->replaceScene(pCapsaBantingGameScene);
            break;
        }
        case kSceneInGame2:
        {
            CapsaSusunScene* pCapsaSusunScene = new CapsaSusunScene();
            pCapsaSusunScene->autorelease();
            Director::getInstance()->replaceScene(pCapsaSusunScene);
            break;
        }
        case kSceneInGame3:
        {
            TongitsGameScene* pTongitsGameScene = new TongitsGameScene();
            pTongitsGameScene->autorelease();
            Director::getInstance()->replaceScene(pTongitsGameScene);
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
            LoadingScene* pLoadingScene = new LoadingScene();
            Director::getInstance()->runWithScene(pLoadingScene);
            break;
        }

        case kSceneLogin:
        {
            LoginScene* pLoginScene = new LoginScene();
            Director::getInstance()->runWithScene(pLoginScene);
            break;
        }

        case kSceneChooseGame:
        {
            ChooseGameScene* pChooseGameScene = new ChooseGameScene();
            Director::getInstance()->runWithScene(pChooseGameScene);
            break;
        }

        case kSceneLobby:
        {
            LobbyScene* pLobbyScene = new LobbyScene();
            Director::getInstance()->runWithScene(pLobbyScene);
            break;
        }
        case kSceneInGame1:
        {
            CapsaBantingScene* pCapsaBantingGameScene = new CapsaBantingScene();
            Director::getInstance()->runWithScene(pCapsaBantingGameScene);
            break;
        }
        case kSceneInGame2:
        {
            CapsaSusunScene* pCapsaSusunScene = new CapsaSusunScene();
            Director::getInstance()->runWithScene(pCapsaSusunScene);
            break;
        }
            
        case kSceneInGame3:
        {
            TongitsGameScene* pTongitsGameScene = new TongitsGameScene();
            Director::getInstance()->runWithScene(pTongitsGameScene);
            break;
        }
            
        default:
            break;
    }
}