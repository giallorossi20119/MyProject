#include "ImageLoader.h"


/*************************************************************/
/* @author longnh												 */
/* Constructor/Destructor functions 						 */
/*************************************************************/
ImageLoader::~ImageLoader()
{
	removeAllChildrenWithCleanup(true);
	if (m_pImage)   m_pImage->release();
	if (m_pLoading) m_pLoading->release();
	if (m_pRequest) m_pRequest->release();
}
ImageLoader::ImageLoader()
{
	m_pImage = nullptr;
	m_pRequest = nullptr;
	m_pLoading = nullptr;
	m_sizeMax = Size(0.0f, 0.0f);
}
ImageLoader* ImageLoader::create()
{
	ImageLoader* loader = new ImageLoader();
	if (loader->init())
	{
		loader->autorelease();
		return loader;
	}
	else
	{
		CC_SAFE_DELETE(loader);
		return NULL;
	}
}
/* END CONSTRUCTOR FUNCTIONS								 */		


/*************************************************************/
/* @author longnh												 */
/* Handle load image functions								 */ 
/*************************************************************/
void ImageLoader::loadImage(const char* filePath)
{
	// This function should call one and only one!
	if (m_pLoading) return;

	m_pLoading = Sprite::create("loadingicon.png");
	addChild(m_pLoading);
	m_pLoading->setScale(0.5f);
	m_pLoading->setAnchorPoint(Vec2(0.5f, 0.5f));
	RotateBy* rotateAct = RotateBy::create(0.1f, -72.0f);
	m_pLoading->runAction(RepeatForever::create(rotateAct));

	m_pRequest = new HttpRequest();
	m_pRequest->setRequestType(HttpRequest::Type::GET);
	m_pRequest->setResponseCallback(this, httpresponse_selector(ImageLoader::onResponseLoadImage));
	m_pRequest->setUrl(filePath);
	HttpClient::getInstance()->sendImmediate(m_pRequest);
}

void ImageLoader::onResponseLoadImage(HttpClient* sender, HttpResponse* response)
{
	//TODO handle response error while loading image 
	if (!response->isSucceed()) return;

	// Remove preloading (graphic and animation)
	removeAllChildrenWithCleanup(true);

	// Get image buffer data
	std::vector<char>* buffer = response->getResponseData();
	Image* image = new Image();

	// Create texture from image 
	image->initWithImageData((unsigned char*)&(buffer->front()), buffer->size());
	Texture2D* texture = new Texture2D();
	texture->initWithImage(image);

	// Add the symbol
	m_pImage = Sprite::createWithTexture(texture);
	m_pImage->retain();
	m_pImage->setAnchorPoint(Vec2(0.5f, 0.5f));
	addChild(m_pImage);

	// Scale to fit with max size
	autoScale();
	
	// Realese after finishing with image and texture
	image->release();
	texture->release();
}

void ImageLoader::setMaxSize(Size size)
{
	m_sizeMax = size;
	autoScale();
}

void ImageLoader::autoScale()
{
	if (m_sizeMax.equals(Size(0.0f, 0.0f)) || !m_pImage) return;

	Size sizeImage = m_pImage->getContentSize();
	float targetScale = MIN(m_sizeMax.width / sizeImage.width, m_sizeMax.height / sizeImage.height);

	if (targetScale < 1)
	{
		m_pImage->setScale(targetScale);
	}
}
/* END HANDLE LOAD IMAGE FUNCTIONS 							 */
