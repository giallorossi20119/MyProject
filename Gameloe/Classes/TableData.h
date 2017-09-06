//
//  TableData.h
//  IndoGame
//
//  Created by Rainy on 8/15/14.
//
//

#ifndef __IndoGame__TableData__
#define __IndoGame__TableData__

#include <iostream>
#include "Constant.h"
#include "PlayerData.h"

USING_NS_STD;

class TableData
{
public:
    TableData();
    TableData(TableData* p_tTableData);
    ~TableData();
    vector<PlayerData*>* m_lPlayers; // array of user model current in table
    string m_sName;
    string m_sTitle;// title of table ("Làm một ván nhé ")
    string m_sMethod;
    long m_iCuoc; // Số tiền cược
    long m_iId;
    long m_iNumber;// Số thứ tự bàn
    long m_iTimer;
    long m_iMaxPlayers;// số lượng người cho phép trong bàn
    long m_iNumPlayers;//so luong nguoi choi hien tai
    short m_iTotalTime;
    bool m_bGa;// Bàn có chơi gà hay không
    bool m_bPlaying;//đang chơi hay không
};
#endif /* defined(__IndoGame__TableData__) */
