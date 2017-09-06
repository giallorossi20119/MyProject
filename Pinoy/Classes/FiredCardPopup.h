#ifndef __FiredCardPopup__
#define __FiredCardPopup__

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

class FiredCardPopup : public BasePopup
{
public:
	FiredCardPopup();
	~FiredCardPopup();

    static FiredCardPopup* create();
    
	void onOpen();
	void onClose();
	void fillData();
};

#endif