#ifndef ADBAR_H
#define ADBAR_H

#include <iostream>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "Constant.h"
#include "CocosGUI.h"
#include "HttpRequest.h"
#include "HttpClient.h"
#include "rapidjson.h"
#include "document.h"
#include "EventConst.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_UI;
USING_NS_NET;

class AdBar : 
	public Layer
{
public:
	static int MODE_LENGTH;
	static int MODE_SHORT;

	AdBar(std::string sContent);
	~AdBar();

	float getBgHeight();
	void continueRun();
private:
	void onMoveShortMode(float dt);
	void onMoveLengthMode(float dt);
	void onLoadContentComplete(HttpClient* sender, HttpResponse* response);
	Label* createLabel(std::string sContent, float fStartX);

	DrawNode* m_drawNodeBg;
	Label* m_labelFirst;
	Label* m_labelSecond;
	float m_fTargetX;
	float m_fBarHeight;
	int m_iMode;
	int m_bLoadedContent;
};


#endif // !ADBAR_H
