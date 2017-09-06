#ifndef IMAGE_LOADER_H
#define IMAGE_LOADER_H

#include "cocos2d.h"
#include "cocos-ext.h"
#include "Constant.h"
#include "HttpClient.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_NET;

class ImageLoader : public Sprite
{
public:
	ImageLoader();
	~ImageLoader();

	static ImageLoader* create();
	void loadImage(std::string filePath, int type = 0);
	void setMaxSize(cocos2d::Size size);
	void autoScale();
    void setImage(Texture2D* texture);
private:
	void onResponseLoadImage(HttpClient* sender, HttpResponse* response);
    std::string m_sPath;
	HttpRequest* m_pRequest;
	Sprite* m_pImage;
	Sprite* m_pLoading;
	cocos2d::Size m_sizeMax;
};


#endif // !IMAGE_LOADER_H
