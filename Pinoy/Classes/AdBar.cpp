#include "AdBar.h"

int AdBar::MODE_LENGTH = 0;
int AdBar::MODE_SHORT = 1;

AdBar::AdBar(std::string sFile)
{
    m_bLoadedContent = false;
    m_fBarHeight = 60.0f;
    
    // ---------------------------------------------------------
    // Load banner content
    HttpRequest* request = new HttpRequest();
    request->setUrl(kNewsURL);
    request->setRequestType(HttpRequest::Type::GET);
    request->setResponseCallback(CC_CALLBACK_2(AdBar::onLoadContentComplete, this));
    HttpClient::getInstance()->sendImmediate(request);
    request->release();
}

AdBar::~AdBar()
{
    
}

/*************************************************************/
/* @author longnh												 */
/* Start Group logic functions							     */
/*************************************************************/
void AdBar::onLoadContentComplete(HttpClient* sender, HttpResponse* response)
{
    // Request succeed?
    if (!response)
    {
        return;
    }
    
    if (response->getResponseCode() == -1)
    {
        NotificationCenter::getInstance()->postNotification(EVENT_NETWORK_NOT_AVAILBLE, NULL);
        return;
    }
    
    std::vector<char>* l_v_buffer_data = response->getResponseData();
    int i = 0;
    while(l_v_buffer_data->at(i) != '{')
    {
        i++;
    }
    std::string l_s_data(l_v_buffer_data->begin() + i, l_v_buffer_data->end());
    
    rapidjson::Document document;
    document.Parse<0>(l_s_data.c_str());
    
    // Get banner content
    m_bLoadedContent = true;
    Size deviceSize = Director::getInstance()->getWinSize();
    i = 0;
    int l;
    std::string content = "";
    if (document["data"].IsArray())
    {
        l = document["data"].Size();
    }
    
    for (i = 0; i < l; i++)
    {
        content.append(document["data"][i]["label"].GetString());
        content.append(" ");
    }
    auto background = LayerColor::create(Color4B(0, 0, 0, 120));
    background->setContentSize(Size(deviceSize.width, 40));
    m_labelFirst = createLabel(content, deviceSize.width);
    m_labelFirst->setAnchorPoint(Vec2(0, 0.5));
    m_labelFirst->setPosition(Vec2(0, 20));
    m_labelSecond = createLabel(content, deviceSize.width + m_labelFirst->getContentSize().width + 10);
    m_labelSecond->setAnchorPoint(Vec2(0, 0.5));
    m_labelSecond->setPosition(Vec2(0, 20));
    addChild(background);
    addChild(m_labelFirst);
    addChild(m_labelSecond);
    
    // Which mode should be use: short or length
    Size labelSize = m_labelFirst->getContentSize();
    if (labelSize.width < deviceSize.width) m_iMode = AdBar::MODE_SHORT;
    else m_iMode = AdBar::MODE_LENGTH;
    
    // The banner move over left scene and hide in period time (= time passing scene width)
    m_fTargetX = -(m_labelFirst->getContentSize().width);
    
    // Handle on two mode
    if (AdBar::MODE_SHORT == m_iMode)
    {
        m_labelSecond->setVisible(false);
        schedule(schedule_selector(AdBar::onMoveShortMode), 0.0f, kRepeatForever, 1.0f);
    }
    else if (AdBar::MODE_LENGTH == m_iMode)
    {
        m_labelSecond->setVisible(true);
        schedule(schedule_selector(AdBar::onMoveLengthMode), 0.0f, kRepeatForever, 1.0f);
    }
    
    cocos2d::log("Load banner content finish");
}


void AdBar::continueRun()
{
    if (!m_bLoadedContent) return;
    
    if (AdBar::MODE_SHORT == m_iMode)
    {
        unschedule(schedule_selector(AdBar::onMoveShortMode));
        schedule(schedule_selector(AdBar::onMoveShortMode), 0.0f, kRepeatForever, 1.0f);
    }
    else if (AdBar::MODE_LENGTH == m_iMode)
    {
        unschedule(schedule_selector(AdBar::onMoveLengthMode));
        schedule(schedule_selector(AdBar::onMoveLengthMode), 0.0f, kRepeatForever, 1.0f);
    }
}

void AdBar::onMoveShortMode(float dt)
{
    float targetX = m_labelFirst->getPositionX() - 1.0f;
    if (targetX < m_fTargetX)
    {
        targetX = Director::getInstance()->getWinSize().width;
    }
    m_labelFirst->setPositionX(targetX);
}

void AdBar::onMoveLengthMode(float dt)
{
    float fFirstTargetX = m_labelFirst->getPositionX() - 1.0f;
    float fSecondTargetX = m_labelSecond->getPositionX() - 1.0f;
    
    if (fFirstTargetX < m_fTargetX)
    {
        fFirstTargetX = m_labelSecond->getPositionX() + m_labelSecond->getContentSize().width + 10.0f;
    }
    else if (fSecondTargetX < m_fTargetX)
    {
        fSecondTargetX = m_labelFirst->getPositionX() + m_labelFirst->getContentSize().width + 10.0f;
    }
    
    m_labelFirst->setPositionX(fFirstTargetX);
    m_labelSecond->setPositionX(fSecondTargetX);
}
/* End Group logic functions							     */

float AdBar::getBgHeight()
{
    return m_fBarHeight;
}

/*************************************************************/
/* @author longnh												 */
/* Convenient functions										 */
/*************************************************************/
Label* AdBar::createLabel(std::string sContent, float fStartX)
{
    Label* label = Label::create(sContent, "Arial", 24);
    label->setPositionX(fStartX);
    return label;
}
/* End Convenient functions									 */
