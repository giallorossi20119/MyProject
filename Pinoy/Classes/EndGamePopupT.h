#ifndef __EndGamePopup__
#define __EndGamePopup__

#include <iostream>
#include <vector>
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CocosGUI.h"
#include "Constant.h"
#include "cocostudio/CCSGUIReader.h"
#include "cocostudio/CCActionManagerEx.h"
#include "BasePopup.h"
#include "BaseScene.h"

class BasePopup;
class BaseScene;

class EndGamePopupT : public BasePopup
{
public:
	EndGamePopupT();
	~EndGamePopupT();

    static EndGamePopupT* create();
    
	void onOpen();
	void onClose();
	void fillData();
    TextField *result[1000];
    TextField *bet[1000];
};

#endif