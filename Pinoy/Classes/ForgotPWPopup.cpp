#include "ForgotPWPopup.h"

std::string ForgotPWPopup::ON_CONFIRM = "confirm";
std::string ForgotPWPopup::ON_CANCEL = "cancel";


/*************************************************************/
/* @author longnh												 */
/* Constructor/Destructor functions							 */
/*************************************************************/
ForgotPWPopup::ForgotPWPopup()
{
}

ForgotPWPopup::ForgotPWPopup(std::string sMsr)
{
	m_sMsr = sMsr;
}

ForgotPWPopup::~ForgotPWPopup()
{
}

ForgotPWPopup* ForgotPWPopup::create()
{
	ForgotPWPopup* popup = new ForgotPWPopup();
	popup->autorelease();
	return popup;
}
ForgotPWPopup* ForgotPWPopup::create(std::string sMsr)
{
	ForgotPWPopup* popup = new ForgotPWPopup(sMsr);
	popup->autorelease();
	return popup;
}
/* END CONSTRUCTOR/DESTRUCTOR FUNCTIONS						 */


/*************************************************************/
/* @author longnh												 */
/* Start pragma onOpen/onClose functions					 */
/*************************************************************/
void ForgotPWPopup::onOpen()
{
	BasePopup::onOpen();
	Size deviceSize = Director::getInstance()->getWinSize();
	m_pLayout = dynamic_cast<Layout*>(cocostudio::GUIReader::getInstance()->widgetFromJsonFile("ForgotPWPopup.json"));
	m_pLayout->setAnchorPoint(Vec2(0.5f, 0.5f));
	m_pLayout->setPosition(Vec2(deviceSize.width/2, deviceSize.height/2));
	this->addChild(m_pLayout);

    m_bmfTitle = static_cast<TextBMFont*>(Helper::seekWidgetByName(m_pLayout, "bmfTitle"));
	m_btnCancel = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnCancel"));
	m_btnCancel->addTouchEventListener(CC_CALLBACK_2(ForgotPWPopup::onTouchCancel, this));
	m_btnConfirm = static_cast<Button*>(Helper::seekWidgetByName(m_pLayout, "btnSend"));
	m_btnConfirm->addTouchEventListener(CC_CALLBACK_2(ForgotPWPopup::onTouchConfirm, this));
	m_txtEmail = static_cast<TextField*>(Helper::seekWidgetByName(m_pLayout, "txtEmail"));
	fadeInContent();
    NotificationCenter::getInstance()->addObserver(this, callfuncO_selector(ForgotPWPopup::changeLanguage), EVENT_LANGUAGE_CHANGE, nullptr);
    setTextLanguage();
    setLightPosition();
}

void ForgotPWPopup::onClose()
{
	BasePopup::onClose();
}
/* END PRAGMA ONOPEN/ONCLOSE FUNCTIONS						 */


/*************************************************************/
/* @author longnh												 */
/* Start pragma event handlers functions					 */
/*************************************************************/
void ForgotPWPopup::onTouchCancel(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(ForgotPWPopup::ON_CANCEL);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closePopup(this);
}

void ForgotPWPopup::onTouchConfirm(Ref* pSender, Widget::TouchEventType type)
{
	if (type != Widget::TouchEventType::ENDED) return;

	getSpecialEventDispatcher()->dispatchCustomEvent(ForgotPWPopup::ON_CONFIRM);
    BaseScene* scene = static_cast<BaseScene*>(Director::getInstance()->getRunningScene());
    scene->closePopup(this);
}

void ForgotPWPopup::changeLanguage(Ref* obj)
{
    setTextLanguage();
}

void ForgotPWPopup::setTextLanguage()
{
    m_bmfTitle->setString(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
    //m_btnCancel->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CANCEL));
    //m_btnConfirm->setTitleText(ResourceManager::getInstance()->getTextByName(kTEXT_CONFIRM));
}
/* END PRAGMA EVENT HANDLERS FUNCTIONS					     */
