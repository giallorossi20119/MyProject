#include "PlayerInfoPopup.h"
#include "GlobalVariable.h"

std::string PlayerInfoPopup::COLOR_STAR_BLUE = "blue";
std::string PlayerInfoPopup::COLOR_STAR_RED = "red";
std::string PlayerInfoPopup::COLOR_STAR_PURPLE = "purple";
std::string PlayerInfoPopup::COLOR_STAR_YELLOW = "yellow";
std::string PlayerInfoPopup::COLOR_STAR_CYAN = "cyan";

PlayerInfoPopup::PlayerInfoPopup()
{
    isLoadedAva = false;
}


PlayerInfoPopup::~PlayerInfoPopup()
{
}

void PlayerInfoPopup::fillData(PlayerData* player)
{
    TextBMFont* bmfUID = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfUID"));
    bmfUID->setString(ccsf("%d",(int)player->m_dId));
    
    TextBMFont* bmfPlayerName = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfPlayerName"));
    if(player->m_sName.length() > 18)
    {
        bmfPlayerName->setString(ccsf("%s..", player->m_sName.substr(0, 18).c_str()));
    }
    else
    {
        bmfPlayerName->setString(player->m_sName.c_str());
    }
    
//    Button* btnChangeName = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnEdit"));
//    btnChangeName->setVisible(false);
    //btnChangeName->addTouchEventListener(CC_CALLBACK_2(PlayerInfoPopup::changeName, this));
    /*
     bool noNeedChangeName = UserDefault::getInstance()->getBoolForKey("NoNeedChangeName");
     if(!noNeedChangeName)
     {
     if(GlobalVariable::m_bMe)
     {
     btnChangeName->setVisible(true);
     }
     else
     {
     btnChangeName->setVisible(false);
     }
     }
     */
//    TextBMFont* bmfExp = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfExp"));
//    bmfExp->setString(ccsf("%d", TTutil::getPercentFormExp(player->m_iExp)));
    
    TextBMFont* bmfLevel = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfLevel"));
    bmfLevel->setString(ccsf("%ld", player->m_iLevel));
    
    TextBMFont* bmfMoney = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfMoney"));
    bmfMoney->setString(TTutil::addDot(ccsf("%1.0f", player->m_dMoney)));
    
    TextBMFont* bmfWin = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfWin"));
    bmfWin->setString(TTutil::addDot(ccsf("%1.0ld", player->m_iWin)));
    
    TextBMFont* bmfTotal = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTotal"));
    bmfTotal->setString(TTutil::addDot(ccsf("%1.0ld", player->m_iTotal)));
    
    LoadingBar* prgExp = static_cast<LoadingBar*>(Helper::seekWidgetByName(m_pLayout, "prgExp"));
    prgExp->setPercent(TTutil::getPercentFormExp((int)GlobalVariable::m_pUser->m_iExp));
    
    // Clear old symbol
    if (m_symbol != nullptr)
    {
        m_pLayout->removeChild(m_symbol);
    }
    // Clear old stars
    if (m_vStar.size() > 0)
    {
        for (int i = 0, l = m_vStar.size(); i < l; i++)
        {
            Sprite* star = m_vStar.at(i);
            m_pLayout->removeChild(star);
        }
        m_vStar.clear();
    }
    initStar(player);
    
    if (!isLoadedAva)
    {
        ImageView* imgAvatar = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgAvatar"));
        ImageLoader* imgAva = ImageLoader::create();
        imgAvatar->addChild(imgAva);
        imgAva->setMaxSize(Size(85, 85));
        imgAva->setPosition(Vec2(imgAvatar->getContentSize().width / 2, ((imgAvatar->getContentSize().height) / 2) + 8));
        std::string sImgPath("http://ava.gameloe.com/63000005319");
//        sImgPath.append(ccsf("%f", GlobalVariable::m_pUser->m_dId));
//        sImgPath.append(".game.ava");
        imgAva->loadImage(sImgPath.c_str());
        isLoadedAva = true;
    }
    
    isLoadedAva = true;
}

void PlayerInfoPopup::changeName(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
//    auto popup = ChangeNamePopup::create();
//    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
//    scene->closeLastPopup();
//    scene->openPopup(popup);
}

void PlayerInfoPopup::onOpen()
{
    BasePopup::onOpen();
    m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile(kPlayerInfoPopup));
    this->addChild(m_pLayout);
    Button* btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    btnClose->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    Size deviceSize = Director::getInstance()->getWinSize();
    m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
    m_pLayout->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    m_pLayout->addTouchEventListener(CC_CALLBACK_2(BasePopup::onTouchOverlay, this));
    setTextLanguage();
    setLightPosition();
}

void PlayerInfoPopup::onClose()
{
    BasePopup::onClose();
}

void PlayerInfoPopup::initStar(PlayerData* player)
{
    std::string colorStar = getColorStar(player);
    int noStar = getNoStar(player);
    std::string fileNameStar = "Star_" + colorStar + ".png";
    for (int i = 4; i >= 0; i--)
    {
        Sprite* star = 0;
        if (i < noStar) star = Sprite::create(fileNameStar);
        else star = Sprite::create("Star_grayscale.png");
        m_pLayout->addChild(star);
        star->setAnchorPoint(Vec2(0.5f, 0.5f));
        star->setPosition(Vec2(160.0f + i * 9.0f, 113.0f));
        m_vStar.push_back(star);
    }
}

std::string PlayerInfoPopup::getColorStar(PlayerData* player)
{
    int level = player->m_iLevel;
    std::string color = COLOR_STAR_BLUE;
    if (0 <= level && level <= 10) color = COLOR_STAR_BLUE;
    else if (11 <= level && level <= 20) color = COLOR_STAR_CYAN;
    else if (21 <= level && level <= 30) color = COLOR_STAR_PURPLE;
    else if (31 <= level && level <= 40) color = COLOR_STAR_RED;
    else color = COLOR_STAR_YELLOW;
    return color;
}

int PlayerInfoPopup::getNoStar(PlayerData* player)
{
    int level = player->m_iLevel;
    if (level > 50) return 5;
    int noStar = (((level%10-1)/2) >> 0) + 1;
    return noStar;
}

void PlayerInfoPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void PlayerInfoPopup::setTextLanguage()
{
    TextBMFont* bmfTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTitle"));
    bmfTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_INFOMATION));
    Button* btnClose = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnClose"));
    TextBMFont* bmfClose = static_cast<TextBMFont*>(btnClose->getChildByName("bmfClose"));
    bmfClose->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CLOSE));
}