//
//  EndGamePopup.h
//  IndoGame
//
//  Created by longnh on 10/08/14.
//
//


#ifndef __IndoGame__EndGamePopup__
#define __IndoGame__EndGamePopup__

#include <iostream>
#include "BaseScene.h"

class EndGamePopup : public BasePopup
{
public:
	EndGamePopup();
	~EndGamePopup();

	void onOpen();
	void onClose();
	void fillData();
    void fillDataSS();
    void changeLanguage(Ref* obj);
    void setTextLanguage();
};

#endif
