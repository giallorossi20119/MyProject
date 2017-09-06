//
//  UserInfo.cpp
//  IndoGame
//
//  Created & Modified by longnh on 8/14/14.
//
//

#include "UserInfo.h"
#include "GlobalVariable.h"
#include "ImageLoader.h"
#include "RegisterPopup.h"
#include "BasePopup.h"

std::string UserInfo::COLOR_STAR_BLUE   = "blue";
std::string UserInfo::COLOR_STAR_RED    = "red";
std::string UserInfo::COLOR_STAR_PURPLE = "purple";
std::string UserInfo::COLOR_STAR_YELLOW = "yellow";
std::string UserInfo::COLOR_STAR_CYAN   = "cyan";

void UserInfo::fillDataUserInfo()
{
    if(m_pLayout->getChildByName("ExpEffect"))m_pLayout->removeChildByName("ExpEffect");
    TextBMFont* bmfLevel = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfLevel"));
    bmfLevel->setString(ccsf("Lv %ld", GlobalVariable::m_pUser->m_iLevel));
    
    TextBMFont* bmfGold = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfGold"));
    bmfGold->setString(TTutil::addDot(ccsf("%1.0f", GlobalVariable::m_pUser->m_dMoney)));
    
    btnWarning = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnWarning"));
    btnWarning->addTouchEventListener(CC_CALLBACK_2(UserInfo::onBtnWarningClick, this));
    
    int mode = UserDefault::getInstance()->getIntegerForKey("AccountMode");
//    if(mode == kAccountModeGuest && LoginHandler::getInstance()->m_iLoginType == kLoginTypeDeviceID)
//    {
//        btnWarning->setVisible(true);
//        btnWarning->runAction(RepeatForever::create(Sequence::create(FadeTo::create(0.3f, 255), FadeTo::create(0.3f, 0), NULL)));
//    }
//    else
//    {
        btnWarning->setVisible(false);
//    }
    m_bmfUsername = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfUserName"));
    if(GlobalVariable::m_pUser->m_sName.length() > 15)
    {
        m_bmfUsername->setString(ccsf("%s..", GlobalVariable::m_pUser->m_sName.substr(0, 13).c_str()));
    }
    else
    {
        m_bmfUsername->setString(GlobalVariable::m_pUser->m_sName.c_str());
    }
    LoadingBar* prgExp = static_cast<LoadingBar*>(Helper::seekWidgetByName(m_pLayout, "prgExp"));
    prgExp->setPercent(TTutil::getPercentFormExp((int)GlobalVariable::m_pUser->m_iExp));
    
    ImageView* imgHost = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgHost"));
    
    if(GlobalVariable::m_pUser->m_bHost)
    {
        imgHost->setVisible(true);
    }
    else
    {
        imgHost->setVisible(false);
    }
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
    initStar();
    
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
    
    
    ImageView* imgBG = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgBG"));
    imgBG->setVisible(false);
    /*
     if(imgBG->getChildByName("lightLeft"))imgBG->removeChildByName("lightLeft");
     if(imgBG->getChildByName("lightRight"))imgBG->removeChildByName("lightRight");
     auto lightLeft = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLight]->getSkeleton()->data);
     lightLeft->setScale(0.8f);
     lightLeft->setName("lightLeft");
     lightLeft->setMix("trai", "trai", 1.0f);
     lightLeft->addAnimation(0, "trai", true);
     imgBG->addChild(lightLeft);
     lightLeft->setPosition(Vec2(imgBG->getContentSize().width / 2, 15));
     
     auto lightRight = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLight]->getSkeleton()->data);
     lightRight->setScale(0.8f);
     lightRight->setName("lightRight");
     lightRight->setMix("phai", "phai", 1.0f);
     lightRight->addAnimation(0, "phai", true);
     imgBG->addChild(lightRight);
     lightRight->setPosition(Vec2(300, 300));
     lightRight->setPosition(Vec2(imgBG->getContentSize().width / 2, imgBG->getContentSize().height));
     */
}

void UserInfo::onBtnWarningClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    bool noNeedChangeName = UserDefault::getInstance()->getBoolForKey("NoNeedChangeName");
    if(noNeedChangeName && LoginHandler::getInstance()->m_iLoginType == kLoginTypeDeviceID)
    {
        RegisterPopup* rpu = RegisterPopup::create();
        scene->openPopup(rpu);
    }
    else
    {
//        auto cpu = ChangeNamePopup::create();
//        scene->openPopup(cpu);
    }
}

void UserInfo::onImgAvatarClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
//    GlobalVariable::m_bMe = true;
    SFSConnection::getInstance()->getPlayerInfo(GlobalVariable::m_pUser->m_iSfsId);
}

void UserInfo::updateMoney(double p_dMoney)
{
    TextBMFont* bmfGold = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfGold"));
    bmfGold->setString(TTutil::addDot(ccsf("%1.0f", p_dMoney)));
}

void UserInfo::updateAccount()
{
    btnWarning->setVisible(false);
}

void UserInfo::updateName()
{
    if(GlobalVariable::m_pUser->m_sName.length() > 15)
    {
        m_bmfUsername->setString(ccsf("%s..", GlobalVariable::m_pUser->m_sName.substr(0, 13).c_str()));
    }
    else
    {
        m_bmfUsername->setString(GlobalVariable::m_pUser->m_sName.c_str());
    }
}

void UserInfo::initStar()
{
    std::string colorStar = getColorStar();
    int noStar = getNoStar();
    std::string fileNameStar = "Star_" + colorStar + ".png";
    for (int i = 4; i >= 0; i--)
    {
        Sprite* star = 0;
        if (i < noStar) star = Sprite::create(fileNameStar);
        else star = Sprite::create("Star_grayscale.png");
        m_pLayout->addChild(star);
        star->setAnchorPoint(Vec2(0.5f, 0.5f));
        star->setPosition(Vec2(156.0f + i * 9.0f, 25.0f));
        m_vStar.push_back(star);
    }
}

std::string UserInfo::getColorStar()
{
    int level = GlobalVariable::m_pUser->m_iLevel;
    std::string color = COLOR_STAR_BLUE;
    if (0 <= level && level <= 10) color = COLOR_STAR_BLUE;
    else if (11 <= level && level <= 20) color = COLOR_STAR_CYAN;
    else if (21 <= level && level <= 30) color = COLOR_STAR_PURPLE;
    else if (31 <= level && level <= 40) color = COLOR_STAR_RED;
    else color = COLOR_STAR_YELLOW;
    return color;
}

int UserInfo::getNoStar()
{
    int level = GlobalVariable::m_pUser->m_iLevel;
    if (level > 50) return 5;
    int noStar = (((level%10-1)/2) >> 0) + 1;
    return noStar;
}

UserInfo::UserInfo()
{
    BaseCom();
    BaseCom::create(kComponentUserInfoFile);
    isLoadedAva = false;
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(UserInfo::updateUserInfo), C_UPDATE_INFO_USER, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(UserInfo::updateUserMoney), "UPDATE_USER_MONEY", nullptr);
    Layout* pnlAvatar = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlAvatar"));
    pnlAvatar->addTouchEventListener(CC_CALLBACK_2(UserInfo::onImgAvatarClick, this));
}

UserInfo::~UserInfo()
{
}

void UserInfo::visibleHost(bool bHost)
{
    ImageView* imgHost = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgHost"));
    imgHost->setVisible(bHost);
}

void UserInfo::updateUserInfo(Ref* sender)
{
    if (!getParent()) return;
    fillDataUserInfo();
    if(m_pLayout->getChildByName("ExpEffect"))m_pLayout->removeChildByName("ExpEffect");
    auto ExpEffect = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimExp]->getSkeleton()->data);
    ExpEffect->setName("ExpEffect");
    ExpEffect->setMix("exp", "exp", 2.0f);
    ExpEffect->addAnimation(0, "exp", false);
    ExpEffect->setPosition(Vec2(155, 45));
    m_pLayout->addChild(ExpEffect);
}

void UserInfo::updateUserMoney(Ref* sender)
{
    CMDDoubleData* data = (CMDDoubleData*)sender;
    if (!getParent()) return;
    updateMoney(data->m_dValue);
    if(m_pLayout->getChildByName("ExpEffect"))m_pLayout->removeChildByName("ExpEffect");
    auto ExpEffect = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimExp]->getSkeleton()->data);
    ExpEffect->setName("ExpEffect");
    ExpEffect->setMix("exp", "exp", 2.0f);
    ExpEffect->addAnimation(0, "exp", false);
    ExpEffect->setPosition(Vec2(155, 45));
    m_pLayout->addChild(ExpEffect);
}
