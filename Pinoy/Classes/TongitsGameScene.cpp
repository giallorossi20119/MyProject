#include "TongitsGameScene.h"

//const
#define kDISTANCE_X_2_CARDS        60
#define kDISTANCE_X_2_CARDS_1      20
#define kDISTANCE_X_2_CARDS_2      15
#define kDISTANCE_Y_2_CARDS        8
#define kDISTANCE_Y_2_CARDS_2      10
#define kCARD_SCALE_FACTOR_SMALL   0.4f
#define kCARD_SCALE_FACTOR_SMALL_2 0.3f
#define kDISTANCE_Y_ALL_CARDS      100
#define kDISTANCE_X_CARD_ON_TABLE  60
#define kDISTANCE_Y_CARD_ON_TABLE  40
#define kDISTANCE_X_CARD_ON_HAND_TABLE  40
#define kDISTANCE_Y_BUTTON_SUGGEST      70

int g_iDistanceT = 0;
TongitsGameScene::TongitsGameScene()
{
    m_vChatToastPosition = vector<Vec2>();
    m_vUserInfoOthers = new vector<UserInfoOther*>();
    vector<int> m_v_iAttackerCardId = {};
    vector<int> m_v_iDefenderCardId = {};
    
    m_dStartId = 0;
    m_bFinishGame = false;
    m_iHandPosX = 0;
    m_iHandPosY = 0;
    m_iHandCount = 0;
    
//    m_vFiredCards = new vector<Card*>();
    m_vDroppedCards = new vector<Card*>();
    m_iCountDown = 0;
    m_iTypeSort = 0;
    m_sprDeadEffect = Sprite::create();
    m_iLastCount = 0;
    m_iCurrentCount = 0;
    m_bCanJoinRoom = false;
    m_bCanLeftRoom = false;
    m_iCountTurns = 0;
    m_selectingCard = nullptr;
}

TongitsGameScene::~TongitsGameScene()
{
//    removeAllChildrenWithCleanup(true);
//    for (int i = 0, l = m_vUserInfoOthers->size(); i < l; i++)
//    {
//        if (m_vUserInfoOthers->at(i))
//        {
//            CC_SAFE_DELETE(m_vUserInfoOthers->at(i));
//        }
//    }
    m_vUserInfoOthers->clear();
    CC_SAFE_DELETE(m_vUserInfoOthers);
}

void TongitsGameScene::onEnter()
{
    BaseScene::onEnter();
    // Game loop event
    schedule(schedule_selector(TongitsGameScene::update));
//    // Init UI
    AudioManager::getInstance()->stopSoundBackground();
    BaseScene::initUI(kSceneJsonTongitsGame);

    addEventlistener();

    for(int i = 0; i < 3; i++)
    {
        pnlPlayerAreas[i] = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, ccsf("pnlPlayerArea%d", i)));
        Button* btnInvite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        if(btnInvite)
        {
            btnInvite->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnInviteClick, this));
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
    
    for(int j=1;j<3;j++)
    {
        pnlPhomPlayer[j]    = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, ccsf("PnlPhomPlayer%d",j)));
    }
    
    for(int k=0;k<4;k++)
    {
        pnlPhom[k] = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, ccsf("PnlPhom%d",k)));
    }

    pnlPlayerAreas[0]->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::unselectedCards, this));
    pnlTableArea       = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlTableArea"));
    pnlGameBar         = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlGameBar"));
    pnlGameBar->setVisible(false);
    
    btnSend            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSend"));
    btnSend->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnSendClick, this));
    btnMeld          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnMeld"));
    btnMeld->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnMeldClick, this));
    btnCall            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCall"));
    btnCall->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnCallClick, this));
    btnSort            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSort"));
    btnSort->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnSortClick, this));
    btnDump          = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnDump"));
    btnDump->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnDumpClick, this));
    btnTongits            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnTongits"));
    btnTongits->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnTongitsClick, this));
    btnDeck            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnDeck"));
    btnDeck->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnDeckClick, this));
    btnDeck->setVisible(false);
    btnEat            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnEat"));
    btnEat->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnEatClick, this));
    btnEat->setVisible(false);
    btnLook            = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnLook"));
    btnLook->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnLookClick, this));
    btnLook->setVisible(false);
    
    pnlTableArea->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::unselectedCards, this));
    pnlUserInfo  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlUserInfo"));

    //user infor component
    if (GlobalVariable::m_pUserInfo->getParent()) GlobalVariable::m_pUserInfo->removeFromParent();
    pnlUserInfo->addChild(GlobalVariable::m_pUserInfo);
    GlobalVariable::m_pUserInfo->setPosition(Vec2(0, 0));
    GlobalVariable::m_pUserInfo->fillDataUserInfo();
    GlobalVariable::m_pUserInfo->setScale(0.8f);
    //setting panel
    auto pnlSetting  = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlSetting"));
    pnlSetting->addChild(GlobalVariable::m_pSettingCom);
    GlobalVariable::m_pSettingCom->setVisibleItems(false, false, true, true, true, true);
    GlobalVariable::m_pSettingCom->setPosition(Vec2(-700, -430));
    
    prgTime     = static_cast<LoadingBar*>(Helper::seekWidgetByName(pnlGameBar, "prgTime"));
    imgTimeBg   = static_cast<ImageView*>(Helper::seekWidgetByName(pnlGameBar, "imgTimeBg"));
    pnlTimer    = static_cast<Layout*>(Helper::seekWidgetByName(pnlGameBar, "pnlTimer"));
    imgLight    = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgLight"));
    imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
    imgLight->setPositionY(imgTimeBg->getPositionY() + 2);
    
    setVisibleGameButtons(false);
    
    btnStart  = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnStart"));
    btnStart->addTouchEventListener(CC_CALLBACK_2(TongitsGameScene::onBtnStartClick, this));
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
    bmfPot   = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfPot"));
    bmfPot->setString("");
    bmfDeckNo = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfDeckNo"));
    
    bmBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetDataT->m_iCuoc));
    bmTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetDataT->m_iTime)));
    
//    m_pnlCountDown = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlCountDown"));
//    m_pnlCountDown->setVisible(false);
    
    pnlSuggest = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlSuggest"));
    pnlSuggest->setVisible(false);
    
//    m_bmfCountDown = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfCountDown"));
//    m_bmfCountDown->setVisible(false);
    pnlInvite   = static_cast<Layout*>(Helper::seekWidgetByName(m_pLayout, "pnlInvite"));
    lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
    
    if(!(GlobalVariable::m_vPlayersSorted->size() == 1))
    {
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_WAITING_HOST_START));
    }
    else
    {
        if (GlobalVariable::m_vPlayersSorted->size() == 4)
        {
            lblInvite->setVisible(false);
        }
        else
        {
            lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITE_MORE));
        }
    }
    lblInvite->runAction(RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 255), FadeTo::create(0.5f, 0), NULL)));

    relayout();
    changeLanguage(nullptr);
    //reconnect

    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onSelectedCard), "select card", nullptr);
    m_attackerHand = nullptr;
    
    CCLOG("Playing: %i | Reconnect: %i | Spectator: %i", GlobalVariable::m_cSetDataT->m_bPlaying, GlobalVariable::m_cSetDataT->m_bReconnect, GlobalVariable::m_cSetDataT->m_bSpectator);
    
    placePlayers();
    if(GlobalVariable::m_cSetDataT->m_bPlaying)
    {
        pnlInvite->setVisible(false);
        btnLook->setVisible(true);
        btnDeck->setVisible(true);
        bmfDeckNo->setString(ccsf("%i",GlobalVariable::m_iDeckNo));
        setTurnId(GlobalVariable::m_cSetDataT->m_dNextTurnId, false);
        btnStart->setVisible(false);
        if(GlobalVariable::m_cSetDataT->m_bReconnect)
        {
            reconnect();
        }
        if(GlobalVariable::m_cSetDataT->m_bSpectator)
        {
            showMessage(true, kTEXT_MSG_WATCHING);
            spectator();
        }
    }
    else
    {
        if(GlobalVariable::m_pUser->m_bHost)
        {
//            SettingRoomPopupT* pu = new SettingRoomPopupT(GlobalVariable::getInstance()->m_pDataMinMaxStakeT, GlobalVariable::m_cSetDataT->m_iCuoc, GlobalVariable::m_cSetDataT->m_iTime, true);
//            openPopup(pu);
        }
    }
}

void TongitsGameScene::showKickUser(bool bShow)
{
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleKickBtn(bShow);
    }
}

void TongitsGameScene::spectator()
{
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
        if(GlobalVariable::m_cSetDataT->m_dNextTurnId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
        {
            m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetDataT->m_iTimeTurnRemain);
        }
    }
    pnlGameBar->setVisible(false);
    setVisibleGameButtons(false);
}

void TongitsGameScene::reconnect()
{
    int a,b,c,d=0;
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        //is Me
        if(GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop==GlobalVariable::m_pUser->m_dId)
        {
            for(int j=0;j<GlobalVariable::m_vCMDDropCardData->at(i)->m_sTotalPhom;j++)
            {
                if(j==0)
                {
                    a=0;
                    for(int k=0;k<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->size();k++)
                    {
                        Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->at(k));
                        card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                        card->m_iIdPhom=j;
                        card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                        card->setScale(0.5f);
                        card->setState(CardState::kCardStateKicked);
                        pnlPhom[card->m_iIdPhom]->addChild(card);
                        m_vDroppedCards->push_back(card);
                        card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+a);
                        a+=30;
                    }
                }
                if(j==1)
                {
                    b=0;
                    for(int k=0;k<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->size();k++)
                    {
                        Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->at(k));
                        card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                        card->m_iIdPhom=j;
                        card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                        card->setScale(0.5f);
                        card->setState(CardState::kCardStateKicked);
                        pnlPhom[card->m_iIdPhom]->addChild(card);
                        m_vDroppedCards->push_back(card);
                        card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+b);
                        b+=30;
                    }
                }
                if(j==2)
                {
                    c=0;
                    for(int k=0;k<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->size();k++)
                    {
                        Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->at(k));
                        card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                        card->m_iIdPhom=j;
                        card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                        card->setScale(0.5f);
                        card->setState(CardState::kCardStateKicked);
                        pnlPhom[card->m_iIdPhom]->addChild(card);
                        m_vDroppedCards->push_back(card);
                        card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+c);
                        c+=30;
                    }
                }
                if(j==3)
                {
                    d=0;
                    for(int k=0;k<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->size();k++)
                    {
                        Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->at(k));
                        card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                        card->m_iIdPhom=j;
                        card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                        card->setScale(0.5f);
                        card->setState(CardState::kCardStateKicked);
                        pnlPhom[card->m_iIdPhom]->addChild(card);
                        m_vDroppedCards->push_back(card);
                        card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+d);
                        d+=30;
                    }
                }
            }
            //rearrange phom position
            if(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->size()>3)
            {
                int distance=(int)GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->size()-3;
                relayoutPhom(1,distance);
                relayoutPhom(2,distance);
                relayoutPhom(3,distance);
            }
            else if(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->size()>3)
            {
                int distance=(int)GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->size()-3;
                relayoutPhom(2,distance);
                relayoutPhom(3,distance);
            }
            else if(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->size()>3)
            {
                int distance=(int)GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->size()-3;
                relayoutPhom(3,distance);
            }
            else if(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->size()>3)
            {

            }
        }
        
        //another player
        if(i>0)
        {
            for(int j=0;j<3;j++)
            {
                if(GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop==GlobalVariable::m_vPlayersSorted->at(j)->m_dId&&GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop!=GlobalVariable::m_pUser->m_dId)
                {
                    for(int k=0;k<GlobalVariable::m_vCMDDropCardData->at(i)->m_sTotalPhom;k++)
                    {
                        if(k==0)
                        {
                            a=0;
                            for(int l=0;l<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->size();l++)
                            {
                                if(GlobalVariable::m_cSetDataT->m_bSpectator)
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.5f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhom[card->m_iIdPhom]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+a);
                                    a+=30;
                                }
                                else
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom1->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.4f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhomPlayer[j]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+a-230,pnlPhomPlayer[i]->getContentSize().height-40-card->m_iIdPhom*40));
                                    a+=15;
                                }
                            }
                        }
                        if(k==1)
                        {
                            b=0;
                            for(int l=0;l<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->size();l++)
                            {
                                if(GlobalVariable::m_cSetDataT->m_bSpectator)
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.5f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhom[card->m_iIdPhom]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+b);
                                    b+=30;
                                }
                                else
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom2->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.4f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhomPlayer[j]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+b-230,pnlPhomPlayer[i]->getContentSize().height-40-card->m_iIdPhom*40));
                                    b+=15;
                                }
                            }
                        }
                        if(k==2)
                        {
                            c=0;
                            for(int l=0;l<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->size();l++)
                            {
                                if(GlobalVariable::m_cSetDataT->m_bSpectator)
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.5f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhom[card->m_iIdPhom]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+c);
                                    c+=30;
                                }
                                else
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom3->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.4f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhomPlayer[j]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+c-230,pnlPhomPlayer[i]->getContentSize().height-40-card->m_iIdPhom*40));
                                    c+=15;
                                }
                            }
                        }
                        if(k==3)
                        {
                            d=0;
                            for(int l=0;l<GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->size();l++)
                            {
                                if(GlobalVariable::m_cSetDataT->m_bSpectator)
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.5f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhom[card->m_iIdPhom]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+d);
                                    d+=30;
                                }
                                else
                                {
                                    Card* card=Card::create(GlobalVariable::m_vCMDDropCardData->at(i)->m_vCardIdPhom4->at(l));
                                    card->m_dIdPlayer=(double)GlobalVariable::m_vCMDDropCardData->at(i)->m_dIdPlayerDrop;
                                    card->m_iIdPhom=k;
                                    card->m_iTotalCardDrop=GlobalVariable::m_vCMDDropCardData->at(i)->m_sNumberCardDrop;
                                    card->setScale(0.4f);
                                    card->setState(CardState::kCardStateKicked);
                                    pnlPhomPlayer[j]->addChild(card);
                                    m_vDroppedCards->push_back(card);
                                    card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+d-230,pnlPhomPlayer[i]->getContentSize().height-40-card->m_iIdPhom*40));
                                    d+=15;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
        
    
    sortCards();
    //display card on table
    m_iHandPosX = pnlTableArea->getContentSize().width / 2 - (4 * 35) / 2;
    m_iHandPosY = pnlTableArea->getPosition().y - 20;
    int count = 0;
    GlobalVariable::m_iTotalFiredCard=0;
    Size deviceSize = Director::getInstance()->getWinSize();
    for(int i = 0; i < GlobalVariable::m_cSetDataT->m_vCardId->size(); i++)
    {
        count++;
        if(GlobalVariable::m_cSetDataT->m_vCardId->at(i) != -1)
        {
            GlobalVariable::m_iTotalFiredCard+=1;
            Card* card = Card::create(GlobalVariable::m_cSetDataT->m_vCardId->at(i));
            card->setScale(0.5f);
            card->setState(CardState::kCardStateKicked);
            pnlTableArea->addChild(card);
            card->setPosition(Vec2(pnlTableArea->getContentSize().width/2+43,pnlTableArea->getContentSize().height/2+1));
            CCLOG("pnlTable contentsize %f",pnlTableArea->getContentSize().width/2+5);
            CCLOG("pnlTable toa do x= %f  y=%f",pnlTableArea->getPositionX(),pnlTableArea->getPositionY());
            CCLOG("card danh toa do x= %f  y=%f",card->getPositionX(),card->getPositionY());
            CCLOG("card danh toa do anchor x= %f  y=%f",card->getAnchorPoint().x,card->getAnchorPoint().y);
            GlobalVariable::m_vFiredCards->push_back(card);
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
            if(GlobalVariable::m_cSetDataT->m_dNextTurnId == GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
            {
                m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetDataT->m_iTimeTurnRemain);
            }
        }
    }
    showItemsRoom();

}

void TongitsGameScene::showMessage(bool bVisible, const char* messageid)
{
    pnlInvite->setVisible(bVisible);
    if(bVisible)
    {
        Text* lblInvite = static_cast<Text*>(Helper::seekWidgetByName(pnlInvite, "lbInvite"));
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(messageid));
    }
}

void TongitsGameScene::onSelectedCard(Ref* obj)
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

void TongitsGameScene::setTurnId(double p_iTurnId, bool p_bFirst)
{
    GlobalVariable::m_bAlreadyGetCard=false;
    
    if(!GlobalVariable::m_cSetDataT->m_bSpectator)
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
    
    if(p_iTurnId == GlobalVariable::m_pUser->m_dId && !GlobalVariable::m_cSetDataT->m_bSpectator)
    {
        m_hintArrow->setVisible(false);
//        activateHintHands();
        pnlTimer->setVisible(true);
        prgTime->setPercent(100.0f);
        pnlSuggest->setVisible(true);
        //time life
        imgLight->stopAllActions();
        imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
        imgLight->setPositionY(imgTimeBg->getPositionY() + 4);
        auto moveto = MoveTo::create(GlobalVariable::m_cSetDataT->m_iTime, Vec2(imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2, imgTimeBg->getPositionY() + 4));
        imgLight->runAction(moveto);
        ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
        imgClock->setVisible(true);
        m_fCountTimeLeft = GlobalVariable::m_cSetDataT->m_iTime;
        unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
        schedule(schedule_selector(TongitsGameScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);
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
                m_vUserInfoOthers->at(i)->setTurnEffect(true, GlobalVariable::m_cSetDataT->m_iTime);
            }
        }
    }
}

void TongitsGameScene::onPrgTimer(float dt)
{
    ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
    TextBMFont* bmCountDown = static_cast<TextBMFont*>(Helper::seekWidgetByName(imgClock, "bmCountDown"));
    m_fCountTimeLeft = m_fCountTimeLeft - dt;
    if(m_fCountTimeLeft < 0)
    {
        imgClock->setVisible(false);
        unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
        return;
    }
    float percent = (100 * (imgLight->getPositionX() - (imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2))) / imgTimeBg->getContentSize().width;
    bmCountDown->setString(ccsf("%1.0f", m_fCountTimeLeft));
    prgTime->setPercent(percent);
}

void TongitsGameScene::setActiveButtons(double iTurnID, bool bFirst)
{
    if(iTurnID == GlobalVariable::m_pUser->m_dId)
    {
        btnDump->setVisible(true);
        btnMeld->setVisible(true);
        if(bFirst) //you start game or your round
        {
            btnSend->setVisible(false);
            btnCall->setVisible(false);
        }
        else
        {
            btnSend->setVisible(true);
        }
    }
    else
    {
        btnDump->setVisible(false);
        btnCall->setVisible(false);
        btnMeld->setVisible(false);
        btnSend->setVisible(false);
        btnTongits->setVisible(false);
    }
}

bool sortFuncIncreaseT(const int &a, const int &b)
{
    return (a < b);
}

bool sortFuncDecreaseT(const int &a, const int &b)
{
    return (a > b);
}

void TongitsGameScene::sortCards()
{
    if(m_iTypeSort == 0)
    {
        std::sort(GlobalVariable::m_pUser->m_vCardId->begin(), GlobalVariable::m_pUser->m_vCardId->end(), sortFuncIncreaseT);
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

void TongitsGameScene::displayCards()
{
    CCLOG("displayCards %lu", GlobalVariable::m_pUser->m_vCardId->size());
    //display card
    long NOCards = GlobalVariable::m_pUser->m_vCardId->size();
//    int x = (pnlPlayerAreas[0]->getContentSize().width - (NOCards - 1) * g_iDistanceT) / 2;
    int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistanceT) / 2;
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
            card->m_posOrigin = Vec2(x + i * g_iDistanceT, kDISTANCE_Y_ALL_CARDS);
            card->setPosition(Vec2(x + i * g_iDistanceT, kDISTANCE_Y_ALL_CARDS));
        }
    }
}

void TongitsGameScene::onBtnLookClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    FiredCardPopup* fp = new FiredCardPopup();
    openPopup(fp);
}

void TongitsGameScene::onBtnStartClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    showMessage(false, "");
//    m_pnlCountDown->setVisible(false);
//    m_bmfCountDown->setVisible(false);
//    m_bmfCountDown->setString("10");
    SFSConnection::getInstance()->startGame();
}

void TongitsGameScene::onBtnSortClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
    sortCards();
}

void TongitsGameScene::onBtnSendClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectFire,false);
    boost::shared_ptr<ByteArray> bytesCard (new ByteArray());
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if(card->m_iState == kCardStateSelected)
        {
            bytesCard->WriteShort(card->m_iId);
        }
    }
    if(bytesCard->Length() > 0)
    {
//        if(m_bAllowtoSendCard==true)
//        {
            SFSConnection::getInstance()->sendCard(bytesCard);
//        }
//        else
//        {
//            return;
//        }
    }
}

void TongitsGameScene::onBtnMeldClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectFire,false);
    boost::shared_ptr<ByteArray> bytesCard (new ByteArray());
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if(card->m_iState == kCardStateSelected)
        {
            bytesCard->WriteShort(card->m_iId);
        }
    }
    if(bytesCard->Length() > 0)
    {
        SFSConnection::getInstance()->dropCard(bytesCard);
    }
}

void TongitsGameScene::onBtnEatClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectFire,false);
    boost::shared_ptr<ByteArray> bytesCard (new ByteArray());
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if(card->m_iState == kCardStateSelected or card->m_iState == kCardStateKicked)
        {
            bytesCard->WriteShort((short)card->m_iId);
        }
        
    }
    if(bytesCard->Length() > 0)
    {
        SFSConnection::getInstance()->eatCard(bytesCard);
        GlobalVariable::m_iTotalCardinHand+=1;
    }
}

void TongitsGameScene::onBtnCallClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectSoBai,false);
    if(GlobalVariable::m_bCanDraw==true)
    {
        SFSConnection::getInstance()->requestDraw();
        openPopup(new AlertPopup("You have made a call draw, please wait response from other players"));
    }
}

void TongitsGameScene::onBtnTongitsClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectSoBai,false);
    SFSConnection::getInstance()->requestU();
}

void TongitsGameScene::onBtnDeckClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai,false);
    SFSConnection::getInstance()->pickCard();
}

void TongitsGameScene::onBtnDumpClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
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

void TongitsGameScene::onBtnChangeLanguageClick(cocos2d::Ref *pSender, Widget::TouchEventType type)
{

}

void TongitsGameScene::onKeyReleased(EventKeyboard::KeyCode keyCode, cocos2d::Event *event)
{

}

void TongitsGameScene::onClientGetStart(Ref* obj)
{
    if(getChildByName("dead2"))removeChildByName("dead2");
    CMDUserData* userData = (CMDUserData*)obj;
    m_dStartId = userData->m_dUID;
    
//    m_pnlCountDown->setVisible(false);
//    m_bmfCountDown->setVisible(false);
//    m_bmfCountDown->setString("10");
    
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
    if(GlobalVariable::m_pUser->m_dId == m_dStartId && GlobalVariable::m_cSetDataT->m_bPlaying == false)
    {
        if(GlobalVariable::m_vPlayersSorted->size() > 2)
        {
            btnStart->setVisible(true);
            pnlInvite->setVisible(false);
        }
    }
    
    if(GlobalVariable::m_vPlayers->size() < 3)
    {
        btnStart->setVisible(false);
        btnDeck->setVisible(false);
        btnLook->setVisible(false);
        pnlInvite->setVisible(true);
        bmfPot->setString("");
        for(int i=1;i<3;i++)
        {
            pnlPhomPlayer[i]->removeAllChildren();
        }
    }
    
    if(!(GlobalVariable::m_vPlayersSorted->size() == 1))
    {
        lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_WAITING_HOST_START));
    }
    else
    {
        if (GlobalVariable::m_vPlayersSorted->size() == 4)
        {
            lblInvite->setVisible(false);
        }
        else
        {
            lblInvite->setString(ResourceManager::getInstance()->getTextByName(kTEXT_MSG_INVITE_MORE));
        }
    }
    lblInvite->runAction(RepeatForever::create(Sequence::create(FadeTo::create(0.5f, 255), FadeTo::create(0.5f, 0), NULL)));
}

void TongitsGameScene::setVisibleGameButtons(bool bVisible)
{
    btnDump->setVisible(bVisible);
    btnSort->setVisible(bVisible);
    btnTongits->setVisible(bVisible);
    btnCall->setVisible(bVisible);
    btnMeld->setVisible(bVisible);
    btnSend->setVisible(bVisible);
    pnlTimer->setVisible(bVisible);
}

void TongitsGameScene::onBtnInviteClick(Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    AudioManager::getInstance()->playEffect(kSoundEffectButtonClick);
    SFSConnection::getInstance()->getWaitingList();
}

void TongitsGameScene::relayout()
{
    Size deviceSize = Director::getInstance()->getWinSize();
    g_iDistanceT = deviceSize.width / 14;
    ImageView* imgInGameBG = static_cast<ImageView*>(Helper::seekWidgetByName(m_pLayout, "imgTableBg"));
    imgInGameBG->setScaleX(float(deviceSize.width / 960));
    imgInGameBG->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2));
    pnlPlayerAreas[0]->setPositionX((deviceSize.width - pnlPlayerAreas[0]->getContentSize().width) / 2);
    pnlPlayerAreas[1]->setPositionX(deviceSize.width - pnlPlayerAreas[1]->getContentSize().width);
    pnlPlayerAreas[2]->setPositionX((deviceSize.width - pnlPlayerAreas[2]->getContentSize().width) / 100);
    pnlTableArea->setPositionX((deviceSize.width - pnlTableArea->getContentSize().width) / 2);
    btnStart->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 - 100));
    GlobalVariable::m_pSettingCom->setPosition(Vec2(-190 + deviceSize.width - GlobalVariable::m_iGameWidth, 40));
    m_vChatToastPosition.push_back(Vec2(300.0f, deviceSize.height-140.0f));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width - 180.0f, deviceSize.height / 2));
    m_vChatToastPosition.push_back(Vec2(deviceSize.width / 2, deviceSize.height - 140.0f));
    m_vChatToastPosition.push_back(Vec2(250.0f, deviceSize.height / 2));
    pnlInvite->setPositionX(deviceSize.width / 2 - pnlInvite->getContentSize().width / 2);
//    m_pnlCountDown->setPosition(Vec2(deviceSize.width / 2 + m_pnlCountDown->getContentSize().width / 2, deviceSize.height / 2 + m_pnlCountDown->getContentSize().height / 2));
//    m_bmfCountDown->setPosition(Vec2(deviceSize.width / 2, deviceSize.height / 2 + 5));
    if(deviceSize.width / (float) deviceSize.height < 1.5f)
    {
        btnSend->setPositionX(btnSend->getPositionX() + 140);
        btnCall->setPositionX(btnCall->getPositionX() + 140);
        btnSort->setPositionX(btnSort->getPositionX() + 140);
        btnMeld->setPositionX(btnMeld->getPositionX() + 140);
    }
    m_hintArrow->setPosition(btnSend->getPosition().x, btnSend->getPosition().y + 50.0f);
    btnDeck->setPositionX((deviceSize.width - btnDeck->getContentSize().width)/2-10);
    
    pnlPhom[0]->setPosition(Vec2(deviceSize.width/2-550,deviceSize.height/2-30));
    pnlPhom[1]->setPosition(Vec2(deviceSize.width/2-400,deviceSize.height/2-30));
    pnlPhom[2]->setPosition(Vec2(deviceSize.width/2-250,deviceSize.height/2-30));
    pnlPhom[3]->setPosition(Vec2(deviceSize.width/2-100,deviceSize.height/2-30));
}

void TongitsGameScene::relayoutPhom(int value,int distance)
{
    pnlPhom[value]->setPositionX(pnlPhom[value]->getPositionX()+distance*30);
}

void TongitsGameScene::changeLanguage(Ref* obj)
{
//    TextBMFont* bmfStart = static_cast<TextBMFont*>(btnStart->getChildByName("bmfBtnStart"));
//    bmfStart->setString(ResourceManager::getInstance()->getTextByName(kTEXT_START));
//    
//    TextBMFont* bmfBtnSort     = static_cast<TextBMFont*>(btnSort->getChildByName("bmfBtnSort"));
//    TextBMFont* bmfBtnSort_0   = static_cast<TextBMFont*>(btnSort->getChildByName("bmfBtnSort_0"));
//    TextBMFont* bmfBtnPass     = static_cast<TextBMFont*>(btnPass->getChildByName("bmfBtnPass"));
//    TextBMFont* bmfBtnPlace     = static_cast<TextBMFont*>(btnPlace->getChildByName("bmfBtnPlace"));
    
//    if(GlobalVariable::m_iCurrentLanguage == 0)//Indo
//    {
//        bmfBtnSort->setPositionY(62);
//        bmfBtnSort->setString("Atur");
//        bmfBtnSort_0->setVisible(true);
//        bmfBtnSort_0->setString("kartu");
//        
//        bmfBtnPass->setString("Lewat");
//        
//        bmfBtnPlace->setString("Main");
//    }
//    else
//    {
//        bmfBtnSort->setPositionY(48);
//        bmfBtnSort->setString("Sort");
//        bmfBtnSort_0->setVisible(false);
//        
//        bmfBtnPass->setString("Pass");
//        
//        bmfBtnPlace->setString("Place");
//    }
}

void TongitsGameScene::addEventlistener()
{
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onUserJoinRoom), T_USER_JOIN_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onUserLeftRoom), T_USER_OUT_ROOM, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onWaitingList), C_COMMAND_GET_LISTWAITING, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onStartedGame), T_START_GAME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onClientGetStart), T_GET_START_ID, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onFireCard), T_DANH_BAI, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onChangePot),  T_CHANGEPOT, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onGetCardFromDeck), T_GET_CARD_FROM_DECK, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onRoomSettingChanged), T_CHANGE_SETTING_GAME, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onMeldCard), T_HA_BAI, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onSendCard), T_GUI_BAI, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onDrawConfirm), T_XACTHUC_BAO_BAI, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onClientFinishGame), T_CLIENT_FINISH, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onUpdateUserPosition), T_CHANGE_POSITION, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onNetworkSendPublishMsrTongits), EVENT_NETWORK_SEND_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::onNetworkGetPublishMsrTongits), EVENT_NETWORK_GET_MSR, nullptr);
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(TongitsGameScene::showSettingRoom), EVENT_SHOW_SETTING_ROOM, nullptr);
}

void TongitsGameScene::showSettingRoom(Ref* obj)
{
    SettingRoomPopupT* pu = new SettingRoomPopupT(GlobalVariable::getInstance()->m_pDataMinMaxStakeT, GlobalVariable::m_cSetDataT->m_iCuoc, GlobalVariable::m_cSetDataT->m_iTime, true);
    openPopup(pu);
}

void TongitsGameScene::onNetworkSendPublishMsrTongits(Ref* obj)
{
    // Add chat toast as main player
    String* msr = (String*)obj;
    ChatToast* toast = ChatToast::create(msr->getCString());
    Size deviceSize = Director::getInstance()->getWinSize();
    //Vec2 position = m_vChatToastPosition.at(0);
    toast->setPosition(Vec2(300.0f, deviceSize.height - 140.0f));
    m_pUILayer->addChild(toast);
}

void TongitsGameScene::onNetworkGetPublishMsrTongits(Ref* obj)
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

void TongitsGameScene::onUpdateUserPosition(Ref* obj)
{
    placePlayers();
}

void TongitsGameScene::onDrawConfirm(Ref* obj)
{
    ConfirmPopup* dp = new ConfirmPopup(GlobalVariable::m_sPopupMessage);
    openPopup(dp);
    dp->getSpecialEventDispatcher()->addCustomEventListener(ConfirmPopup::ON_CONFIRM, CC_CALLBACK_1(TongitsGameScene::confirmDraw, this));
}

void TongitsGameScene::confirmDraw(EventCustom* event)
{
    SFSConnection::getInstance()->requestDrawConfirm(true);
}

void TongitsGameScene::onRoomSettingChanged(Ref* obj)
{
    CMDSettingInGameT* cmdSettingInGame = (CMDSettingInGameT*)obj;
    showToast(ccsf("Time: %lds Stake: %ld", cmdSettingInGame->times, cmdSettingInGame->stake), 2.0f);
    GlobalVariable::m_cSetDataT->m_iCuoc = cmdSettingInGame->stake;
    GlobalVariable::m_cSetDataT->m_iTime = cmdSettingInGame->times;
    bmBet->setString(TTutil::convertKMB(GlobalVariable::m_cSetDataT->m_iCuoc));
    bmTime->setString(TTutil::addDot(ccsf("%lds", GlobalVariable::m_cSetDataT->m_iTime)));
}

void TongitsGameScene::onGetCardFromDeck(Ref* obj)
{
    if(GlobalVariable::getInstance()->m_bDebug==true)
    {
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
        GlobalVariable::m_bDebug=false;
    }
    else
    {
        checkDraw();
        GlobalVariable::m_bAlreadyGetCard=true;
        GlobalVariable::m_iDeckNo-=1;
        bmfDeckNo->setString(ccsf("%i",GlobalVariable::m_iDeckNo));
        
        CMDUserDataT* userData = (CMDUserDataT*)obj;
        if(GlobalVariable::m_pUser->m_dId==userData->m_dUID&&GlobalVariable::m_cSetDataT->m_bSpectator==false)
        {
            //check is my turn
            GlobalVariable::m_iTotalCardinHand+=1;
            btnEat->setVisible(false);
            
            int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistanceT) / 2;
            int y = GlobalVariable::m_iTotalCardinHand;
            Card* card = Card::create(GlobalVariable::m_pUser->m_vCardId->at(y));
            card->setScale(1.0f);
            GlobalVariable::m_pUser->m_vCard->push_back(card);
            pnlPlayerAreas[0]->addChild(card);
            card->m_posOrigin = Vec2(x + y * g_iDistanceT, kDISTANCE_Y_ALL_CARDS);
            card->setPosition(Vec2(x + y * g_iDistanceT, kDISTANCE_Y_ALL_CARDS));
            Action* fadeto=FadeTo::create(0.2f,255);
            card->runAction(fadeto);
        }
        
        for(int i = 0; i < 3; i++)
        {
            if(userData->m_dUID==GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
            {
                if(userData->m_dUID!=GlobalVariable::m_pUser->m_dId)
                {
                    GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards +=1;
                    m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
                    m_vUserInfoOthers->at(i)->setTurnEffect(true,(int) GlobalVariable::m_cSetDataT->m_iTime);
                }
                else
                {
                    m_hintArrow->setVisible(false);
                    //        activateHintHands();
                    pnlTimer->setVisible(true);
                    prgTime->setPercent(100.0f);
                    pnlSuggest->setVisible(true);
                    //time life
                    imgLight->stopAllActions();
                    imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
                    imgLight->setPositionY(imgTimeBg->getPositionY() + 4);
                    auto moveto = MoveTo::create(GlobalVariable::m_cSetDataT->m_iTime, Vec2(imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2, imgTimeBg->getPositionY() + 4));
                    imgLight->runAction(moveto);
                    ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
                    imgClock->setVisible(true);
                    m_fCountTimeLeft = GlobalVariable::m_cSetDataT->m_iTime;
                    unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
                    schedule(schedule_selector(TongitsGameScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);
                    //disable other turn
                    
                    for(int i = 1; i < GlobalVariable::m_vPlayersSorted->size(); i++)
                    {
                        m_vUserInfoOthers->at(i)->setTurnEffect(false);
                    }
                }
            }
        }
        checkU();
    }
}

void TongitsGameScene::checkU()
{
    //check u
    if(GlobalVariable::m_bCanU==true)
    {
        btnTongits->setVisible(true);
    }
    else
    {
        btnTongits->setVisible(false);
    }
}

void TongitsGameScene::checkDraw()
{
    //check u
    if(GlobalVariable::m_bCanDraw==true)
    {
        btnCall->setVisible(true);
    }
    else
    {
        btnCall->setVisible(false);
    }
}

void TongitsGameScene::onMeldCard(Ref* obj)
{
    checkDraw();
    CMDDropCardDataT* dropCardData=(CMDDropCardDataT*)obj;
    setActiveButtons(dropCardData->m_dIdPlayerDrop, false);
    
    //is Me
    if(dropCardData->m_dIdPlayerDrop==GlobalVariable::m_pUser->m_dId)
    {
        int a=0;
        for(int i=0;i<dropCardData->m_vCardIdDrop->size();i++)
        {
            for(int k=0;k<GlobalVariable::m_vFiredCards->size();k++)
            {
                if(dropCardData->m_vCardIdDrop->at(i)==GlobalVariable::m_vFiredCards->at(k)->m_iId)
                {
                    GlobalVariable::m_vFiredCards->erase(GlobalVariable::m_vFiredCards->begin() + k);
                    
                    CCLOG("%d",GlobalVariable::m_iTotalFiredCard);
                    pnlTableArea->removeChildByName(ccsf("card%d",GlobalVariable::m_iTotalFiredCard-1));
                    GlobalVariable::m_iTotalFiredCard+=1;
                    
                    m_hintArrow->setVisible(false);
                    //        activateHintHands();
                    pnlTimer->setVisible(true);
                    prgTime->setPercent(100.0f);
                    pnlSuggest->setVisible(true);
                    //time life
                    imgLight->stopAllActions();
                    imgLight->setPositionX(imgTimeBg->getPositionX() + imgTimeBg->getContentSize().width / 2);
                    imgLight->setPositionY(imgTimeBg->getPositionY() + 4);
                    auto moveto = MoveTo::create(GlobalVariable::m_cSetDataT->m_iTime, Vec2(imgTimeBg->getPositionX() - imgTimeBg->getContentSize().width / 2, imgTimeBg->getPositionY() + 4));
                    imgLight->runAction(moveto);
                    ImageView* imgClock     = static_cast<ImageView*>(Helper::seekWidgetByName(pnlTimer, "imgClock"));
                    imgClock->setVisible(true);
                    m_fCountTimeLeft = GlobalVariable::m_cSetDataT->m_iTime;
                    unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
                    schedule(schedule_selector(TongitsGameScene::onPrgTimer), 0.0f, kRepeatForever, 0.0f);
                    //disable other turn
                    
                    for(int i = 1; i < GlobalVariable::m_vPlayersSorted->size(); i++)
                    {
                        m_vUserInfoOthers->at(i)->setTurnEffect(false);
                    }

                }
            }
            
            Card* card=Card::create(dropCardData->m_vCardIdDrop->at(i));
            card->m_dIdPlayer=(double)dropCardData->m_dIdPlayerDrop;
            card->m_iIdPhom=dropCardData->m_sPhom;
            card->m_iTotalCardDrop=dropCardData->m_sNumberCardDrop;
            card->setScale(0.5f);
            card->setState(CardState::kCardStateKicked);
            card->setLocalZOrder(dropCardData->m_sPhom);
            pnlPhom[card->m_iIdPhom]->addChild(card);
            m_vDroppedCards->push_back(card);
            card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+a);
            a+=30;
            for(int j=0;j<GlobalVariable::m_pUser->m_vCard->size();j++)
            {
                if(dropCardData->m_vCardIdDrop->at(i)==GlobalVariable::m_pUser->m_vCard->at(j)->m_iId)
                {
                    GlobalVariable::m_pUser->m_vCard->erase(GlobalVariable::m_pUser->m_vCard->begin()+j);
                }
            }
        }
        //rearrange phom position
        if(dropCardData->m_vCardIdDrop->size()>3)
        {
            if(dropCardData->m_sPhom==0)
            {
                int distance=(int)dropCardData->m_vCardIdDrop->size()-3;
                relayoutPhom(1,distance);
                relayoutPhom(2,distance);
                relayoutPhom(3,distance);
            }
            else if(dropCardData->m_sPhom==1)
            {
                int distance=(int)dropCardData->m_vCardIdDrop->size()-3;
                relayoutPhom(2,distance);
                relayoutPhom(3,distance);
            }
            else if (dropCardData->m_sPhom==2)
            {
                int distance=(int)dropCardData->m_vCardIdDrop->size()-3;
                relayoutPhom(3,distance);
            }
            else if (dropCardData->m_sPhom==3)
            {
                
            }
        }
        btnEat->setVisible(false);
        sortCards();
    }
    
    //another player
    for(int i=0;i<3;i++)
    {
        if(dropCardData->m_dIdPlayerDrop!=GlobalVariable::m_pUser->m_dId && dropCardData->m_dIdPlayerDrop==GlobalVariable::m_vPlayersSorted->at(i)->m_dId )
        {
            int a=0;
            for(int j=0;j<dropCardData->m_vCardIdDrop->size();j++)
            {
                for(int k=0;k<GlobalVariable::m_vFiredCards->size();k++)
                {
                    //another player eat card
                    if(dropCardData->m_vCardIdDrop->at(j)==GlobalVariable::m_vFiredCards->at(k)->m_iId)
                    {
                        GlobalVariable::m_vFiredCards->erase(GlobalVariable::m_vFiredCards->begin() + k);
                        CCLOG("%d",GlobalVariable::m_iTotalFiredCard);
                        pnlTableArea->removeChildByName(ccsf("card%d",GlobalVariable::m_iTotalFiredCard-1));
                        GlobalVariable::m_iTotalFiredCard+=1;
                    }
                }
                Card* card=Card::create(dropCardData->m_vCardIdDrop->at(j));
                card->m_dIdPlayer=(double)dropCardData->m_dIdPlayerDrop;
                card->m_iIdPhom=dropCardData->m_sPhom;
                card->m_iTotalCardDrop=dropCardData->m_sNumberCardDrop;
                card->setScale(0.4f);
                card->setState(CardState::kCardStateKicked);
                card->setLocalZOrder(dropCardData->m_sPhom);
                pnlPhomPlayer[i]->addChild(card);
                m_vDroppedCards->push_back(card);
                card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+a-230,pnlPhomPlayer[i]->getContentSize().height-40-dropCardData->m_sPhom*40));
                a+=15;
            }
        }
    }
    
    for(int i=0;i<3;i++)
    {
        if(dropCardData->m_dIdPlayerDrop==GlobalVariable::m_vPlayersSorted->at(i)->m_dId&&dropCardData->m_dIdPlayerDrop!=GlobalVariable::m_pUser->m_dId)
        {
            if(GlobalVariable::m_bAlreadyGetCard==true)
            {
                GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards -= dropCardData->m_sNumberCardDrop;
                m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
                CCLOG("%d",GlobalVariable::m_iTotalFiredCard);
                pnlTableArea->removeChildByName(ccsf("card%d",GlobalVariable::m_iTotalFiredCard-1));
                GlobalVariable::m_iTotalFiredCard+=1;
            }
            else
            {
                GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards -= dropCardData->m_sNumberCardDrop;
                GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards += 1;
                m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
                GlobalVariable::m_bAlreadyGetCard=true;
            }
        }
    }
    checkU();
}

void TongitsGameScene::onSendCard(Ref* obj)
{
//    GlobalVariable::m_iCountSelectedCard=0;
    
    CMDSendCardDataT* sendCardData=(CMDSendCardDataT*)obj;
    bool check=false;
    
    setActiveButtons(sendCardData->m_dIdGui, false);
    
    //check is my turn
    if(sendCardData->m_dIdGui == GlobalVariable::m_pUser->m_dId)
    {
        for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
        {
            if(sendCardData->m_sidCard == GlobalVariable::m_pUser->m_vCard->at(i)->m_iId)
            {
                GlobalVariable::m_pUser->m_vCard->erase(GlobalVariable::m_pUser->m_vCard->begin() + i);
            }
        }
        displayCards();
        GlobalVariable::m_iTotalCardinHand-=1;
    }
    
    for(int i=0;i<GlobalVariable::m_vPlayersSorted->size();i++)
    {
        if(sendCardData->m_dIdNhan==GlobalVariable::m_vPlayersSorted->at(i)->m_dId)
        {
            //is Me
            if(sendCardData->m_dIdNhan==GlobalVariable::m_pUser->m_dId)
            {
                for(int j=0;j<m_vDroppedCards->size();j++)
                {
                    if(sendCardData->m_dIdNhan==m_vDroppedCards->at(j)->m_dIdPlayer)
                    {
                        if(sendCardData->m_sidPhom==m_vDroppedCards->at(j)->m_iIdPhom)
                        {
                            if(check==false)
                            {
                                Card* card=Card::create(sendCardData->m_sidCard);
                                card->setScale(0.5f);
                                card->setState(CardState::kCardStateKicked);
                                card->setLocalZOrder(sendCardData->m_sidPhom);
                                card->m_iIdPhom=sendCardData->m_sidPhom;
                                pnlPhom[card->m_iIdPhom]->addChild(card);
                                m_vDroppedCards->push_back(card);
                                card->setPositionX(pnlPhom[card->m_iIdPhom]->getContentSize().width+m_vDroppedCards->at(j)->m_iTotalCardDrop*30);
                                m_vDroppedCards->at(j)->m_iTotalCardDrop+=1;
                                for(int k=0;k<GlobalVariable::m_pUser->m_vCard->size();k++)
                                {
                                    if(sendCardData->m_sidCard==GlobalVariable::m_pUser->m_vCard->at(k)->m_iId)
                                    {
                                        GlobalVariable::m_pUser->m_vCard->erase(GlobalVariable::m_pUser->m_vCard->begin()+k);
                                    }
                                }
                            }
                        }
                    }
                }
                //tao khoag cach phom
                if(sendCardData->m_sidPhom==0)
                {
                    int distance=1;
                    relayoutPhom(1,distance);
                    relayoutPhom(2,distance);
                    relayoutPhom(3,distance);
                }
                else if(sendCardData->m_sidPhom==1)
                {
                    int distance=1;
                    relayoutPhom(2,distance);
                    relayoutPhom(3,distance);
                }
                else if (sendCardData->m_sidPhom==2)
                {
                    int distance=1;
                    relayoutPhom(3,distance);
                }
                else if (sendCardData->m_sidPhom==3)
                {
                    
                }
                
                sortCards();
                check=true;
            }
            
            //another player
            if(sendCardData->m_dIdNhan!=GlobalVariable::m_pUser->m_dId)
            {
                for(int j=0;j<m_vDroppedCards->size();j++)
                {
                    if(sendCardData->m_dIdNhan==m_vDroppedCards->at(j)->m_dIdPlayer)
                    {
                        if(sendCardData->m_sidPhom==m_vDroppedCards->at(j)->m_iIdPhom)
                        {
                            if(check==false)
                            {
                                Card* card=Card::create(sendCardData->m_sidCard);
                                card->setScale(0.4f);
                                card->setState(CardState::kCardStateKicked);
                                card->setLocalZOrder(sendCardData->m_sidPhom);
                                pnlPhomPlayer[i]->addChild(card);
                                m_vDroppedCards->push_back(card);
                                card->setPosition(Vec2(pnlPhomPlayer[i]->getContentSize().width+m_vDroppedCards->at(j)->m_iTotalCardDrop*15-230,pnlPhomPlayer[i]->getContentSize().height-40-sendCardData->m_sidPhom*40));
                                m_vDroppedCards->at(j)->m_iTotalCardDrop+=1;
                                for(int k=0;k<GlobalVariable::m_pUser->m_vCard->size();k++)
                                {
                                    if(sendCardData->m_sidCard==GlobalVariable::m_pUser->m_vCard->at(k)->m_iId)
                                    {
                                        GlobalVariable::m_pUser->m_vCard->erase(GlobalVariable::m_pUser->m_vCard->begin()+k);
                                    }
                                }
                            }
                            check=true;
                        }
                    }
                }
            }
        }
    }
    
    for(int i=0;i<GlobalVariable::m_vPlayersSorted->size();i++)
    {
        if(sendCardData->m_dIdGui==GlobalVariable::m_vPlayersSorted->at(i)->m_dId&&sendCardData->m_dIdGui!=GlobalVariable::m_pUser->m_dId)
        {
            GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards -=1;
            m_vUserInfoOthers->at(i)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards);
        }
    }
    checkU();
}

void TongitsGameScene::onChangePot(Ref* obj)
{
    //set money pot
//    bmfPot->setString(TTutil::addDot(ccsf("%ld",GlobalVariable::getInstance()->m_sPot*GlobalVariable::m_cSetDataT->m_iCuoc)));
}

void TongitsGameScene::onClientFinishGame(Ref* obj)
{
    btnEat->setVisible(false);
    btnLook->setVisible(false);
    
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    EndGamePopupT* eP = new EndGamePopupT();
    scene->openPopup(eP);
    
    for(int i = 1; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setTurnEffect(false);
    }
    
    if(GlobalVariable::m_pUser->m_bPlaying)
    {
        GlobalVariable::m_cSetDataT->m_bSpectator = false;
        pnlPlayerAreas[0]->removeAllChildren();
    }
    GlobalVariable::m_cSetDataT->m_bPlaying = false;
    if(GlobalVariable::m_bRequestLogout)
    {
        GlobalVariable::m_bRequestLogout = false;
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
    
    auto deviceSize = Director::getInstance()->getWinSize();
    //    m_pnlCountDown->setVisible(true);
    //    m_bmfCountDown->setVisible(true);
    //    m_bmfCountDown->setString("10");
    showMessage(true, kTEXT_MSG_AUTO_DEAL_CARD);
//    if(m_pnlCountDown->getChildByName("sangvanmoi"))m_pnlCountDown->removeChildByName("sangvanmoi");
//    auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
//    animCountDown->setName("sangvanmoi");
//    animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
//    animCountDown->addAnimation(0, "sangvanmoi", true);
//    m_pnlCountDown->addChild(animCountDown);
    m_fCountTimeLeft = 10.000f;
    unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
    unschedule(schedule_selector(TongitsGameScene::onCountDownTimer));
    schedule(schedule_selector(TongitsGameScene::onCountDownTimer), 1.0f, kRepeatForever, 0.0f);
    
    m_bFinishGame = true;
//    GlobalVariable::m_bGameFinished=true;
    GlobalVariable::m_cSetDataT->m_bPlaying=false;
//    m_vFiredCards->clear();
    GlobalVariable::m_vFiredCards->clear();
    m_vDroppedCards->clear();
//    m_vEatCards->clear();
    btnEat->cleanup();
//    btnPick->cleanup();
    clearCards();
    
    setVisibleGameButtons(false);
    
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleNOCard(false);
    }
    
    for(int i=1;i<3;i++)
    {
        pnlPhomPlayer[i]->removeAllChildren();
    }
    
    for(int i=0;i<4;i++)
    {
        pnlPhom[i]->removeAllChildren();
    }
    
    relayout();
    btnDeck->setVisible(false);
}

void TongitsGameScene::onFireCard(Ref* obj)
{
    checkDraw();
    CMDFireCardDataT* fireCardData = (CMDFireCardDataT*)obj;
    Size deviceSize = Director::getInstance()->getWinSize();
//    int iNOCards = fireCardData->m_vCardId->size();
    m_iCountTurns++;
    // Save fire card ids
    m_v_iAttackerCardId = *(fireCardData->m_vCardId);
    m_attackerHand = CardHelper::getHand(m_v_iAttackerCardId);
    m_attackerHand->retain();
//    int cardHandNO = fireCardData->m_vCardId->size();
//    int NOCardFired = m_vFiredCards->size();
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
        GlobalVariable::m_iTotalCardinHand-=1;
        if(!GlobalVariable::m_cSetDataT->m_bSpectator)
        {
            displayCards();
        }
    }
    
    if(fireCardData->m_dNextTurnId==GlobalVariable::m_pUser->m_dId)
    {
        //enable possible to eat card
        if(GlobalVariable::m_bCanEat==true)
        {
            btnEat->setVisible(true);
            
            Vector<FiniteTimeAction*> actions;
            auto moveto = MoveTo::create(1.5f, Vec2(btnEat->getPosition().x,btnEat->getContentSize().height+440));
            auto moveback = MoveTo::create(0.0f, btnEat->getPosition());
            actions.pushBack(moveto);
            actions.pushBack(moveback);
            
            auto seq=Sequence::create(actions);
            auto rep=RepeatForever::create(seq);
            
            btnEat->runAction(rep);
            GlobalVariable::m_bCanEat=false;
        }
        else
        {
            btnEat->setVisible(false);
            
            //            Vector<FiniteTimeAction*> actions;
            //            auto moveto = MoveTo::create(1.5f, Vec2(btnPick->getPosition().x,btnEat->getContentSize().height+440));
            //            auto moveback = MoveTo::create(0.0f, btnPick->getPosition());
            //            actions.pushBack(moveto);
            //            actions.pushBack(moveback);
            //
            //            auto seq=Sequence::create(actions);
            //            auto rep=RepeatForever::create(seq);
            //
            //            btnPick->runAction(rep);
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
    if((index != 0) || (index == 0 && GlobalVariable::m_cSetDataT->m_bSpectator))
    {
        GlobalVariable::m_vPlayersSorted->at(index)->m_iRemainCards -= fireCardData->m_vCardId->size();
        m_vUserInfoOthers->at(index)->updateNOCardsRemain(GlobalVariable::m_vPlayersSorted->at(index)->m_iRemainCards);
    };
    
    for(int i=0;i<fireCardData->m_vCardId->size();i++)
    {
        Card* card=Card::create(fireCardData->m_vCardId->at(i));
        card->setScale(0.5f);
        card->setState(CardState::kCardStateKicked);
        pnlTableArea->addChild(card);
        CCLOG("%d",GlobalVariable::m_iTotalFiredCard);
        card->setName(ccsf("card%d",GlobalVariable::m_iTotalFiredCard));
//        m_vFiredCards->push_back(card);
        GlobalVariable::m_vFiredCards->push_back(card);
        
        //        if(GlobalVariable::m_vPlayersSorted->at(index)->m_iPlayerArea == 0)
        //        {
        //            auto moveto = MoveTo::create(0.3f, Vec2(pnlTableArea->getContentSize().width/2,pnlTableArea->getContentSize().height/2));
        //            card->runAction(moveto);
        //        }
        //        else
        //        {
        //            card->setPositionX(pnlTableArea->getPositionX()+50);
        //        }
        
        auto moveto = MoveTo::create(0.3f, Vec2(pnlTableArea->getContentSize().width/2,pnlTableArea->getContentSize().height/2));
        card->runAction(moveto);
        //        card->setPosition(Vec2(pnlTableArea->getContentSize().width/2,pnlTableArea->getContentSize().height/2));
        card->setPositionX(pnlTableArea->getContentSize().width/2+5);
        CCLOG("pnlTable contentsize %f",pnlTableArea->getContentSize().width/2+5);
        CCLOG("pnlTable toa do x= %f  y=%f",pnlTableArea->getPositionX(),pnlTableArea->getPositionY());
        CCLOG("card danh toa do x= %f  y=%f",card->getPositionX(),card->getPositionY());
        CCLOG("card danh toa do anchor x= %f  y=%f",card->getAnchorPoint().x,card->getAnchorPoint().y);
        GlobalVariable::m_iTotalFiredCard+=1;
    }
    
    setTurnId(fireCardData->m_dNextTurnId, false);
}

void TongitsGameScene::onStartedGame(Ref* obj)
{
    unschedule(schedule_selector(TongitsGameScene::onCountDownTimer));
    showMessage(false, "");
    m_iCountTurns = 0;
//    m_pnlCountDown->setVisible(false);
//    m_bmfCountDown->setVisible(false);
//    m_bmfCountDown->setString("10");
    pnlGameBar->setVisible(true);
    GlobalVariable::m_cSetDataT->m_bPlaying = true;
    showInvite();
    showItemsRoom();
    CMDStartGameDataT* cmdIgnoreCardData = (CMDStartGameDataT*)obj;
    double iTurnId = cmdIgnoreCardData->m_dNextTurnId;
    btnStart->setVisible(false);
    
    //set money pot
    bmfPot->setString(TTutil::addDot(ccsf("%ld",GlobalVariable::getInstance()->m_sPot*GlobalVariable::m_cSetDataT->m_iCuoc)));
    
    //reset NO cards to 12
    for(int i = 0; i < GlobalVariable::m_vPlayersSorted->size(); i++)
    {
        GlobalVariable::m_vPlayersSorted->at(i)->m_iRemainCards = 12;
    }
    for(int i = 0; i < m_vUserInfoOthers->size(); i++)
    {
        m_vUserInfoOthers->at(i)->setVisibleNOCard(false);
    }
    
    m_attackerHand = nullptr;
    dealCards();
    setTurnId(iTurnId, true);
}

void TongitsGameScene::dealCards()
{
    GlobalVariable::m_bCanU=false;
    GlobalVariable::m_bCanDraw=false;
    GlobalVariable::m_iDeckNo=15;
    bmfDeckNo->setString(ccsf("%i",GlobalVariable::m_iDeckNo));
    GlobalVariable::m_iTotalFiredCard=0;
    btnDeck->setVisible(true);
    btnLook->setVisible(true);
    Size deviceSize = Director::getInstance()->getWinSize();
    Vector<FiniteTimeAction*> actions;
    Card* card = Card::create(0);
    card->setScale(0.4f);
    card->setPosition(pnlTableArea->getContentSize().width / 2, pnlTableArea->getContentSize().height / 2);
    pnlTableArea->addChild(card);
    int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistanceT) / 2;
    Vec2 pos = card->getPosition();
    GlobalVariable::m_pUser->m_vCard->clear();
    
//    for(int i = 0; i < 13; i++)
//    {
//        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
//        {
//            MoveTo* moveto;
//            //is Me
//            if(GlobalVariable::m_vPlayersSorted->at(j)->m_dId == GlobalVariable::m_pUser->m_dId)
//            {
//                auto act4 = CallFunc::create(CC_CALLBACK_0(TongitsGameScene::animFinishMe, this, card, i));
//                moveto = MoveTo::create(0.05f, Vec2(x + i * g_iDistanceT, -100));
//                actions.pushBack(act4);
//            }
//            else
//            {
//                auto act5 = CallFunc::create( CC_CALLBACK_0(TongitsGameScene::animFinishOther, this, card, j, i));
//                moveto = MoveTo::create(0.05f, pnlPlayerAreas[GlobalVariable::m_vPlayersSorted->at(j)->m_iPlayerArea]->getPosition());
//                actions.pushBack(act5);
//            }
//            auto moveback = MoveTo::create(0.0f, pos);
//            actions.pushBack(moveto);
//            actions.pushBack(moveback);
//        }
//    }
//    auto fadeout = FadeOut::create(0.0f);
//    auto act6 = CallFunc::create( CC_CALLBACK_0(TongitsGameScene::finishAction, this, card));
//    actions.pushBack(fadeout);
//    actions.pushBack(act6);
//    auto seq2 = Sequence::create(actions);
//    card->runAction(seq2);
    
    for(int i = 0; i < 13; i++)
    {
        for(int j = 0; j < GlobalVariable::m_vPlayersSorted->size(); j++)
        {
            MoveTo* moveto;
            //is Me
            if(GlobalVariable::m_vPlayersSorted->at(j)->m_dId == GlobalVariable::m_pUser->m_dId)
            {
                if(GlobalVariable::m_vPlayersSorted->at(j)->m_dId==GlobalVariable::m_dIdPlayerStart)
                {
                    auto act4 = CallFunc::create(CC_CALLBACK_0(TongitsGameScene::animFinishMe, this, card, i));
                    moveto = MoveTo::create(0.05f, Vec2(-x + i * 65, -150));
                    actions.pushBack(act4);
                }
                else
                {
                    if(i==12)
                    {
                        
                    }
                    else
                    {
                        auto act4 = CallFunc::create(CC_CALLBACK_0(TongitsGameScene::animFinishMe, this, card, i));
                        moveto = MoveTo::create(0.05f, Vec2(x + i * 65, -150));
                        actions.pushBack(act4);
                    }
                }
            }
            else
            {
                if(GlobalVariable::m_vPlayersSorted->at(j)->m_dId==GlobalVariable::m_dIdPlayerStart)
                {
                    auto act5 = CallFunc::create(CC_CALLBACK_0(TongitsGameScene::animFinishOther, this, card, j,i));
                    actions.pushBack(act5);
                }
                else
                {
                    if(i==12)
                    {
                        
                    }
                    else
                    {
                        auto act5 = CallFunc::create(CC_CALLBACK_0(TongitsGameScene::animFinishOther, this, card, j,i));
                        actions.pushBack(act5);
                    }
                }
            }
            auto moveback = MoveTo::create(0.0f, pos);
            //            actions.pushBack(moveto);
            actions.pushBack(moveback);
        }
    }
    auto fadeout = FadeOut::create(0.0f);
    auto act6 = CallFunc::create( CC_CALLBACK_0(TongitsGameScene::finishAction, this, card));
    actions.pushBack(fadeout);
    actions.pushBack(act6);
    auto seq2 = Sequence::create(actions);
    card->runAction(seq2);
}

void TongitsGameScene::finishAction(Node* node)
{
    node->removeFromParent();
}

void TongitsGameScene::finishWinAction()
{
    if(GlobalVariable::m_pUser->m_bPlaying)
    {
        GlobalVariable::m_cSetDataT->m_bSpectator = false;
        pnlPlayerAreas[0]->removeAllChildren();
    }
    GlobalVariable::m_cSetDataT->m_bPlaying = false;
    if(GlobalVariable::m_bRequestLogout)
    {
        GlobalVariable::m_bRequestLogout = false;
        SFSConnection::getInstance()->joinRoom(GlobalVariable::m_sWaitRoomName);
    }
    
    auto deviceSize = Director::getInstance()->getWinSize();
//    m_pnlCountDown->setVisible(true);
//    m_bmfCountDown->setVisible(true);
//    m_bmfCountDown->setString("10");
    showMessage(true, kTEXT_MSG_AUTO_DEAL_CARD);
    if(m_pnlCountDown->getChildByName("sangvanmoi"))m_pnlCountDown->removeChildByName("sangvanmoi");
    auto animCountDown = spine::SkeletonAnimation::createWithData(ResourceManager::getInstance()->m_aSkeletonRendererCache[kAnimNewSet]->getSkeleton()->data);
    animCountDown->setName("sangvanmoi");
    animCountDown->setMix("sangvanmoi", "sangvanmoi", 1.0f);
    animCountDown->addAnimation(0, "sangvanmoi", true);
    m_pnlCountDown->addChild(animCountDown);
    m_fCountTimeLeft = 10.000f;
    unschedule(schedule_selector(TongitsGameScene::onPrgTimer));
    unschedule(schedule_selector(TongitsGameScene::onCountDownTimer));
    schedule(schedule_selector(TongitsGameScene::onCountDownTimer), 1.0f, kRepeatForever, 0.0f);
    
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
    if(GlobalVariable::m_pUser->m_dId == m_dStartId && GlobalVariable::m_cSetDataT->m_bPlaying == false)
    {
        if(GlobalVariable::m_vPlayersSorted->size() > 2)
        {
            btnStart->setVisible(true);
            pnlInvite->setVisible(false);
        }
    }
    
    if(GlobalVariable::m_vPlayers->size() < 3)
    {
        btnStart->setVisible(false);
        pnlInvite->setVisible(true);
    }
}

void TongitsGameScene::animFinishOther(Node* node, int indexUser, int indexCard)
{
    m_vUserInfoOthers->at(indexUser)->updateNOCardsRemain(indexCard + 1);
}

void TongitsGameScene::animFinishMe(Node* node, int indexCard)
{
    Size deviceSize = Director::getInstance()->getWinSize();
    int x = (pnlPlayerAreas[0]->getContentSize().width - 12 * g_iDistanceT) / 2;
    Card* card = Card::create(GlobalVariable::m_pUser->m_vCardId->at(indexCard));
    card->setScale(1.0f);
    GlobalVariable::m_pUser->m_vCard->push_back(card);
    pnlPlayerAreas[0]->addChild(card);
    card->setOpacity(0.0f);
    card->setPosition(Vec2(x + indexCard * g_iDistanceT, kDISTANCE_Y_ALL_CARDS));
    card->m_posOrigin = Vec2(x + indexCard * g_iDistanceT, kDISTANCE_Y_ALL_CARDS);
    Action* fadeto = FadeTo::create(0.2f, 255);
    card->runAction(fadeto);
    
    //enable button
    btnSort->setVisible(true);
}

void TongitsGameScene::clearCards()
{
    pnlTableArea->removeAllChildren();
}

void TongitsGameScene::onCountDownTimer(float dt)
{
//    m_iLastCount = round(m_fCountTimeLeft);
//    m_fCountTimeLeft = m_fCountTimeLeft - dt;
//    m_iCurrentCount = round(m_fCountTimeLeft);
//    if(m_fCountTimeLeft < 0)
//    {
//        m_bmfCountDown->setVisible(false);
//        m_pnlCountDown->setVisible(false);
//        unschedule(schedule_selector(TongitsGameScene::onCountDownTimer));
//        return;
//    }
//    if(m_iLastCount != m_iCurrentCount)
//    {
//        AudioManager::getInstance()->playEffect(kSoundEffectCountDown);
//    }
//    m_bmfCountDown->setString(ccsf("%1.0f", m_fCountTimeLeft));
}

void TongitsGameScene::onUserJoinRoom(Ref* obj)
{
    AudioManager::getInstance()->playEffect(kSoundEffectJoinTable);
    m_bCanJoinRoom = true;
    if(!GlobalVariable::m_cSetDataT->m_bPlaying)
    {
        m_bCanJoinRoom = false;
        joinRoom();
    }
}

void TongitsGameScene::joinRoom()
{
    placePlayers();
    if(GlobalVariable::m_pUser->m_dId == m_dStartId)
    {
        if(GlobalVariable::m_vPlayersSorted->size() > 2)
        {
            btnStart->setVisible(true);
        }
    }
    
    showInvite();
    showItemsRoom();
}

void TongitsGameScene::onUserLeftRoom(Ref* obj)
{
    AudioManager::getInstance()->playEffect(kSoundEffectLeftTable);
    CMDUserDataT* userData = (CMDUserDataT*)obj;
    m_bCanLeftRoom = true;
    leftTTID = userData->m_dUID;
    if(!GlobalVariable::m_cSetDataT->m_bPlaying&&!GlobalVariable::m_cSetDataT->m_bSpectator)
    {
        m_bCanLeftRoom = false;
        leftRoom(leftTTID);
    }
}

void TongitsGameScene::leftRoom(double iTTID)
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
            GlobalVariable::m_cSetDataT->m_bSpectator = false;
        }
        //else resort user
        placePlayers();
    }
    if(GlobalVariable::m_vPlayersSorted->size() ==1)
    {
        GlobalVariable::m_cSetDataT->m_bPlaying = false;
    }
    showInvite();
    showItemsRoom();
    
    //enable start button
    if(GlobalVariable::m_pUser->m_dId == m_dStartId && GlobalVariable::m_cSetDataT->m_bPlaying == false)
    {
        if(GlobalVariable::m_vPlayersSorted->size() > 2)
        {
            btnStart->setVisible(true);
            pnlInvite->setVisible(false);
        }
    }
    
    if(GlobalVariable::m_vPlayers->size() < 3)
    {
        btnStart->setVisible(false);
        pnlInvite->setVisible(true);
    }
}

void TongitsGameScene::placePlayers()
{
    for(int i = 0; i < 3; i++)
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
        for(int i = 0; i < 3; i++)
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
                if(i == 2)
                {
                    pUserInfoOther->setPositionX(pUserInfoOther->getPositionX() - 20);
                }
                GlobalVariable::m_vPlayersSorted->at(i)->m_iPlayerArea = i;
                m_vUserInfoOthers->push_back(pUserInfoOther);
            }
        }
    }
    if(GlobalVariable::m_vPlayers->size() == 1
       || (GlobalVariable::m_vPlayersSorted->at(0)->m_dId == GlobalVariable::m_pUser->m_dId && !GlobalVariable::m_cSetDataT->m_bSpectator))
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

void TongitsGameScene::showInvite()
{
    for (int i = 1; i < 3; i++)
    {
        Button* invite = static_cast<Button*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("btnInvite%d", i)));
        if(invite)invite->setVisible(false);
        Layout* pnlInvite = static_cast<Layout*>(Helper::seekWidgetByName(pnlPlayerAreas[i], ccsf("pnlInvite%d", i)));
        if(pnlInvite)
        {
            if(pnlInvite->getChildByName("sangvanmoi"))pnlInvite->removeChildByName("sangvanmoi");
        }
    }
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_cSetDataT->m_bPlaying)
    {
        for (int i = 1; i < 3; i++)
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

void TongitsGameScene::showItemsRoom()
{
    if(GlobalVariable::m_pUser->m_bHost && !GlobalVariable::m_cSetDataT->m_bPlaying)
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

void TongitsGameScene::showHostUser()
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

void TongitsGameScene::onWaitingList(Ref* obj)
{
    vector<CMDWaitingDataT*>* vWaitingData = (vector<CMDWaitingDataT*>*)obj;
    InvitationPopupT* cfm = new InvitationPopupT(vWaitingData);
    openPopup(cfm);
}

void TongitsGameScene::onExit()
{
    BaseScene::onExit();
}

void TongitsGameScene::update(float dt)
{
    BaseScene::update(dt);
}

//xu ly touch card
bool TongitsGameScene::onCardTouchBegan(Touch* touch, Event* event)
{
    Card* card = static_cast<Card*>(event->getCurrentTarget());
    
    if (card->containsTouchLocation(touch))
    {
        // Select card
        if (m_selectingCard == nullptr)
        {
            m_selectingCard = card;
            m_selectingCard->setName("SelectedCard");
            m_bTouchBeganCard = true;
            
            m_startPos = touch->getLocation();
        }
        // Deselect card
        else if (m_selectingCard == card)
        {
            m_selectingCard->setPosition(m_selectingCard->m_posOrigin);
            m_selectingCard = nullptr;
        }
        // Swap card
        else
        {
            swapCard(m_selectingCard, card);
            m_selectingCard = nullptr;
        }
        
        return true;
    }
    
    return false;
}

void TongitsGameScene::onCardTouchMoved(Touch* touch, Event* event)
{
    if (m_selectingCard == nullptr || !m_bTouchBeganCard) return;
    
    // Move card
    Vec2 targetPos = touch->getLocation();
    m_diffPos = Vec2((targetPos.x - m_startPos.x) / pnlPlayerAreas[0]->getScale(), (targetPos.y - m_startPos.y) / pnlPlayerAreas[0]->getScale());
    
    int iDiff = sqrt(m_diffPos.x*m_diffPos.x + m_diffPos.y*m_diffPos.y);
    if (iDiff < 2) return;
    
    m_bMovingCard = true;
    m_selectingCard->setZOrder(pnlPlayerAreas[0]->getChildrenCount());
    m_selectingCard->setPosition(Vec2(m_selectingCard->m_posOrigin.x + m_diffPos.x, m_selectingCard->m_posOrigin.y + m_diffPos.y));
    
    // Which card be targeted
    m_targetCard = nullptr;
    bool bFound = false;
    for (int i = GlobalVariable::m_pUser->m_vCard->size()-1; i >= 0; i--)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if (card == m_selectingCard) continue;
        if (bFound || !card->containsTouchLocation(touch))
        {
            card->setPosition(card->m_posOrigin);
        }
        else
        {
            card->setPosition(Vec2(card->m_posOrigin.x, card->m_posOrigin.y + 10.0f));
            m_targetCard = card;
            bFound = true;
        }
    }
}

void TongitsGameScene::onCardTouchEnded(Touch* touch, Event* event)
{
    if (m_selectingCard)
    {
        // Moving and swap card
        if (m_targetCard)
        {
            swapCard(m_selectingCard, m_targetCard);
            m_selectingCard = nullptr;
            m_targetCard = nullptr;
        }
        // Just moving/swap card
        else
        {
            // SSCard's not moving, user want select it
            if (!m_bMovingCard)
            {
                Vec2 pos = Vec2(m_selectingCard->m_posOrigin.x, m_selectingCard->m_posOrigin.y + 10.0f);
                m_selectingCard->setPosition(pos);
            }
            // SSCard's moving, user want to cancel 
            else
            {
                m_selectingCard->setPosition(m_selectingCard->m_posOrigin);
                m_selectingCard = nullptr;
            }
            for (int i = 0, l = GlobalVariable::m_pUser->m_vCard->size(); i < l; i++)
            {
                Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
                pnlPlayerAreas[0]->reorderChild(card, i);
            }
        }
    }
    m_bTouchBeganCard = false;
    m_bMovingCard = false;
}

void TongitsGameScene::swapCard(Card* cardA,Card* cardB)
{
    AudioManager::getInstance()->playEffect(kSoundEffectXepBai);
    int indexCardA = -1;
    int indexCardB = -1;
    
    for (int i = 0, l = GlobalVariable::m_pUser->m_vCard->size(); i < l; i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        if (card == cardA) indexCardA = i;
        else if (card == cardB) indexCardB = i;
    }
    
    if (-1 != indexCardA && -1 != indexCardB)
    {
        std::swap(GlobalVariable::m_pUser->m_vCard[indexCardA], GlobalVariable::m_pUser->m_vCard[indexCardB]);
        Vec2 tmpPos = cardA->m_posOrigin;
        MoveTo* moveCardA = MoveTo::create(0.1f, cardB->m_posOrigin);
        MoveTo* moveCardB = MoveTo::create(0.1f, cardA->m_posOrigin);
        cardA->m_posOrigin = cardB->m_posOrigin;
        cardB->m_posOrigin = tmpPos;
        float fRotation = cardA->m_fRotationOrigin;
        cardA->m_fRotationOrigin = cardB->m_fRotationOrigin;
        cardB->m_fRotationOrigin = fRotation;
        cardA->runAction(moveCardA);
        cardB->runAction(moveCardB);
        cardA->runAction(RotateTo::create(0.1f, cardA->m_fRotationOrigin));
        cardB->runAction(RotateTo::create(0.1f, cardB->m_fRotationOrigin));
        
        for (int i = 0, l = GlobalVariable::m_pUser->m_vCard->size(); i < l; i++)
        {
            Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
            pnlPlayerAreas[0]->reorderChild(card, i);
        }
        verifyHand();
    }
    
    addCardsTouchHandler();
}

void TongitsGameScene::addCardsTouchHandler()
{
    for (int i = 0, l = GlobalVariable::m_pUser->m_vCard->size(); i < l; i++)
    {
        Card* card = GlobalVariable::m_pUser->m_vCard->at(i);
        _eventDispatcher->removeEventListenersForTarget(card);
        auto listener = EventListenerTouchOneByOne::create();
        listener->setSwallowTouches(true);
        listener->onTouchBegan = CC_CALLBACK_2(TongitsGameScene::onCardTouchBegan, this);
        listener->onTouchMoved = CC_CALLBACK_2(TongitsGameScene::onCardTouchMoved, this);
        listener->onTouchEnded = CC_CALLBACK_2(TongitsGameScene::onCardTouchEnded, this);
        _eventDispatcher->addEventListenerWithSceneGraphPriority(listener, card);
    }
}

void TongitsGameScene::unselectedCards(cocos2d::Ref *pSender, Widget::TouchEventType type)
{
    if (Widget::TouchEventType::ENDED != type) return;
    CCLOG("unselectedCards: %d numcards: %lu", m_bFinishGame, GlobalVariable::m_pUser->m_vCard->size());
    if(m_bFinishGame) return;
    for(int i = 0; i < GlobalVariable::m_pUser->m_vCard->size(); i++)
    {
        GlobalVariable::m_pUser->m_vCard->at(i)->setState(CardState::kCardStateUngrabbed);
    }
}

void TongitsGameScene::verifyHand()
{

}