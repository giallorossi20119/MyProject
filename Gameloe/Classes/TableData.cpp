//
//  TableData.cpp
//  IndoGame
//
//  Created by Rainy on 8/15/14.
//
//

#include "TableData.h"

TableData::TableData()
{
    m_lPlayers    = new vector<PlayerData*>();
    m_sName       = "";
    m_sTitle      = "";
    m_sMethod     = "";
    m_iCuoc       = 0;
    m_iId         = 0;
    m_iNumber     = 0;
    m_iTimer      = 0;
    m_iMaxPlayers = 0;
    m_iNumPlayers = 0;
    m_iTotalTime  = 0;
    m_bGa         = false;
    m_bPlaying    = false;
}

TableData::TableData(TableData* p_tTableData)
{
    m_lPlayers    = p_tTableData->m_lPlayers;
    m_sName       = p_tTableData->m_sName;
    m_sTitle      = p_tTableData->m_sTitle;
    m_iCuoc       = p_tTableData->m_iCuoc;
    m_iTotalTime  = p_tTableData->m_iTotalTime;
    m_iNumPlayers = p_tTableData->m_iNumPlayers;
    m_bGa         = p_tTableData->m_bGa;
    m_bPlaying    = p_tTableData->m_iTotalTime;
}
