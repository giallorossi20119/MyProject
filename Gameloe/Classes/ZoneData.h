//
//  ZoneData.h
//  IndoGame
//
//  Created by Rainy on 8/1/14.
//
//

#ifndef __IndoGame__ZoneData__
#define __IndoGame__ZoneData__

#include <iostream>

class ZoneData
{
public:
    ZoneData();
    ~ZoneData();
    std::string m_sName;
    std::string m_sHostIp;
    std::string m_sTilte;
    double      m_dMinMoney;
    int         m_iMinLevel;
    int         m_iPort;

};
#endif /* defined(__IndoGame__ZoneData__) */
