#ifndef IMAGE_LOADER_H
#define IMAGE_LOADER_H

#include "cocos2d.h"
#include "cocos-ext.h"
#include "Constant.h"
#include "HttpClient.h"

USING_NS_CC;
USING_NS_CC_EXT;
USING_NS_NET;

class ImageLoader : 
	public Sprite
{
public:
	ImageLoader();
	~ImageLoader();

	static ImageLoader* create();
	void loadImage(const char* filePath);
	void setMaxSize(cocos2d::Size size);
	void autoScale();
private:
	void onResponseLoadImage(HttpClient* sender, HttpResponse* response);

	HttpRequest* m_pRequest;
	Sprite* m_pImage;
	Sprite* m_pLoading;
	cocos2d::Size m_sizeMax;
};


#endif // !IMAGE_LOADER_H
