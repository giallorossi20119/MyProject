#include "CapsaBantingScene.h"
//#include "QuestBonusPopup.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;


//const
#define kDISTANCE_X_2_CARDS        60
#define kDISTANCE_X_2_CARDS_1      20
#define kDISTANCE_X_2_CARDS_2      15
#define kDISTANCE_Y_2_CARDS        8
#define kDISTANCE_Y_2_CARDS_2      10
#define kCARD_SCALE_FACTOR_SMALL   0.4f
#define kCARD_SCALE_FACTOR_SMALL_2 0.3f
#define kDISTANCE_Y_ALL_CARDS      120
#define kDISTANCE_X_CARD_ON_TABLE  60
#define kDISTANCE_Y_CARD_ON_TABLE  40
#define kDISTANCE_X_CARD_ON_HAND_TABLE  40
#define kDISTANCE_Y_BUTTON_SUGGEST      70

//*******************************
// start pragma init Scene
//*******************************
int g_iDistance = 0;
void CapsaBantingScene::onEnter()
{
    BaseScene::onEnter();
    schedule(schedule_selector(CapsaBantingScene::update));
    //load scene
    AudioManager::getInstance()->stopSoundBackground();
    BaseScene::initUI(kSceneJsonCapsaBantingGame);
    
    addEventlistener();
    for(int i = 0; i < 4; i++)
    {
        pnlPlayerAreas[i] = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, ccsf("pnlPlayerArea%d", i)));
        Button* btnInvite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        if(btnInvite)
        {
            btnInvite->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnInviteClick, this));
        }
        
        Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
        if(pnlInvite)
        {
            if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
            auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
            animCountDown->setName("sangvanmoi");
            animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
            animCountDown->addAnimation(0, "sangvanmoi", true);
            animCountDown->setPosition(pnlInvite->getContentSize().width / 2, pnlInvite->getContentSize().height / 2);
            pnlInvite->addChild(animCountDown);
        }
    }
    pnlPlayerAreas[0]->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::unselectedCards, this));
    pnlTableArea       = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlTableArea"));
    pnlGameBar         = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlGameBar"));
    pnlGameBar->setVisible(false);
    btnPlace            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnPlace"));
    btnPlace->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnPlaceClick, this));
    btnPass          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnPass"));
    btnPass->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnPassClick, this));
    btnSort            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSort"));
    btnSort->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnSortClick, this));
    
    pnlTableArea->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::unselectedCards, this));
    pnlUserInfo  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlUserInfo"));
    
    //user infor component
    if (GlobalVariable::m_pUserInfo->getParent()) GlobalVariable::m_pUserInfo->removeFromParent();
    pnlUserInfo->addChild(GlobalVariable::m_pUserInfo);
    GlobalVariable::m_pUserInfo->setPosition(Vec2(0, 0));
    GlobalVariable::m_pUserInfo->fillDataUserInfo();
    //setting panel
    auto pnlSetting  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlSetting"));
    pnlSetting->addChild(GlobalVariable::m_pSettingCom);
    GlobalVariable::m_pSettingCom->setVisiblePanelIAP(false);
    GlobalVariable::m_pSettingCom->setVisibleItems(false, false, true, true, true);
    
    prgTime     = static_cast<LoadingBar*>(Helper::seekWidgetByName(pnlGameBar, "prgTime"));
    imgTimeBg   = static_cast<ImageView*>(Helper::seekWidgetByName(pnlGameBar, "imgTimeBg"));
    pnlTimer    = static_cast<Layout*>(Helper::seekWidgetByName(pnlGameBar, "pnlTimer"));
    imgLight    = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgLight"));
    imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
    imgLight->setPositionY(imgTimeBg->getPositionY() + 2);
    
    setVisibleGameButtons(false);
    
    //btnBonus  = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnBonus"));
    //btnBonus->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnBonusClick, this));
    //btnBonus->setVisible(false);
    btnStart  = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnStart"));
    btnStart->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnStartClick, this));
    btnStart->setVisible(false);
    if(GlobalVariable::m_pUser->m_bHost)
    {
        m_dStartId = GlobalVariable::m_pUser->m_dId;
    }
    
    //enable start button if you are host
    m_hintArrow = Sprite::create("point.png");
    m_pUILayer->addChild(m_hintArrow);
    m_hintArrow->setAnchorPoint(Vec2(0.5f, 0.5f));
    m_hintArrow->setVisible(false);
    m_hintArrow->setScaleY(-1.0f);
    auto actMoveDown = MoveBy::create(0.5f, Vec2(0.0f, -10.0f));
    auto easeDown    = EaseIn::create(actMoveDown, 0.5f);
    auto actMoveUp   = MoveBy::create(0.5f, Vec2(0.0f, 10.0f));
    auto easeUp      = EaseOut::create(actMoveUp, 0.5f);
    auto actMove     = Sequence::create(easeDown, easeUp, DelayTime::create(0.0f), nullptr, nullptr, nullptr);
    m_hintArrow->runAction(RepeatForever::create(actMove));
    
    Layout* pnlRoomInfo    = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlRoomInfo"));
    TextBMFont* bmRoomNO  = static_cast<TextBMFont*>(Helper::seekWidgetByName(pnlRoomInfo, "bmRoomNO"));
    TextBMFont* bmZoneName = static_cast<TextBMFont*>(Helper::seekWidgetByName(pnlRoomInfo, "bmZoneName"));
    bmRoomNO->setString(ccsf("%d", GlobalVariable::m_iCurrentTable));
    bmZoneName->setString(ResourceManager::getInstance()->getTextByName(GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone)->m_sName.c_str()).c_str());
    
    bmBet   = static_cast<TextBMFont*>(Helper::seekWidgetByName(pnlRoomInfo, "bmBet"));
    bmTime   = static_cast<TextBMFont*>(Helper::seekWidgetByName(pnlRoomInfo, "bmTime"));
    
    bmBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetData->m_iCuoc));
    bmTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetData->m_iTime)));
    
    
    m_pnlCountDown = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlCountDown"));
    m_pnlCountDown->setVisible(false);
    
    pnlSuggest = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlSuggest"));
    pnlSuggest->setVisible(false);
    
    m_btnStraight           = static_cast<Button*>(pnlSuggest->getChildByName("btnStraight"));
    m_btnFlush              = static_cast<Button*>(pnlSuggest->getChildByName("btnFlush"));
    m_btnFullhouse          = static_cast<Button*>(pnlSuggest->getChildByName("btnFullHouse"));
    m_btnFourOfAKind        = static_cast<Button*>(pnlSuggest->getChildByName("btnFourAKind"));
    m_btnStraightFlush      = static_cast<Button*>(pnlSuggest->getChildByName("btnStraightFlush"));
    m_btnRoyalStraightFlush = static_cast<Button*>(pnlSuggest->getChildByName("btnRoyalStraightFlush"));
    
    m_btnStraight->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnStraight, this));
    m_btnFlush->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnFlush, this));
    m_btnFullhouse->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnFullhouse, this));
    m_btnFourOfAKind->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnFourOfAKind, this));
    m_btnStraightFlush->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnStraightFlush, this));
    m_btnRoyalStraightFlush->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onTouchBtnRoyalStraightFlush, this));
    
    inactivateHintHands();
    
    m_bmfCountDown = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfCountDown"));
    m_bmfCountDown->setVisible(false);
    pnlInvite   = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlInvite"));
    Text* lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
    if(!(GlobalVariable::m_vPlayersSorted->size() == 1))
    {
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_WAITING_HOST_START));
    }
    else
    {
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITE_MORE));
    }
    lblInvite->runAction(RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 255), FadeTo::create(0.5f, 0), NULL)));
    
    relayout();
    changeLanguage(nullptr);
    //reconnect
    
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onSelectedCard), "select card", nullptr);
    m_attackerHand = nullptr;
    
    CCLOG("Playing: %i | Reconnect: %i | Spectator: %i", GlobalVariable::m_cSetData->m_bPlaying, GlobalVariable::m_cSetData->m_bReconnect, GlobalVariable::m_cSetData->m_bSpectator);
    
    placePlayers();
    if(GlobalVariable::m_cSetData->m_bPlaying)
    {
        pnlInvite->setVisible(false);
        setTurnId(GlobalVariable::m_cSetData->m_dNextTurnId, false);
        btnStart->setVisible(false);
        if(GlobalVariable::m_cSetData->m_bReconnect)
        {
            reconnect();
        }
        if(GlobalVariable::m_cSetData->m_bSpectator)
        {
            showMessage(true, kTEXT_MSG_WATCHING);
            spectator();
        }
    }
    else
    {
        if(GlobalVariable::m_pUser->m_bHost)
        {
            closeAllPopups();
            SettingRoomPopup* pu = new SettingRoomPopup(GlobalVariable::m_pDataMinMaxStake,(int)GlobalVariable::m_cSetData->m_iCuoc, (int)GlobalVariable::m_cSetData->m_iTime, true);
            openPopup(pu);
        }
    }
}

void CapsaBantingScene::spectator()
{
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
        if(GlobalVariable::m_cSetData->m_dNextTurnId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
        {
            m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetData->m_iTimeTurnRemain);
        }
    }
    pnlGameBar->setVisible(false);
    setVisibleGameButtons(false);
}

void CapsaBantingScene::reconnect()
{
    sortCards();
    //display card on table
    m_iHandPosX = pnlTableArea->getContentSize().width / 2 - (4 * 35) / 2;
    m_iHandPosY = pnlTableArea->getPosition().y - 20;
    int count = 0;
    for(int i = 0; i < GlobalVariable::m_cSetData->m_vCardId->size(); i++)
    {
        count++;
        if(GlobalVariable::m_cSetData->m_vCardId->at(i) != -1)
        {
            Card* card = Card::create(GlobalVariable::m_cSetData->m_vCardId->at(i));
            card->setScale(0.6f);
            card->setState(kCardStateKicked);
            pnlTableArea->addChild(card);
            Size deviceSize = Director::getInstance()->getWinSize();
            card->setPosition(Vec2(m_iHandPosX + count * 35, m_iHandPosY));
        }
        else
        {
            count = 0;
            int iRandX = (rand() % 2 == 0) ? -1 : 1;
            int iRandY = (rand() % 2 == 0) ? -1 : 1;
            int iRan   = (rand() % 3);
            m_iHandPosX = iRandX * (30 * iRan) + (pnlTableArea->getContentSize().width / 2 - (4 * 55) / 2);
            m_iHandPosY = iRandY * (30 * iRan) + pnlTableArea->getPosition().y - 20;
        }
    }
    //update player card NO
    
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId != GlobalVariable::m_pUser->m_dId)
        {
            m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
            if(GlobalVariable::m_cSetData->m_dNextTurnId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
            {
                m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetData->m_iTimeTurnRemain);
            }
        }
    }
    showItemsRoom();
}

void CapsaBantingScene::unselectedCards(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    CCLOG("unselectedCards: %d numcards: %lu", m_bFinishGame, GlobalVariable::m_pUser->m_vCard->size());
    if(m_bFinishGame) return;
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        GlobalVariable::m_pUser->m_vCard->at(i)->setState(CardState::kCardStateUngrabbed);
    }
}

void CapsaBantingScene::onCountDownTimer(float dt)
{
    m_iLastCount = round(m_fCountTimeLeft);
    m_fCountTimeLeft = m_fCountTimeLeft - dt;
    m_iCurrentCount = round(m_fCountTimeLeft);
    if(m_fCountTimeLeft < 0)
    {
        m_bmfCountDown->setVisible(false);
        m_pnlCountDown->setVisible(false);
        unschedule(schedule_selector(CapsaBantingScene::onCountDownTimer));
        return;
    }
    if(m_iLastCount != m_iCurrentCount)
    {
        AudioManager::getInstance()->playEffect(kSoundEffectCountDown);
    }
    m_bmfCountDown->setString(ccsf("%1.0f", m_fCountTimeLeft));
}


void CapsaBantingScene::onPrgTimer(float dt)
{
    ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
    TextBMFont* bmCountDown = static_cast<TextBMFont*>(Helper::seekWidgetByName(imgClock, "bmCountDown"));
    m_fCountTimeLeft = m_fCountTimeLeft - dt;
    if(m_fCountTimeLeft < 0)
    {
        imgClock->setVisible(false);
        unschedule(schedule_selector(CapsaBantingScene::onPrgTimer));
        return;
    }
    float percent = (100 * (imgLight->getPositionX() - (imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2))) / imgTimeBg->getContentSize().width;
    bmCountDown->setString(ccsf("%1.0f", m_fCountTimeLeft));
    prgTime->setPercent(percent);
}

void CapsaBantingScene::onResetGame(Ref* obj)
{
    removeChildByName("dead2");
    removeChildByName("passAnim");
    removeChildByName("winloseAnim");
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown->setVisible(false);
    m_bmfCountDown->setString("10");
    m_iCountTurns = 0;
    if(GlobalVariable::m_pUser->m_bPlaying)
    {
        GlobalVariable::m_cSetData->m_bSpectator = false;
    }
    pnlTableArea->removeAllChildren();
    showMessage(true, kTEXT_MSG_AUTO_DEAL_CARD);
    showInvite();
    showItemsRoom();
}

void CapsaBantingScene::onSelectedCard(Ref* obj)
{
    Card* card = (Card*)obj;
    
    // Ignore if attacker hand is not pair or three of a kind
    if (m_attackerHand == nullptr
        || (m_attackerHand->getType() == CardHand::HIGH_CARD && CardHelper::getRank(m_attackerHand->getCardIds().at(0) != Card::RANK_2))
        //||(CardHand::PAIR != m_attackerHand->getType() && CardHand::THREE_OF_A_KIND != m_attackerHand->getType())
        )
    {
        return;
    }
    // Ignore if it's not first selected card
    vector<Card*>* vCard = GlobalVariable::getInstance()->m_pUser->m_vCard;
    int countSelectedCard = 0;
    for (int i = 0, li = vCard->size(); i < li; i++)
    {
        Card* checkingCard = vCard->at(i);
        if (checkingCard->m_iState == CardState::kCardStateSelected) countSelectedCard++;
    }
    if (countSelectedCard > 1) return;
    
    // Found stronger pair/triad to defend
    CardHand* foundHand = CardHelper::getStrongerHand(m_attackerHand, (*GlobalVariable::m_pUser->m_vCardId), vector<int>{card->m_iId});
    if (foundHand != nullptr)
    {
        // Change state of all cards in-used to selected
        vector<int> cardIds = foundHand->getCardIds();
        for (int i = 0; i < vCard->size(); i++)
        {
            Card* targetCard = vCard->at(i);
            int id = targetCard->m_iId;
            // Selected card in found hand
            if (std::find(cardIds.begin(), cardIds.end(), id) == cardIds.end())
            {
                targetCard->setState(CardState::kCardStateUngrabbed);
            }
            
            else
            {
                targetCard->setState(CardState::kCardStateSelected);
            }
        }
    }
}

void CapsaBantingScene::setTurnId(double p_iTurnId, bool p_bFirst)
{
    if(!GlobalVariable::m_cSetData->m_bSpectator)
    {
        pnlGameBar->setVisible(true);
        if(GlobalVariable::m_pUser->m_vCard->size() <= 1)
        {
            
            btnSort->setVisible(false);
        }
        else
        {
            btnSort->setVisible(true);
        }
        setActiveButtons(p_iTurnId, p_bFirst);
    }
    
    if(p_iTurnId == GlobalVariable::m_pUser->m_dId && !GlobalVariable::m_cSetData->m_bSpectator)
    {
        m_hintArrow->setVisible(false);
        activateHintHands();
        pnlTimer->setVisible(true);
        prgTime->setPercent(100.0f);
        pnlSuggest->setVisible(true);
        //time life
        imgLight->stopAllActions();
        imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
        imgLight->setPositionY(imgTimeBg->getPositionY() + 4);
        auto moveto = MoveTo::create(GlobalVariable::m_cSetData->m_iTime, Vec2(imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2, imgTimeBg->getPositionY() + 4));
        imgLight->runAction(moveto);
        ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
        imgClock->setVisible(true);
        m_fCountTimeLeft = GlobalVariable::m_cSetData->m_iTime;
        unschedule(schedule_selector(CapsaBantingScene::onPrgTimer));
        schedule(schedule_selector(CapsaBantingScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);
        //disable other turn
        
        for(int i = 1; i < GlobalVariable::m_vPlayersSorted->size(); i++)
        {
            m_vUserInfoOthers->at(i)->setTurnEffect(false);
        }
    }
    else
    {
        pnlSuggest->setVisible(false);
        m_hintArrow->setVisible(false);
        //other's turn
        pnlTimer->setVisible(false);
        //stop all other turn
        for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
        {
            if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId != p_iTurnId &&
               GlobalVariable::m_vPlayersSorted->at(i)->m_dId != GlobalVariable::m_pUser->m_dId)
            {
                m_vUserInfoOthers->at(i)->setTurnEffect(false);
            }
        }
        //start other turn
        for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
        {
            if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId == p_iTurnId &&
               GlobalVariable::m_vPlayersSorted->at(i)->m_dId != GlobalVariable::m_pUser->m_dId)
            {
                m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetData->m_iTime);
            }
        }
    }
}

void CapsaBantingScene::placePlayers()
{
    for(int i = 0; i < 4; i++)
    {
        if (pnlPlayerAreas[i]->getChildByName("userInfoOther"))
        {
            pnlPlayerAreas[i]->removeChildByName("userInfoOther");
        }
    }
    
    m_vUserInfoOthers->clear();
    if(GlobalVariable::m_vPlayers->size() == 2)
    {
        UserInfoOther* pUserInfoOther0 = new UserInfoOther();
        pUserInfoOther0->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(0));
        pUserInfoOther0->setName("userInfoOther");
        pnlPlayerAreas[0]->addChild(pUserInfoOther0);
        pUserInfoOther0->setPosition(Vec2(pnlPlayerAreas[0]->getContentSize().width / 2 - pUserInfoOther0->getContentSize().width - 100, pnlPlayerAreas[0]->getPositionY()));
        GlobalVariable::m_vPlayersSorted->at(0)->m_iPlayerArea = 0;
        m_vUserInfoOthers->push_back(pUserInfoOther0);
        
        UserInfoOther* pUserInfoOther1 = new UserInfoOther();
        pUserInfoOther1->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(1));
        pUserInfoOther1->setName("userInfoOther");
        pnlPlayerAreas[2]->addChild(pUserInfoOther1);
        GlobalVariable::m_vPlayersSorted->at(1)->m_iPlayerArea = 2;
        m_vUserInfoOthers->push_back(pUserInfoOther1);
    }
    else
    {
        for(int i = 0; i < 4; i++)
        {
            if( i < GlobalVariable::m_vPlayers->size())
            {
                UserInfoOther* pUserInfoOther = new UserInfoOther();
                pUserInfoOther->fillDataUserInfo(GlobalVariable::m_vPlayersSorted->at(i));
                pUserInfoOther->setName("userInfoOther");
                pnlPlayerAreas[i]->addChild(pUserInfoOther);
                if(i == 1)
                {
                    pUserInfoOther->alignRight();
                }
                if(i == 0)
                {
                    pUserInfoOther->setPosition(Vec2(pnlPlayerAreas[0]->getContentSize().width / 2 - pUserInfoOther->getContentSize().width - 100, pnlPlayerAreas[0]->getPositionY()));
                }
                if(i == 3)
                {
                    pUserInfoOther->setPositionX(pUserInfoOther->getPositionX() - 20);
                }
                GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea = i;
                m_vUserInfoOthers->push_back(pUserInfoOther);
            }
        }
    }
    if(GlobalVariable::m_vPlayers->size() == 1
       || (GlobalVariable::m_vPlayersSorted->at(0)->m_dId == GlobalVariable::m_pUser->m_dId && !GlobalVariable::m_cSetData->m_bSpectator))
    {
        pnlPlayerAreas[0]->removeAllChildren();
    }
    
    showInvite();
    showItemsRoom();
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setScale(1.2f);
        m_vUserInfoOthers->at(i)->setPositionX(m_vUserInfoOthers->at(i)->getPositionX() - 10);
    }
}

void CapsaBantingScene::showInvite()
{
    for (int i = 1; i < 4; i++)
    {
        Button* invite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        if(invite)invite->setVisible(false);
        Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
        if(pnlInvite)
        {
            if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
        }
    }
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_cSetData->m_bPlaying)
    {
        for (int i = 1; i < 4; i++)
        {
            Button* invite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
            if(invite)invite->setVisible(true);
            Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
            if(pnlInvite)
            {
                if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
                auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
                animCountDown->setName("sangvanmoi");
                animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
                animCountDown->addAnimation(0, "sangvanmoi", true);
                animCountDown->setPosition(pnlInvite->getContentSize().width / 2, pnlInvite->getContentSize().height / 2);
                pnlInvite->addChild(animCountDown);
            }
        }
        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
        {
            int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
            if(index != 0)
            {
                Button* invite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[index], ccsf("btnInvite%d", index)));
                if(invite)invite->setVisible(false);
                Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(pnlPlayerAreas[index], ccsf("pnlInvite%d", index)));
                if(pnlInvite)
                {
                    if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
                }
            }
        }
    }
}

void CapsaBantingScene::showKickUser(bool bShow)
{
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleKickBtn(bShow);
    }
}

void CapsaBantingScene::showHostUser()
{
    for(int i= 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        for(int j = 0; j < m_vUserInfoOthers->size(); j++)
        {
            if(GlobalVariable::m_vPlayersSorted->at(i)->m_dId == m_vUserInfoOthers->at(j)->m_dUserId)
            {
                m_vUserInfoOthers->at(j)->setVisibleHost(GlobalVariable::m_vPlayersSorted->at(i)->m_bHost);
            }
        }
    }
    
}

void CapsaBantingScene::showItemsRoom()
{
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_cSetData->m_bPlaying)
    {
        showKickUser(true);
    }
    else
    {
        showKickUser(false);
    }
    
    if(GlobalVariable::m_pUser->m_bHost)
    {
        GlobalVariable::m_pUserInfo->visibleHost(true);
    }
    else
    {
        GlobalVariable::m_pUserInfo->visibleHost(false);
    }
    showHostUser();
}

void CapsaBantingScene::setActiveButtons(double iTurnID, bool bFirst)
{
    if(iTurnID == GlobalVariable::m_pUser->m_dId)
    {
        btnPlace->setVisible(true);
        if(bFirst) //your start game or your round
        {
            btnPass->setVisible(false);
        }
        else
        {
            btnPass->setVisible(true);
        }
    }
    else
    {
        btnPlace->setVisible(false);
        btnPass->setVisible(false);
    }
}

//void CapsaBantingScene::onBtnBonusClick(Ref *pSender, Widget::TouchEventType type)
//{
//    if (Widget::TouchEventType::ENDED != type) return;
//    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
//    QuestBonusPopup* popup = new QuestBonusPopup();
//    openPopup(popup);
//}

//start game
void CapsaBantingScene::onBtnStartClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    showMessage(false, "");
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown->setVisible(false);
    m_bmfCountDown->setString("10");
    SFSConnection::getInstance()->startGame();
}

void CapsaBantingScene::onBtnPlaceClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    boost::shared_ptr<ByteArray> bytesCard (new ByteArray());
    int NOCardsFire = 0;
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if(card->m_iState == kCardStateSelected)
        {
            NOCardsFire++;
            bytesCard->WriteShort((short)card->m_iId);
        }
    }
    if(bytesCard->Length() > 0)
    {
        if(NOCardsFire > 1)
        {
            AudioManager::getInstance()->playEffect(kSoundEffectFire);
        }
        else
        {
            AudioManager::getInstance()->playEffect(kSoundEffectDanhGui);
        }
        SFSConnection::getInstance()->fireCard(bytesCard);
    }
    else
    {
        showToast(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_CHOOSE_CARDS_TO_FIRE), 2.0f);
    }
}

void CapsaBantingScene::onBtnSortClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
    sortCards();
}

void CapsaBantingScene::onBtnPassClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->ignoreCard();
}

void CapsaBantingScene::onBtnInviteClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->getWaitingList();
}

void CapsaBantingScene::update(float dt)
{
    BaseScene::update(dt);
}

void CapsaBantingScene::relayout()
{
    Size deviceSize = Director::getInstance()->getWinSize();
    g_iDistance = deviceSize.width / 14;
    ImageView* imgInGameBG = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgTableBg"));
    imgInGameBG->setScaleX(float(deviceSize.width / 960));
    imgInGameBG->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    ImageView* imgLogoGame = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgLogoGame"));
    imgLogoGame->setPositionX(deviceSize.width / 2);
    pnlPlayerAreas[0]->setPositionX((deviceSize.width - pnlPlayerAreas[0]->getContentSize().width) / 2);
    pnlPlayerAreas[1]->setPositionX(deviceSize.width - pnlPlayerAreas[1]->getContentSize().width);
    pnlPlayerAreas[2]->setPositionX((deviceSize.width - pnlPlayerAreas[2]->getContentSize().width) / 2);
    pnlTableArea->setPositionX((deviceSize.width - pnlTableArea->getContentSize().width) / 2);
    btnStart->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 - 100));
    GlobalVariable::m_pSettingCom->setPosition(Vec2(-150 + deviceSize.width - GlobalVariable::m_iGameWidth, 40));
    m_vChatToastPosition.push_back(Vec2(300.0f, deviceSize.height-140.0f));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width - 180.0f, deviceSize.height / 2));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width / 2, deviceSize.height - 140.0f));
    m_vChatToastPosition.push_back(Vec2(250.0f, deviceSize.height / 2));
    pnlInvite->setPositionX(deviceSize.width / 2 - pnlInvite->getContentSize().width / 2);
    m_pnlCountDown->setPosition(Vec2(deviceSize.width / 2 + m_pnlCountDown->getContentSize().width / 2, deviceSize.height / 2 + m_pnlCountDown->getContentSize().height / 2));
    m_bmfCountDown->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 + 5));
    if(deviceSize.width / (float) deviceSize.height < 1.5f)
    {
        btnPass->setPositionX(btnSort->getPositionX() + 140);
        btnPlace->setPositionX(btnPass->getPositionX() + 140);
    }
    m_hintArrow->setPosition(btnPass->getPosition().x, btnPass->getPosition().y + 50.0f);
    m_btnStraight->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
    m_btnFlush->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
    m_btnFullhouse->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
    m_btnFourOfAKind->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
    m_btnStraightFlush->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
    m_btnRoyalStraightFlush->setPositionY(kDISTANCE_Y_BUTTON_SUGGEST);
}

void CapsaBantingScene::addEventlistener()
{
    // Add eventlistener
    //Button* btnBack = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnBack"));
    //btnBack->addTouchEventListener(CC_CALLBACK_2(CapsaBantingScene::onBtnBackClick, this));
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onUserJoinRoom), C_CLIENT_USER_JOIN_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onUserLeftRoom), C_CLIENT_USER_OUT_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onStartedGame), SC_CLIENT_START_GAME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onFireCard), SC_CLIENT_DANH_BAI, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onIgnoreCard), SC_CLIENT_BO_LUOT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onChangeRound), C_CLIENT_CHANGE_ROUND, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onClientGetStart), C_CLIENT_STARTID, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onClientFinishGame), C_CLIENT_FINISH, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onNetworkSendPublishMsr), EVENT_NETWORK_SEND_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onNetworkGetPublishMsr), EVENT_NETWORK_GET_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::showSettingRoom), EVENT_SHOW_SETTING_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onNetworkAutoFire), SC_COMMAND_AUTO, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onKillDead), C_COMMAND_CHATCHEM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onWaitingList), C_COMMAND_GET_LISTWAITING, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onDead2), C_CLIENT_DEAD_2, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onResetGame), C_CLIENT_RESET_GAME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onEndShowResult), C_CLIENT_END_SHOW_RESULT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(CapsaBantingScene::onRoomSettingChanged), S_CLIENT_CHANGE_SETTING_GAME, nullptr);
    
    m_listenerKeyboard->onKeyReleased = CC_CALLBACK_2(CapsaBantingScene::onKeyReleased, this);
    getEventDispatcher()->addEventListenerWithFixedPriority(m_listenerKeyboard, 1);
}

void CapsaBantingScene::onKeyReleased(EventKeyboard::KeyCode keyCode, Event* event)
{
    if (SceneManager::getInstance()->m_iCurrentScene == kSceneInGame1  && keyCode == EventKeyboard::KeyCode::KEY_BACK)
    {
        event->stopPropagation();
        if(m_vPopups != nullptr && m_vPopups->size() > 0)
        {
            closeAllPopups();
            return;
        }
        //showLoading();
        //SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
        GlobalVariable::m_pSettingCom->onBtnLogout(nullptr, Widget::TouchEventType::ENDED);
    }
}

void CapsaBantingScene::onWaitingList(Ref* obj)
{
    vector<CMDWaitingData*>* vWaitingData = (vector<CMDWaitingData*>*)obj;
    InvitationPopup* cfm = new InvitationPopup(vWaitingData);
    openPopup(cfm);
}

void CapsaBantingScene::onKillDead(Ref* obj)
{
    CMDKillData* cmdKillData = (CMDKillData*)obj;
    string strMoney = ccsf("%1.0ld", cmdKillData->m_iMoneyChanged);
    strMoney = TTutil::addDot(strMoney);
    TextBMFont* bmfMoneyLose = TextBMFont::create(ccsf("-%s", strMoney.c_str()), "LosemoneyFont.fnt");
    TextBMFont* bmfMoneyWin  = TextBMFont::create(ccsf("+%s", strMoney.c_str()), "WinmoneyFont.fnt");
    Size deviceSize = Director::getInstance()->getWinSize();
    addChild(bmfMoneyLose);
    addChild(bmfMoneyWin);
    auto faceout  = FadeTo::create(3.0f, 0);
    for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
    {
        if(cmdKillData->m_dKillId == GlobalVariable::m_vPlayersSorted->at(j)->m_dId)
        {
            int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
            
            if(index == 0)
            {
                bmfMoneyWin->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
            }
            else
            {
                bmfMoneyWin->setPosition(Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY()));
            }
            auto movetowin = MoveTo::create(2.0f, Vec2(bmfMoneyWin->getPositionX(), bmfMoneyWin->getPositionY() + 40));
            auto actFinishWin = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, bmfMoneyWin));
            auto seqWin = Sequence::create(movetowin, faceout, actFinishWin, nullptr, nullptr, nullptr);
            bmfMoneyWin->runAction(seqWin);
        }
        
        if(cmdKillData->m_dDeadId == GlobalVariable::m_vPlayersSorted->at(j)->m_dId)
        {
            int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
            auto faceout   = FadeTo::create(3.0f, 0);
            if(index == 0)
            {
                bmfMoneyLose->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
            }
            else
            {
                bmfMoneyLose->setPosition(Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY()));
            }
            auto movetoLose = MoveTo::create(2.0f, Vec2(bmfMoneyLose->getPositionX(), bmfMoneyLose->getPositionY() - 40));
            auto actFinisLose = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, bmfMoneyLose));
            auto seqLose = Sequence::create(movetoLose, faceout, actFinisLose, nullptr, nullptr, nullptr);
            bmfMoneyLose->runAction(seqLose);
        }
    }
    
}

void CapsaBantingScene::onDead2(Ref* obj)
{
    //AudioManager::getInstance()->playEffect(kSoundMusicLose);
    if(getChildByName("dead2")) return;
    auto animDead2 = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimDead2]->getSkeleton()->data);
    animDead2->setName("dead2");
    animDead2->retain();
    animDead2->setMix("smke", "smke", 1.0f);
    animDead2->addAnimation(0, "smke", true);
    animDead2->setPosition(Vec2(250, 450));
    addChild(animDead2);
}

void CapsaBantingScene::onFireCard(Ref* obj)
{
    CMDFireCardData* fireCardData = (CMDFireCardData*)obj;
    Size deviceSize = Director::getInstance()->getWinSize();
    int iNOCards = fireCardData->m_vCardId->size();
    m_iCountTurns++;
    // Save fire card ids
    m_v_iAttackerCardId = *(fireCardData->m_vCardId);
    m_attackerHand = CardHelper::getHand(m_v_iAttackerCardId);
    m_attackerHand->retain();
    int cardHandNO = fireCardData->m_vCardId->size();
    int NOCardFired = m_vFiredCards->size();
    //check is my turn
    if(fireCardData->m_dUserFireId == GlobalVariable::m_pUser->m_dId)
    {
        for(int i = 0; i < fireCardData->m_vCardId->size(); i++)
        {
            for(int j = 0; j < GlobalVariable::m_pUser->m_vCard->size(); j++)
            {
                if(fireCardData->m_vCardId->at(i) == GlobalVariable::m_pUser->m_vCard->at(j)->m_iId)
                {
                    GlobalVariable::m_pUser->m_vCard->erase(GlobalVariable::m_pUser->m_vCard->begin() + j);
                }
            }
        }
        if(!GlobalVariable::m_cSetData->m_bSpectator)
        {
            displayCards();
        }
    }
    
    //find user fire
    int index = 0;
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        if(fireCardData->m_dUserFireId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
        {
            index = i;
        }
    }
    //update Number of cards remain
    if((index != 0) || (index == 0 && GlobalVariable::m_cSetData->m_bSpectator))
    {
        GlobalVariable::m_vPlayersSorted->at(index)->m_iRemainCards -= fireCardData->m_vCardId->size();
        m_vUserInfoOthers->at(index)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(index)->m_iRemainCards);
    };
    //display card on table
    int aPos[5][2] = {
        {kDISTANCE_X_CARD_ON_TABLE, kDISTANCE_Y_CARD_ON_TABLE},
        {kDISTANCE_X_CARD_ON_TABLE, -kDISTANCE_Y_CARD_ON_TABLE},
        {-kDISTANCE_X_CARD_ON_TABLE, -kDISTANCE_Y_CARD_ON_TABLE - 20},
        {-kDISTANCE_X_CARD_ON_TABLE, kDISTANCE_Y_CARD_ON_TABLE},
        {-kDISTANCE_X_CARD_ON_TABLE, kDISTANCE_Y_CARD_ON_TABLE}
    };
    
    if(m_iCountTurns == 1)
    {
        m_iHandPosX = pnlTableArea->getContentSize().width / 2 - (iNOCards - 1) * kDISTANCE_X_CARD_ON_HAND_TABLE / 2;
        m_iHandPosY = pnlTableArea->getContentSize().height / 2 + 50;
    }
    else
    {
        m_iHandPosX = m_iHandPosX + aPos[m_iCountTurns - 1][0];
        m_iHandPosY = m_iHandPosY + aPos[m_iCountTurns - 1][1];
    }
    
    if(m_iCountTurns == 4)
    {
        m_iCountTurns = 0;
    }
    //keep 4 turn on table
    if((NOCardFired / cardHandNO) > 4)
    {
        for(int j = 0; j < (NOCardFired - 4 * cardHandNO); j++)
        {
            m_vFiredCards->at(j)->removeFromParent();
            m_vFiredCards->erase(m_vFiredCards->begin() + j);
        }
    }
    
    //shadow old turn
//    for(int i = 0; i < m_vFiredCards->size(); i++)
//    {
//        if(!GlobalVariable::m_pUser->m_dId == m_dStartId)
//        {
//            m_vFiredCards->at(i)->runAction(Sequence::create(
//                                                             DelayTime::create(0.2f),
//                                                             CallFunc::create(CC_CALLBACK_0(Node::setColor, m_vFiredCards->at(i), Color3B(100, 100, 100))),
//                                                             nullptr));
//        }
//    }
    
    //move card
    
    float pi = 3.145;
    for(int i = 0; i < fireCardData->m_vCardId->size(); i++)
    {
        Card* card = Card::create(fireCardData->m_vCardId->at(i));
        card->setScale(0.6f);
        card->setState(kCardStateKicked);
        pnlTableArea->addChild(card);
        m_vFiredCards->push_back(card);
        if(GlobalVariable::m_vPlayersSorted->at(index)->m_iPlayerArea != 0)
        {
            card->setOpacity(0);
            card->setPosition(pnlPlayerAreas[GlobalVariable::m_vPlayersSorted->at(index)->m_iPlayerArea]->getPosition());
        }
        float rotation = 0.0f;
        Vec2 placePos = {};
        if (fireCardData->m_vCardId->size() == 1)
        {
            placePos = Vec2(m_iHandPosX + i * kDISTANCE_X_CARD_ON_HAND_TABLE, m_iHandPosY);
            rotation = 0.0f;
        }
        else if (fireCardData->m_vCardId->size() % 2 == 0)
        {
            placePos = Vec2(m_iHandPosX + i * kDISTANCE_X_CARD_ON_HAND_TABLE, m_iHandPosY);
            rotation = 12 * i - (6.0f * fireCardData->m_vCardId->size()* 0.5);
        }
        else
        {
            int factor = fireCardData->m_vCardId->size() -1;
            placePos = Vec2(m_iHandPosX + i * kDISTANCE_X_CARD_ON_HAND_TABLE, m_iHandPosY + 12 * sin(pi*i / factor));
            rotation = -(12.0f * floor(fireCardData->m_vCardId->size() / 2)) + 12.0f * i;
        }
        auto placeAct = Spawn::create(
                                      ScaleTo::create(0.2f, 0.6f)
                                      , MoveTo::create(0.2f, placePos)
                                      , FadeTo::create(0.2f, 255)
                                      , RotateTo::create(0.2f, rotation)
                                      , nullptr);
        card->runAction(Sequence::create(DelayTime::create(0.1f * i), placeAct, nullptr));
        
    }
    
    setTurnId(fireCardData->m_dNextTurnId, false);
}

void CapsaBantingScene::onStartedGame(Ref* obj)
{
    unschedule(schedule_selector(CapsaBantingScene::onCountDownTimer));
    showMessage(false, "");
    m_vFiredCards->clear();
    m_iCountTurns = 0;
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown->setVisible(false);
    m_bmfCountDown->setString("10");
    pnlGameBar->setVisible(true);
    GlobalVariable::m_cSetData->m_bPlaying = true;
    showInvite();
    showItemsRoom();
    CMDIgnoreCardData* cmdIgnoreCardData = (CMDIgnoreCardData*)obj;
    double iTurnId = cmdIgnoreCardData->m_dNextTurnId;
    btnStart->setVisible(false);
    //reset NO cards to 13
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards = 13;
    }
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleNOCard(false);
    }
    m_attackerHand = nullptr;
    dealCards();
    setTurnId(iTurnId, true);
}

void CapsaBantingScene::onClientGetStart(Ref* obj)
{
    if(getChildByName("dead2"))removeChildByName("dead2");
    CCLOG("mdStartid truoc %f",m_dStartId);
    CMDUserData* userData = (CMDUserData*)obj;
    m_dStartId = userData->m_dUID;
    CCLOG("mdStartid sau %f",m_dStartId);
    
    m_pnlCountDown->setVisible(false);
    m_bmfCountDown->setVisible(false);
    m_bmfCountDown->setString("10");
    
    if(m_bCanJoinRoom)
    {
        pnlTableArea->removeAllChildren();
        m_bCanJoinRoom = false;
        joinRoom();
    }
    if(m_bCanLeftRoom)
    {
        pnlTableArea->removeAllChildren();
        m_bCanLeftRoom = false;
        leftRoom(leftTTID);
    }
    
    //enable start button
    if(GlobalVariable::m_pUser->m_dId == m_dStartId && GlobalVariable::m_cSetData->m_bPlaying == false)
    {
        if(GlobalVariable::m_vPlayersSorted->size() > 1)
        {
            btnStart->setVisible(true);
        }
    }
    
    if(GlobalVariable::m_vPlayers->size() == 1)
    {
        btnStart->setVisible(false);
    }
}

void CapsaBantingScene::setVisibleGameButtons(bool bVisible)
{
    btnPlace->setVisible(bVisible);
    btnSort->setVisible(bVisible);
    btnPass->setVisible(bVisible);
    pnlTimer->setVisible(bVisible);
}

void CapsaBantingScene::onIgnoreCard(Ref* obj)
{
    Size deviceSize = Director::getInstance()->getWinSize();
    CMDIgnoreCardData* cmdIgnoreCardData = (CMDIgnoreCardData*)obj;
    for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
    {
        if(cmdIgnoreCardData->m_dIgnoreTurnId == GlobalVariable::m_vPlayersSorted->at(j)->m_dId)
        {
            int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
            Sprite* sprite = Sprite::create();
            sprite->setName("passAnim");
            addChild(sprite);
            auto animPass = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLose]->getSkeleton()->data);
            if(GlobalVariable::m_iCurrentLanguage == 0)
            {
                animPass->setMix("lewat", "lewat", 1.0f);
                animPass->addAnimation(0, "lewat", false);
            }
            else
            {
                animPass->setMix("pass", "pass", 1.0f);
                animPass->addAnimation(0, "pass", false);
            }
            sprite->addChild(animPass);
            
            if(index == 0)
            {
                sprite->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 - 200));
            }
            else
            {
                sprite->setPosition(Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY()));
            }
        }
    }
    setTurnId(cmdIgnoreCardData->m_dNextTurnId, false);
}

void CapsaBantingScene::onChangeRound(Ref* obj)
{
    clearCards();
    m_iCountTurns = 0;
    m_iHandCount = 0;
    m_vFiredCards->clear();
    m_v_iAttackerCardId = {};
    if (m_attackerHand != nullptr)
    {
        m_attackerHand = nullptr;
    }
    CMDUserData* userData = (CMDUserData*) obj;
    setTurnId(userData->m_dUID, true);
}

void CapsaBantingScene::onNetworkAutoFire(Ref* obj)
{
    bool bAuto = (bool)obj;
}

void CapsaBantingScene::displayCards()
{
    CCLOG("displayCards %lu", GlobalVariable::m_pUser->m_vCardId->size());
    //display card
    long NOCards = GlobalVariable::m_pUser->m_vCardId->size();
    int x = (pnlPlayerAreas[0]->getContentSize().width - (NOCards - 1) * g_iDistance) / 2;
    GlobalVariable::m_pUser->m_vCard->clear();
    if(GlobalVariable::m_pUser->m_bPlaying == true)
    {
        pnlPlayerAreas[0]->removeAllChildren();
        for(int i = 0; i < NOCards; i++)
        {
            Card* card = Card::create(GlobalVariable::m_pUser->m_vCardId->at(i));
            card->setScale(1.0f);
            GlobalVariable::m_pUser->m_vCard->push_back(card);
            pnlPlayerAreas[0]->addChild(card);
            card->m_posOrigin = Vec2(x + i * g_iDistance, kDISTANCE_Y_ALL_CARDS);
            card->setPosition(Vec2(x + i * g_iDistance, kDISTANCE_Y_ALL_CARDS));
        }
    }
}

void CapsaBantingScene::dealCards()
{
    Size deviceSize = Director::getInstance()->getWinSize();
    Vector<FiniteTimeAction*> actions;
    Card* card = Card::create(0);
    card->setScale(0.4f);
    card->setPosition(pnlTableArea->getContentSize().width / 2, pnlTableArea->getContentSize().height / 2);
    pnlTableArea->addChild(card);
    int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistance) / 2;
    Vec2 pos = card->getPosition();
    GlobalVariable::m_pUser->m_vCard->clear();
    for(int i = 0; i < 13; i++)
    {
        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
        {
            MoveTo* moveto;
            //is Me
            if(GlobalVariable::m_vPlayersSorted->at(j)->m_dId == GlobalVariable::m_pUser->m_dId)
            {
                auto act4 = CallFunc::create(CC_CALLBACK_0(CapsaBantingScene::animFinishMe, this, card, i));
                moveto = MoveTo::create(0.05f, Vec2(x + i * g_iDistance, -100));
                actions.pushBack(act4);
            }
            else
            {
                auto act5 = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::animFinishOther, this, card, j, i));
                moveto = MoveTo::create(0.05f, pnlPlayerAreas[GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea]->getPosition());
                actions.pushBack(act5);
            }
            auto moveback = MoveTo::create(0.0f, pos);
            actions.pushBack(moveto);
            actions.pushBack(moveback);
        }
    }
    auto fadeout = FadeOut::create(0.0f);
    auto act6 = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, card));
    actions.pushBack(fadeout);
    actions.pushBack(act6);
    auto seq2 = Sequence::create(actions);
    card->runAction(seq2);
}

void CapsaBantingScene::finishAction(Node* node)
{
    node->removeFromParent();
}

void CapsaBantingScene::finishWinAction()
{
    if(GlobalVariable::m_pUser->m_bPlaying)
    {
        GlobalVariable::m_cSetData->m_bSpectator = false;
        pnlPlayerAreas[0]->removeAllChildren();
    }
    GlobalVariable::m_cSetData->m_bPlaying = false;
    if(GlobalVariable::m_bRequestLogout)
    {
        GlobalVariable::m_bRequestLogout = false;
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
    
    auto deviceSize = Director::getInstance()->getWinSize();
    m_pnlCountDown->setVisible(true);
    m_bmfCountDown->setVisible(true);
    m_bmfCountDown->setString("10");
    showMessage(true, kTEXT_MSG_AUTO_DEAL_CARD);
    if(m_pnlCountDown->getChildByName("sangvanmoi"))m_pnlCountDown->removeChildByName("sangvanmoi");
    auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
    animCountDown->setName("sangvanmoi");
    animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
    animCountDown->addAnimation(0, "sangvanmoi", true);
    m_pnlCountDown->addChild(animCountDown);
    m_fCountTimeLeft = 10.000f;
    unschedule(schedule_selector(CapsaBantingScene::onPrgTimer));
    unschedule(schedule_selector(CapsaBantingScene::onCountDownTimer));
    schedule(schedule_selector(CapsaBantingScene::onCountDownTimer), 1.0f, kRepeatForever, 0.0f);
    
    clearCards();
    btnSort->setVisible(false);
    showInvite();
    showItemsRoom();
    if(m_bCanJoinRoom)
    {
        m_bCanJoinRoom = false;
        joinRoom();
    }
    if(m_bCanLeftRoom)
    {
        m_bCanLeftRoom = false;
        leftRoom(leftTTID);
    }
    
    //enable start button
//    if(GlobalVariable::m_pUser->m_dId == m_dStartId && GlobalVariable::m_cSetData->m_bPlaying == false)
//    {
//        if(GlobalVariable::m_vPlayersSorted->size() > 1)
//        {
//            DelayTime* delay = DelayTime::create(5.0f);
//            CallFunc* func= CallFunc::create(CC_CALLBACK_0(CapsaBantingScene::showStartWithDelay, this));
//            runAction(Sequence::create(delay, func, NULL));
//        }
//    }
    
    if(GlobalVariable::m_vPlayers->size() == 1)
    {
        btnStart->setVisible(false);
    }
}

void CapsaBantingScene::showStartWithDelay()
{
//    btnStart->setVisible(true);
}

void CapsaBantingScene::animFinishOther(Node* node, int indexUser, int indexCard)
{
    m_vUserInfoOthers->at(indexUser)->updateNOCardsRemain(indexCard + 1);
}

void CapsaBantingScene::animFinishMe(Node* node, int indexCard)
{
    Size deviceSize = Director::getInstance()->getWinSize();
    int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistance) / 2;
    Card* card = Card::create(GlobalVariable::m_pUser->m_vCardId->at(indexCard));
    card->setScale(1.0f);
    GlobalVariable::m_pUser->m_vCard->push_back(card);
    pnlPlayerAreas[0]->addChild(card);
    card->setOpacity(0.0f);
    card->setPosition(Vec2(x + indexCard * g_iDistance, kDISTANCE_Y_ALL_CARDS));
    card->m_posOrigin = Vec2(x + indexCard * g_iDistance, kDISTANCE_Y_ALL_CARDS);
    Action* fadeto = FadeTo::create(0.2f, 255);
    card->runAction(fadeto);
    btnSort->setVisible(true);
}

void CapsaBantingScene::clearCards()
{
    pnlTableArea->removeAllChildren();
}

void CapsaBantingScene::onClientError(Ref* obj)
{
    CMDErrorData* cmdErrorData = (CMDErrorData*)obj;
    CCLOG("extensionResponseError %s", cmdErrorData->m_sMessage.c_str());
    
    string str = cmdErrorData->m_sMessage;
    
    string key = str.substr(0, str.find_first_of(","));
    str.erase(0, key.size() + 1);
    
    vector<string>* params = new vector<string>();
    if (str.size() > 0)
    {
        while (str.find_first_of(",") != -1)
        {
            string a = str.substr(0, str.find_first_of(","));
            params->push_back(a);
            str.erase(0, a.size() + 1);
        }
    }
    string alertString = GlobalVariable::msgConst->getMsg(key.c_str(), params);
    showToast(alertString, 2.0f);
}

bool sortFuncIncrease(const int &a, const int &b)
{
    return (a < b);
}

bool sortFuncDecrease(const int &a, const int &b)
{
    return (a > b);
}

void CapsaBantingScene::sortCards()
{
    if(m_iTypeSort == 0)
    {
        std::sort(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), sortFuncIncrease);
        m_iTypeSort = 1;
    }
    else if (m_iTypeSort == 1)
    {
        CardHelper::sortBySuit(*(GlobalVariable::m_pUser->m_vCardId));
        m_iTypeSort = 2;
    }
    else if (m_iTypeSort == 2)
    {
        CardHelper::sortByStraight(*(GlobalVariable::m_pUser->m_vCardId));
        m_iTypeSort = 0;
    }
    displayCards();
}

void CapsaBantingScene::onUserJoinRoom(Ref* obj)
{
    AudioManager::getInstance()->playEffect(kSoundEffectJoinTable);
    m_bCanJoinRoom = true;
    if(!GlobalVariable::m_cSetData->m_bPlaying)
    {
        m_bCanJoinRoom = false;
        joinRoom();
    }
}

void CapsaBantingScene::joinRoom()
{
    placePlayers();
    if(GlobalVariable::m_pUser->m_dId == m_dStartId)
    {
        btnStart->setVisible(true);
    }
    
    showInvite();
    showItemsRoom();
}

void CapsaBantingScene::onUserLeftRoom(Ref* obj)
{
    AudioManager::getInstance()->playEffect(kSoundEffectLeftTable);
    CMDUserData* userData = (CMDUserData*)obj;
    m_bCanLeftRoom = true;
    leftTTID = userData->m_dUID;
    if(!GlobalVariable::m_cSetData->m_bPlaying)
    {
        m_bCanLeftRoom = false;
        leftRoom(leftTTID);
    }
}

void CapsaBantingScene::leftRoom(double iTTID)
{
    //if you goto lobby
    if(GlobalVariable::m_pUser->m_dId == iTTID)
    {
        showLoading();
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
    else
    {
        if(GlobalVariable::m_vPlayers->size() == 1)
        {
            GlobalVariable::m_cSetData->m_bSpectator = false;
        }
        //else resort user
        placePlayers();
    }
    if(GlobalVariable::m_vPlayersSorted->size() ==1)
    {
        GlobalVariable::m_cSetData->m_bPlaying = false;
    }
    showInvite();
    showItemsRoom();
}

void CapsaBantingScene::finishGame(vector<CMDFinishData*>* vCMDFinishData)
{
    auto deviceSize = Director::getInstance()->getWinSize();
    pnlTableArea->removeAllChildren();
    for(int i = 0; i < vCMDFinishData->size(); i++)
    {
        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
        {
            if(vCMDFinishData->at(i)->m_dId == GlobalVariable::m_vPlayersSorted->at(j)->m_dId)
            {
                Sprite* sprite = Sprite::create();
                sprite->setName("winloseAnim");
                addChild(sprite);
                Sequence* seq;
                
                int index = GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea;
                if(index == 0)
                {
                }
                else
                {
                    //show card remain
                    for(int k = 0; k < vCMDFinishData->at(i)->m_vCardsIdRemain->size(); k++)
                    {
                        Card* card = Card::create(vCMDFinishData->at(i)->m_vCardsIdRemain->at(k));
                        card->setScale(0.4f);
                        card->setState(kCardStateKicked);
                        pnlTableArea->addChild(card);
                        int x = 0;
                        int y = 0;
                        if(index == 1)
                        {
                            x = pnlTableArea->getContentSize().width - pnlPlayerAreas[3]->getContentSize().width / 2;
                            y = pnlTableArea->getContentSize().height - 50;
                            card->setPosition(Vec2(x, y - k * 30));
                        }
                        if(index == 2)
                        {
                            x = (pnlTableArea->getContentSize().width - (vCMDFinishData->at(i)->m_vCardsIdRemain->size() * 30) - 30) / 2;
                            y = pnlTableArea->getPosition().y + 50;
                            card->setPosition(Vec2(x + k * 30, y));
                        }
                        if(index == 3)
                        {
                            x = pnlPlayerAreas[3]->getContentSize().width / 2;
                            y = pnlTableArea->getContentSize().height - 50;
                            card->setPosition(Vec2(x, y - k * 30));
                        }
                    }
                    //end show card remain
                }
                TextBMFont* txtBMMoney;
                string strMoney = ccsf("%1.0f", abs(vCMDFinishData->at(i)->m_dChangeMoney));
                strMoney = TTutil::addDot(strMoney);
                if(vCMDFinishData->at(i)->m_dChangeMoney < 0)
                {
                    txtBMMoney = TextBMFont::create(ccsf("-%s", strMoney.c_str()), "LosemoneyFont.fnt");
                }
                else if(vCMDFinishData->at(i)->m_dChangeMoney > 0)
                {
                    txtBMMoney = TextBMFont::create(ccsf("+%s", strMoney.c_str()), "WinmoneyFont.fnt");
                }
                else
                {
                    txtBMMoney = TextBMFont::create("+0", "WinmoneyFont.fnt");
                }
                txtBMMoney->setName("TextEffect");
                
                if(vCMDFinishData->at(i)->m_bwin)
                {
                    if(vCMDFinishData->at(i)->m_dId == GlobalVariable::m_pUser->m_dId)
                    {
                        AudioManager::getInstance()->playBackgroundMusic(kSoundMusicWin);
                    }
                    else
                    {
                        AudioManager::getInstance()->playBackgroundMusic(kSoundMusicLose);
                    }
                    //toi trang
                    if(vCMDFinishData->at(i)->m_sRank == FN_RONG
                       || vCMDFinishData->at(i)->m_sRank == FN_DONG_HOA
                       || vCMDFinishData->at(i)->m_sRank == FN_RONG_DONG_HOA)
                    {
                        displayCards();
                        TextBMFont* bmfType;
                        if(vCMDFinishData->at(i)->m_sRank == FN_RONG)
                        {
                            bmfType = TextBMFont::create("DRAGON STRAIGHT", "bf9-export.fnt");
                        }
                        else if(vCMDFinishData->at(i)->m_sRank == FN_DONG_HOA)
                        {
                            bmfType = TextBMFont::create("SAME SUIT", "bf9-export.fnt");
                        }
                        else if(vCMDFinishData->at(i)->m_sRank == FN_RONG_DONG_HOA)
                        {
                            bmfType = TextBMFont::create("DRAGON STRAIGHT FLUSH", "bf9-export.fnt");
                        }
                        addChild(bmfType);
                        bmfType->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
                        auto actScale = ScaleTo::create(0.5f, 2.0f);
                        auto actDelay = DelayTime::create(2.0f);
                        auto actFinish = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, bmfType));
                        seq = Sequence::create(actScale, actDelay, actFinish, NULL);
                        bmfType->runAction(seq);
                    }
                    //end toi trang
                    
                    //win effect
                    auto animWin = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimWin]->getSkeleton()->data);
                    if(GlobalVariable::m_iCurrentLanguage == 0)
                    {
                        animWin->setMix("menang", "menang", 1.0f);
                        animWin->addAnimation(0, "menang", false);
                    }
                    else
                    {
                        animWin->setMix("win", "win", 1.0f);
                        animWin->addAnimation(0, "win", false);
                    }
                    sprite->addChild(animWin);
                }
                else
                {
                    auto animLose = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimLose]->getSkeleton()->data);
                    if(GlobalVariable::m_iCurrentLanguage == 0)
                    {
                        animLose->setMix("kalah", "kalah", 1.0f);
                        animLose->addAnimation(0, "kalah", false);
                    }
                    else
                    {
                        animLose->setMix("lose", "lose", 1.0f);
                        animLose->addAnimation(0, "lose", false);
                    }
                    sprite->addChild(animLose);
                }
                addChild(txtBMMoney);
                
                
                if(index == 0)//you win
                {
                    sprite->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 - 200));
                    txtBMMoney->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2  - 200));
                    auto faceout = FadeTo::create(3.0f, 0);
                    auto moveto = MoveTo::create(1.0f, Vec2(deviceSize.width / 2, deviceSize.height / 2));
                    auto actFinish = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, txtBMMoney));
                    auto seq = Sequence::create(moveto, faceout, actFinish, nullptr, nullptr, nullptr);
                    
                    txtBMMoney->runAction(seq);
                }
                else
                {
                    sprite->setPosition(Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY()));
                    txtBMMoney->setPosition(Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY()));
                    auto moveto = MoveTo::create(3.0f, Vec2(pnlPlayerAreas[index]->getPositionX() + pnlPlayerAreas[index]->getContentSize().width / 2, pnlPlayerAreas[index]->getPositionY() + 100));
                    auto faceout = FadeTo::create(1.0f, 0);
                    auto actFinish = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishAction, this, txtBMMoney));
                    auto seq = Sequence::create(moveto, faceout, actFinish, nullptr, nullptr, nullptr);
                    txtBMMoney->runAction(seq);
                }
            }
        }
    }
}

void CapsaBantingScene::onEndShowResult(Ref* obj)
{
    finishWinAction();
}

void CapsaBantingScene::onClientFinishGame(Ref* obj)
{
    m_bFinishGame = true;
    m_hintArrow->setVisible(false);
    pnlGameBar->setVisible(false);
    pnlSuggest->setVisible(false);
    m_vFiredCards->clear();
    for(int i = 1; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setTurnEffect(false);
    }
    
    setVisibleGameButtons(false);
    
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleNOCard(false);
    }
    
    vector<CMDFinishData*>* vCMDFinishData = (vector<CMDFinishData*>*)obj;
    auto delayAct = DelayTime::create(3.0f);
    auto actFinishGame = CallFunc::create( CC_CALLBACK_0(CapsaBantingScene::finishGame, this, vCMDFinishData));
    auto seq = Sequence::create(delayAct, actFinishGame, NULL);
    runAction(seq);
}

void CapsaBantingScene::changeLanguage(Ref* obj)
{
    TextBMFont* bmfStart = static_cast<TextBMFont*>(btnStart->getChildByName("bmfBtnStart"));
    bmfStart->setString(ResourceManager::getInstance()->getTextByName(kTEXT_START));
    
    TextBMFont* bmfBtnSort     = static_cast<TextBMFont*>(btnSort->getChildByName("bmfBtnSort"));
    TextBMFont* bmfBtnSort_0   = static_cast<TextBMFont*>(btnSort->getChildByName("bmfBtnSort_0"));
    TextBMFont* bmfBtnPass     = static_cast<TextBMFont*>(btnPass->getChildByName("bmfBtnPass"));
    TextBMFont* bmfBtnPlace     = static_cast<TextBMFont*>(btnPlace->getChildByName("bmfBtnPlace"));
    
    if(GlobalVariable::m_iCurrentLanguage == 0)//Indo
    {
        bmfBtnSort->setPositionY(62);
        bmfBtnSort->setString("Atur");
        bmfBtnSort_0->setVisible(true);
        bmfBtnSort_0->setString("kartu");
        
        bmfBtnPass->setString("Lewat");
        
        bmfBtnPlace->setString("Main");
    }
    else
    {
        bmfBtnSort->setPositionY(48);
        bmfBtnSort->setString("Sort");
        bmfBtnSort_0->setVisible(false);
        
        bmfBtnPass->setString("Pass");
        
        bmfBtnPlace->setString("Place");
    }
}

void CapsaBantingScene::onRoomSettingChanged(Ref* obj)
{
    CMDSettingInGame* cmdSettingInGame = (CMDSettingInGame*)obj;
    showToast(ccsf("Time: %lds Stake: %ld", cmdSettingInGame->times, cmdSettingInGame->stake), 2.0f);
    GlobalVariable::m_cSetData->m_iCuoc = cmdSettingInGame->stake;
    GlobalVariable::m_cSetData->m_iTime = cmdSettingInGame->times;
    bmBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetData->m_iCuoc));
    bmTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetData->m_iTime)));
}

void CapsaBantingScene::showSettingRoom(Ref* obj)
{
    closeAllPopups();
    SettingRoomPopup* pu = new SettingRoomPopup(GlobalVariable::m_pDataMinMaxStake, GlobalVariable::m_cSetData->m_iCuoc, GlobalVariable::m_cSetData->m_iTime);
    openPopup(pu);
}

void CapsaBantingScene::showMessage(bool bVisible, const char* messageid)
{
    pnlInvite->setVisible(bVisible);
    if(bVisible)
    {
        Text* lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(messageid));
    }
}

/* end pragma init Scene */

//*******************************
// start pragma exit Scene
//*******************************
void CapsaBantingScene::onExit()
{
    BaseScene::onExit();
    NotificationCenter::getInstance()->removeAllObservers(this);
    if (GlobalVariable::m_pUserInfo->getParent() && GlobalVariable::m_pUserInfo->getParent() == m_pUILayer) GlobalVariable::m_pUserInfo->removeFromParent();
    if (GlobalVariable::m_pAdBar->getParent() && GlobalVariable::m_pAdBar->getParent() == m_pUILayer) GlobalVariable::m_pAdBar->removeFromParent();
    if (GlobalVariable::m_pSettingCom->getParent() && GlobalVariable::m_pSettingCom->getParent() == m_pUILayer) GlobalVariable::m_pSettingCom->removeFromParent();
    unschedule(schedule_selector(CapsaBantingScene::onCountDownTimer));
    unschedule(schedule_selector(CapsaBantingScene::update));
    unschedule(schedule_selector(CapsaBantingScene::onPrgTimer));
    removeAllChildrenWithCleanup(true);
}

/* end pragma exit Scene */

CapsaBantingScene::CapsaBantingScene()
{
    m_vChatToastPosition = vector<Vec2>();
    m_vUserInfoOthers = new vector<UserInfoOther*>();
    vector<int> m_v_iAttackerCardId = {};
    vector<int> m_v_iDefenderCardId = {};
    vector<CardHand*> m_vStraightHand = {};
    vector<CardHand*> m_vFlushHand = {};
    vector<CardHand*> m_vFullhouseHand = {};
    vector<CardHand*> m_vFourOfAKindHand = {};
    vector<CardHand*> m_vStraightFlushHand = {};
    m_iIndexStraightHand = -1;
    m_iIndexFlushHand = -1;
    m_iIndexFullhouseHand = -1;
    m_iIndexFourOfAKindHand = -1;
    m_iIndexStraightFlushHand = -1;
    m_iIndexRoyalStraightFlushHand = -1;
    
    m_dStartId = 0;
    m_bFinishGame = false;
    m_iHandPosX = 0;
    m_iHandPosY = 0;
    m_iHandCount = 0;
    
    m_vFiredCards = new vector<Card*>();
    m_iCountDown = 0;
    m_iTypeSort = 0;
    m_sprDeadEffect = Sprite::create();
    m_iLastCount = 0;
    m_iCurrentCount = 0;
    m_bCanJoinRoom = false;
    m_bCanLeftRoom = false;
    m_iCountTurns = 0;
}

CapsaBantingScene::~CapsaBantingScene()
{
    m_vUserInfoOthers->clear();
    CC_SAFE_DELETE(m_vUserInfoOthers);
    deleteHintHands();
}

void CapsaBantingScene::onNetworkSendPublishMsr(Ref* obj)
{
    // Add chat toast as main player
    String* msr = (String*)obj;
    ChatToast* toast = ChatToast::create(msr->getCString());
    Size deviceSize = Director::getInstance()->getWinSize();
    //Vec2 position = m_vChatToastPosition.at(0);
    toast->setPosition(Vec2(300.0f, deviceSize.height - 140.0f));
    m_pUILayer->addChild(toast);
}

void CapsaBantingScene::onNetworkGetPublishMsr(Ref* obj)
{
    // Add chat toast as other players
    int noPlayer = GlobalVariable::m_vPlayersSorted->size();
    MsrObject* msrObj = static_cast<MsrObject*>(obj);
    // Find player who sent msr
    int i;
    int index = -1;
    for (i = 1; i < noPlayer; i++)
    {
        int checkId = GlobalVariable::m_vPlayersSorted->at(i)->m_iSfsId;
        if (checkId == msrObj->m_dId)
        {
            index = GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea;
            auto layout   = ResourceManager::getInstance()->m_loChatPopup;
            auto listview = static_cast<ui::ListView*>(Helper::seekWidgetByName(layout, "lvMessage"));
            Layout* item = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ChatItem.json"));
            Text* lbUsername = static_cast<Text*>(Helper::seekWidgetByName(item, "lbName"));
            lbUsername->setString(GlobalVariable::m_vPlayersSorted->at(i)->m_sName);
            Text* lbMessage  = static_cast<Text*>(Helper::seekWidgetByName(item, "lbMessage"));
            lbMessage->setString(msrObj->m_sUsername);
            listview->pushBackCustomItem(item);
            break;
        }
    }
    if (index == -1) return;
    // Add chat toast
    ChatToast* toast = ChatToast::create(msrObj->m_sUsername);
    Vec2 position = m_vChatToastPosition.at(index);
    toast->setPosition(position);
    m_pUILayer->addChild(toast);
}

/*************************************************************/
/* @author longnh                                              */
/* Sort by hand in deck                                      */
/*************************************************************/

void CapsaBantingScene::activateHintHands()
{
    bool bHasAttackerHand = m_attackerHand != nullptr ? true : false;
    bool bComplexHand = m_v_iAttackerCardId.size() == 5 ? true : false;
    bool bFire2 = false;
    
    // Free memory from old hands before finding new ones
    deleteHintHands();
    
    // Stupid logic: call setTurnID after finishing game
    if (GlobalVariable::m_pUser->m_vCardId->size() == 0 && m_v_iAttackerCardId.size() == 0) return;
    
    // Condition player fire 2
    if (bHasAttackerHand)
    {
        bFire2 = (m_v_iAttackerCardId.size() == 1 && CardHelper::getRank(m_v_iAttackerCardId.at(0)) == Card::RANK_2) ? true : false;
    }
    
    // FOUND HAND TO DEFEND PHASE
    // Condition player fire 2
    vector<int>* vCardIDs= GlobalVariable::m_pUser->m_vCardId;
    vector<int> vUsedCard = {};
    for (int i = 0; i < vCardIDs->size(); i++) {
        vUsedCard.push_back(vCardIDs->at(i));
    }
    if (bFire2)
    {
        m_vStraightHand      = {};
        m_vFlushHand         = {};
        m_vFullhouseHand     = {};
        m_vFourOfAKindHand   = CardHelper::getAllFourOfAKindHands(vUsedCard, m_attackerHand);
        CCLOG("getAllStraightFlushHands 1");
        m_vStraightFlushHand = CardHelper::getAllStraightFlushHands(vUsedCard, m_attackerHand);
        m_vRoyalStraightFlushHand = CardHelper::getAllRoyalStraightFlushHands(vUsedCard, m_attackerHand);
    }
    // Player fire complex hand
    else if (!bHasAttackerHand || (bHasAttackerHand && bComplexHand))
    {
        m_vStraightHand      = CardHelper::getAllStraightHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
        m_vFlushHand         = CardHelper::getAllFlushHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
        m_vFullhouseHand     = CardHelper::getAllFullhouseHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
        m_vFourOfAKindHand   = CardHelper::getAllFourOfAKindHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
        m_vStraightFlushHand = CardHelper::getAllStraightFlushHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
        m_vRoyalStraightFlushHand = CardHelper::getAllRoyalStraightFlushHands((*GlobalVariable::m_pUser->m_vCardId), m_attackerHand);
    }
    // Player fire simple hand
    else
    {
        m_vStraightHand      = {};
        m_vFlushHand         = {};
        m_vFullhouseHand     = {};
        m_vFullhouseHand     = {};
        m_vStraightFlushHand = {};
        m_vRoyalStraightFlushHand = {};
    }
    
    // Reset index of all hand
    m_iIndexStraightHand      = -1;
    m_iIndexFlushHand         = -1;
    m_iIndexFullhouseHand     = -1;
    m_iIndexFourOfAKindHand   = -1;
    m_iIndexStraightFlushHand = -1;
    m_iIndexRoyalStraightFlushHand = -1;
    
//    m_btnStraight->setVisible          (m_vStraightHand.size()		> 0 ? true : false);
//    m_btnFlush->setVisible             (m_vFlushHand.size()         > 0 ? true : false);
//    m_btnFullhouse->setVisible         (m_vFullhouseHand.size()     > 0 ? true : false);
//    m_btnFourOfAKind->setVisible       (m_vFourOfAKindHand.size()   > 0 ? true : false);
//    m_btnStraightFlush->setVisible     (m_vStraightFlushHand.size() > 0 ? true : false);
//    m_btnRoyalStraightFlush->setVisible(m_vRoyalStraightFlushHand.size() > 0 ? true : false);
    
    
    // CONDITION CAN DEFEND PHASE
    // Ignore if it's player's round
    if (!bHasAttackerHand) return;
    
    bool bCanDefend = false;
    
    // Player fire 2 (special case)
    if (bFire2)
    {
        bCanDefend = (CardHelper::getStrongestCard((*GlobalVariable::m_pUser->m_vCardId)) > m_v_iAttackerCardId.at(0)
                      || m_vFourOfAKindHand.size() > 0
                      || m_vStraightFlushHand.size() > 0
                      || m_vRoyalStraightFlushHand.size() > 0) ? true : false;
    }
    // Player fire complex hand
    else if (bComplexHand)
    {
        bCanDefend = (m_vStraightHand.size() > 0
                      || m_vFlushHand.size() > 0
                      || m_vFullhouseHand.size() > 0
                      || m_vFourOfAKindHand.size() > 0
                      || m_vStraightFlushHand.size() > 0
                      || m_vRoyalStraightFlushHand.size() > 0) ? true : false;
    }
    // Player fire simple hand
    else if (!bComplexHand)
    {
        // Player fire one card
        if (m_attackerHand->getType() == CardHand::HIGH_CARD)
        {
            bCanDefend = CardHelper::getStrongestCard((*GlobalVariable::m_pUser->m_vCardId)) > m_v_iAttackerCardId.at(0) ? true : false;
        }
        // Player fire pair or three of a kind
        else if (m_attackerHand->getType() == CardHand::PAIR || m_attackerHand->getType() == CardHand::THREE_OF_A_KIND)
        {
            bCanDefend = CardHelper::getStrongerHand(m_attackerHand, (*GlobalVariable::m_pUser->m_vCardId), vector<int> {}) != nullptr ? true : false;
        }
    }
    
    // Hint ignore in case player can not defend
    m_hintArrow->setVisible(!bCanDefend);
}

void CapsaBantingScene::inactivateHintHands()
{
    m_btnStraight->setVisible(false);
    m_btnFlush->setVisible(false);
    m_btnFullhouse->setVisible(false);
    m_btnFourOfAKind->setVisible(false);
    m_btnStraightFlush->setVisible(false);
    m_btnRoyalStraightFlush->setVisible(false);
}

void CapsaBantingScene::deleteHintHands()
{
    for (int i = 0, l = m_vStraightHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vStraightHand.at(i));
    }
    for (int i = 0, l = m_vFlushHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vFlushHand.at(i));
    }
    for (int i = 0, l = m_vFullhouseHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vFullhouseHand.at(i));
    }
    for (int i = 0, l = m_vFourOfAKindHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vFourOfAKindHand.at(i));
    }
    for (int i = 0, l = m_vStraightFlushHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vStraightFlushHand.at(i));
    }
    for (int i = 0, l = m_vRoyalStraightFlushHand.size(); i < l; i++)
    {
        CC_SAFE_DELETE(m_vRoyalStraightFlushHand.at(i));
    }
    m_vStraightHand.clear();
    m_vFlushHand.clear();
    m_vFullhouseHand.clear();
    m_vFourOfAKindHand.clear();
    m_vStraightFlushHand.clear();
    m_vRoyalStraightFlushHand.clear();
}

/*************************************************************/
/* @author longnh                                              */
/* Sort by hand in deck                                      */
/*************************************************************/
void CapsaBantingScene::onTouchBtnStraight(Ref* pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vStraightHand.size() == 0) return;
    
    m_iIndexStraightHand++;
    if (m_iIndexStraightHand == m_vStraightHand.size()) m_iIndexStraightHand = 0;
    CardHand* hand = m_vStraightHand.at(m_iIndexStraightHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}
void CapsaBantingScene::onTouchBtnFlush(Ref* pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vFlushHand.size() == 0) return;
    
    m_iIndexFlushHand++;
    if (m_iIndexFlushHand == m_vFlushHand.size()) m_iIndexFlushHand = 0;
    CardHand* hand = m_vFlushHand.at(m_iIndexFlushHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}
void CapsaBantingScene::onTouchBtnFullhouse(Ref* pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vFullhouseHand.size() == 0) return;
    
    m_iIndexFullhouseHand++;
    if (m_iIndexFullhouseHand == m_vFullhouseHand.size()) m_iIndexFullhouseHand = 0;
    CardHand* hand = m_vFullhouseHand.at(m_iIndexFullhouseHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}
void CapsaBantingScene::onTouchBtnFourOfAKind(Ref* pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vFourOfAKindHand.size() == 0) return;
    
    m_iIndexFourOfAKindHand++;
    if (m_iIndexFourOfAKindHand == m_vFourOfAKindHand.size()) m_iIndexFourOfAKindHand = 0;
    CardHand* hand = m_vFourOfAKindHand.at(m_iIndexFourOfAKindHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}
void CapsaBantingScene::onTouchBtnStraightFlush(Ref* pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vStraightFlushHand.size() == 0) return;
    
    m_iIndexStraightFlushHand++;
    if (m_iIndexStraightFlushHand == m_vStraightFlushHand.size()) m_iIndexStraightFlushHand = 0;
    CardHand* hand = m_vStraightFlushHand.at(m_iIndexStraightFlushHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}

void CapsaBantingScene::onTouchBtnRoyalStraightFlush(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    if (m_vRoyalStraightFlushHand.size() == 0) return;
    
    m_iIndexRoyalStraightFlushHand++;
    if (m_iIndexRoyalStraightFlushHand == m_vRoyalStraightFlushHand.size()) m_iIndexRoyalStraightFlushHand = 0;
    CardHand* hand = m_vRoyalStraightFlushHand.at(m_iIndexRoyalStraightFlushHand);
    vector<int> vCardId = hand->getCardIds();
    vector<Card*>* defenderCards = GlobalVariable::getInstance()->m_pUser->m_vCard;
    for (int i = 0, li = defenderCards->size(); i < li; i++)
    {
        Card* card = defenderCards->at(i);
        if (std::find(vCardId.begin(), vCardId.end(), card->m_iId) == vCardId.end())
        {
            card->setState(CardState::kCardStateUngrabbed);
        }
        else
        {
            card->setState(CardState::kCardStateSelected);
        }
    }
}
