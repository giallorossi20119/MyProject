//
//  BaseCom.cpp
//  IndoGame
//
//  Created by Rainy on 8/15/14.
//
//

#include "BaseCom.h"

BaseCom::BaseCom()
{
    m_pLayout = nullptr;
}

void BaseCom::create(string p_sJsonLayoutFile)
{
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(p_sJsonLayoutFile.c_str()));
    addChild(m_pLayout);
}

BaseCom::~BaseCom()
{
    NotificationCenter::getInstance()->removeAllObservers(this);
    CC_SAFE_DELETE(m_pLayout);

    //m_vInts:stack
    //new std::vector<int>();:heap


}