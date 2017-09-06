//
//  SFSResponse.h
//  IndoGame
//
//  Created by Rainy on 10/2/14.
//
//

#ifndef __IndoGame__SFSResponse__
#define __IndoGame__SFSResponse__

#include <iostream>
#include "SmartFox.h"
#include "cocos2d.h"
#include "Constant.h"
#include "EventConst.h"
#include "GlobalVariable.h"
#include "CMDBantingData.h"
#include "CMDSusunData.h"

class SFSResponse
{
public:
    static void parse(int pGameId, const char* cmd,
                            boost::shared_ptr<ByteArray> btrd,
                            boost::shared_ptr<ByteArray> btrt,
                            boost::shared_ptr<ByteArray> btrc,
                            boost::shared_ptr<ByteArray> btrg,
                            boost::shared_ptr<ByteArray> btrn);
    static void proc_Rank(boost::shared_ptr<ByteArray> btrd);
    static void proc_ClientLobby(boost::shared_ptr<ByteArray> btrd);
    static void sortPlayers();
};
#endif /* defined(__IndoGame__SFSResponse__) */
