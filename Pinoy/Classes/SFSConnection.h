#ifndef __IndoGame__SFSConnection__
#define __IndoGame__SFSConnection__

#include <iostream>
#include <string>
#include "SmartFox.h"
#include "Core/BaseEvent.h"
#include "cocos2d.h"
#include "Singleton.h"
#include "HttpClient.h"
#include "BaseScene.h"
#include "AlertPopup.h"
#include "LoginHandler.h"
#include "Constant.h"
#include "CMDBantingData.h"

class LoginHandler;
using namespace Sfs2X;

class SFSConnection : public Singleton<SFSConnection>
{
private:
public:
    SFSConnection();
    ~SFSConnection();
    int m_iPingCount;
    //init the server, and set ThreadSafeMode to true
    void initServer( );

    //update the server manually
    void updateEvent( );

    //get the smartfox
    boost::shared_ptr<Sfs2X::SmartFox> getSmartFox(){ return mSmartFox;};

    //connect
    void connectToServer(char const* p_sHostIp, int p_iPort );

    //disconnect
    void disconnectToServer();

	void login(std::string p_sID, std::string domain, std::string p_sZoneName);

    //get rank
    void getRank();

    //get Tables
    void getTables();

    //invite
    void invite(int invitedId);

    //get waiting list
    void getWaitingList();
    
    //join room
    void joinRoom(std::string p_sRoomName);
    //notify the server, now is waiting for other player
    void waitingForOther( );

    //send a msg
    void sendMsg( const char * strMsg );

	//request playnow
	void playNow();
    //create room
    void createRoom();
    //fire Card
    void fireCard(boost::shared_ptr<ByteArray> bytesCards);
    //drop card
    void dropCard(boost::shared_ptr<ByteArray> bytesCards);
    //send card
    void sendCard(boost::shared_ptr<ByteArray> bytesCards);
    //eat card
    void eatCard(boost::shared_ptr<ByteArray> bytesCards);
    //start Game
    void startGame();
    //ignore card
    void ignoreCard();
    //pick card
    void pickCard();
    //request draw
    void requestDraw();
    //confirm draw
    void requestDrawConfirm(bool accept);
    //ping
    void ping();
    //request u
    void requestU();
    //auto
    void autoFire();
	//request rank
	void requestRank();
	//request change setting in game
	void requestChangeSettingRoom(int stake, int times);
    //kick user
    void kickUser(long iKickedUserId = 0, double dKickedUserId = 0);
    //Susun
    void xepxong(vector<int>* m_vCardsId, bool bStatus);
    void getPlayerInfo(long iSFSId);
	void requestMauBinh(int typeMB, vector<int> cards);
    //End Susun
    //smartfox callback
    static void onSmartFoxPingPong(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnSmartFoxConnection(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnSmartFoxConnectionLost(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnSmartFoxDisconnection(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);

    static void OnSmartFoxRoomJoin(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnSmartFoxRoomJoinError(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnUserExitRoom(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);

    static void OnSmartFoxPublicMessage(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnExtensionResponse(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);

    static void OnSmartFoxLogin(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);
    static void OnSmartFoxLoginError(unsigned long long ptrContext, boost::shared_ptr<BaseEvent> ptrEvent);

    //set the gaming room
    void setGamingRoome( boost::shared_ptr<Room> pRoom ){ mGamingRoom = pRoom; };
    bool isConnected();
private:
    static boost::shared_ptr<Sfs2X::SmartFox> mSmartFox;
    boost::shared_ptr<Room> mGamingRoom;
public:
    static bool isServerInit;
};

class MsrObject : public Node
{
public:
	MsrObject(){};
	~MsrObject(){};
	MsrObject(int id, std::string name)
	{
		m_dId = id;
		m_sUsername = name;
	}
	static MsrObject* create(int id, std::string name)
	{
		MsrObject* obj = new MsrObject(id, name);
		obj->autorelease();
		return obj;
	}

	int m_dId;
	std::string m_sUsername;
private:

};


#endif /* defined(__IndoGame__SFSConnection__) */
