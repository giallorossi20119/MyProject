#ifndef __IndoGame__PlayerInfoPopup__
#define __IndoGame__PlayerInfoPopup__

#include <iostream>
#include "BaseScene.h"
#include "PlayerData.h"

class PlayerInfoPopup : public BasePopup
{
public:
    static std::string COLOR_STAR_BLUE;
    static std::string COLOR_STAR_RED;
    static std::string COLOR_STAR_PURPLE;
    static std::string COLOR_STAR_YELLOW;
    static std::string COLOR_STAR_CYAN;
    
    PlayerInfoPopup();
    ~PlayerInfoPopup();
    
    void onOpen();
    void onClose();
    void fillData(PlayerData* player);
    void changeLanguage(Ref* obj);
    void setTextLanguage();
    bool isLoadedAva;
    void changeName(Ref *pSender, Widget::TouchEventType type);
private:
    void initStar(PlayerData* player);
    
    std::string getColorStar(PlayerData* player);
    int getNoStar(PlayerData* player);
    
    Sprite* m_symbol;
    vector<Sprite*> m_vStar;
};

#endif