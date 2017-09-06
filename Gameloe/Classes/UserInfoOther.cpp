//
//  UserInfoOtherOther.cpp
//  IndoGame
//
//  Created by Rainy on 8/22/14.
//
//

#include "UserInfoOther.h"
#include "GlobalVariable.h"
#include "ImageLoader.h"
#include "PlayerInfoPopup.h"
void UserInfoOther::fillDataUserInfo(const PlayerData* playerData)
{
    TextField* txtUserId = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtUserId"));
    m_dUserId = playerData->m_dId;
    m_iSFSId = playerData->m_iSfsId;
	txtUserId->setString(ccsf("%f", playerData->m_dId));
    txtUserId->setVisible(false);
	TextBMFont* bmfPlayerName = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfPlayerName"));

    if(playerData->m_sName.length() > 12)
    {
        bmfPlayerName->setString(ccsf("%s..", playerData->m_sName.substr(0, 11).c_str()));
    }
    else
    {
        bmfPlayerName->setString(playerData->m_sName.c_str());
    }
	TextBMFont* bmfGold = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfGold"));
	bmfGold->setString(TTutil::addDot(ccsf("%1.0f", playerData->m_dMoney)));

    ImageView* imgDevice = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgDevice"));
    if(playerData->m_sDevice == 1)
    {
        imgDevice->loadTexture("android.png");
    }
    else if (playerData->m_sDevice == 2)
    {
        imgDevice->loadTexture("apple.png");
    }
    else
    {
        imgDevice->loadTexture("PC.png");
    }

    setVisibleNOCard(false);

	ImageView* imgExp = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgExp"));
    imgExp->setVisible(false);
    ImageView* imgVipIcon = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgVipIcon"));
    imgVipIcon->setVisible(false);
    ImageView* imgHost = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgHost"));
    if(playerData->m_bHost)
    {
        imgHost->setVisible(true);
    }
    else
    {
        imgHost->setVisible(false);
    }
    Button* btnKick = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnKick"));
    btnKick->addTouchEventListener(CC_CALLBACK_2(UserInfoOther::onBtnKickClick, this));
    btnKick->setVisible(false);
	ImageView* imgAvatar = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgAvatar"));
	ImageLoader* imgAva = ImageLoader::create();
	imgAvatar->addChild(imgAva);
	imgAva->setMaxSize(Size(58, 58));
	imgAva->setPosition(Vec2(imgAvatar->getContentSize().width / 2, ((imgAvatar->getContentSize().height) / 2) + 6));
    std::string sImgPath(ccsf("%1.0f", playerData->m_dId));
	imgAva->loadImage(sImgPath.c_str());
}

void UserInfoOther::updateMoney(double p_dMoney)
{
	TextBMFont* bmfGold = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfGold"));
	bmfGold->setString(TTutil::addDot(ccsf("%1.0f", p_dMoney)));
}

void UserInfoOther::updateNOCardsRemain(int p_iNOCardsRemain)
{
    TextBMFont* lblNumCards = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "lblNumCards"));
    lblNumCards->setVisible(true);
    lblNumCards->setString(ccsf("%d", p_iNOCardsRemain));
}

void UserInfoOther::setTurnEffect(bool visible, int duration)
{
    Layout* pnlAvatar = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlAvatar"));
    pnlAvatar->removeAllChildren();
    if(visible)
    {
        pnlAvatar->setAnchorPoint(Vec2(-0.5f, -0.5f));
        auto timeLine = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimTimeLine]->getSkeleton()->data);
        timeLine->setScale(0.6f);
        timeLine->setName("timeLine");
        if(duration == 10)
        {
            timeLine->setMix("10s", "10s", 10.0f);
            timeLine->addAnimation(0, "10s", false);
        }
        else if (duration == 15)
        {
            timeLine->setMix("15s", "15s", 15.0f);
            timeLine->addAnimation(0, "15s", false);
        }
        else if (duration == 20)
        {
            timeLine->setMix("20s", "20s", 20.0f);
            timeLine->addAnimation(0, "20s", false);
        }
        else
        {
            timeLine->setTimeScale((float)10 / (float)duration);
            timeLine->setMix("10s", "10s", duration);
            timeLine->addAnimation(0, "10s", false);
        }
        pnlAvatar->addChild(timeLine);
    }
}

void UserInfoOther::setVisibleNOCard(bool bValue)
{
    TextBMFont* lblNumCards = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "lblNumCards"));
    lblNumCards->setVisible(bValue);
}

void UserInfoOther::setVisibleHost(bool bValue)
{
    ImageView* imgHost = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgHost"));
    imgHost->setVisible(bValue);
}

void UserInfoOther::onImgAvatarClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    GlobalVariable::m_bMe = false;
    SFSConnection::getInstance()->getPlayerInfo(m_iSFSId);
}

void UserInfoOther::alignRight()
{
    ImageView* imgNumCardsBg = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgNumCardsBg"));
    ImageView* imgCardIcon = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgCardIcon"));
    Text* lblNumCards = static_cast<Text*>(imgNumCardsBg->getChildByName("lblNumCards"));
    imgNumCardsBg->setFlippedX(true);
    imgNumCardsBg->setPositionX(imgNumCardsBg->getPositionX() - 72);
    imgCardIcon->setFlippedX(true);
    imgCardIcon->setPositionX(imgCardIcon->getPositionX() - 124);
    lblNumCards->setFlippedX(true);
}

UserInfoOther::UserInfoOther()
{
    BaseCom();
    BaseCom::create(kComponentPlayerInfoFile);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(UserInfoOther::updateUserInfo), C_UPDATE_INFO_USER, nullptr);
    Layout* pnlAvatar = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlAvatar"));
    pnlAvatar->addTouchEventListener(CC_CALLBACK_2(UserInfoOther::onImgAvatarClick, this));
}

UserInfoOther::~UserInfoOther()
{
}

UserInfoOther* UserInfoOther::create()
{
    UserInfoOther* userInfo = new UserInfoOther();
    userInfo->autorelease();
    return userInfo;
}

void UserInfoOther::onBtnKickClick(Ref *pSender, Widget::TouchEventType type)
{
    //CCLOG("onBtnKickClick");
    if (Widget::TouchEventType::ENDED != type) return;
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    ConfirmPopup* cfm = new ConfirmPopup(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_KICK_USER));
    scene->openPopup(cfm);
    cfm->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, CC_CALLBACK_1(UserInfoOther::confirmKick, this));
}

void UserInfoOther::confirmKick(EventCustom* event)
{
    SFSConnection::getInstance()->kickUser(0, m_dUserId);
}

void UserInfoOther::setVisibleKickBtn(bool bValue)
{
    Button* btnKick = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnKick"));
    btnKick->setVisible(bValue);
}

void UserInfoOther::updateUserInfo(Ref* obj)
{
	if (!getParent()) return;
    PlayerData* player = (PlayerData*)obj;
    if(player == nullptr) return;
    if(player->m_dId == m_dUserId)
    {
        fillDataUserInfo(player);
    }
}