#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <StoreKit/StoreKit.h>

@class RootViewController;

@interface AppController : NSObject <UIApplicationDelegate, GPPSignInDelegate, GPPDeepLinkDelegate> {
    UIWindow *window;
}

@property(nonatomic, readonly) RootViewController* viewController;

@end

