#include "Toast.h"

/*************************************************************/
/* @author longnh												 */
/* Constructor/Destructor functions							 */
/*************************************************************/
Toast::Toast(std::string sMessenger)
{
    cocos2d::extension::Scale9Sprite* background = cocos2d::extension::Scale9Sprite::create("toast.png", Rect(0, 0, 64, 64), Rect(10, 10, 44, 44));
    Text* tfContent  = Text::create(sMessenger, "Arial", 24);
	this->addChild(background);
	this->addChild(tfContent);
    background->setOpacity(220);
	Size sizeContent = tfContent->getContentSize();
    Size sizeBg = background->getContentSize();
    background->setContentSize(Size(sizeContent.width + 40, 80));
}

Toast::~Toast(){}

Toast* Toast::create(const std::string sMessenger)
{
	Toast* toast = new Toast(sMessenger);
	toast->autorelease();
	return toast;
}
/* END CONSTRUCTOR/DESTRUCTOR FUNCTIONS */
