/****************************************************************************
 Copyright (c) 2010 cocos2d-x.org

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "AppController.h"
#import "cocos2d.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "SFSConnection.h"
#import "LoginHandler.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "platform/ios/CCEAGLView-ios.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "RageIAPHelper.h"
#import "ACTReporter.h"
#import "GoogleAnalyticsTracker.h"

@implementation AppController

#pragma mark -
#pragma mark Application lifecycle
@class GTMOAuth2Authentication;
// cocos2d application instance
static AppDelegate s_sharedApplication;
static AppController* me;
static NSString* uDeviceID;

#define kURLPinoyLoginFacebook @"http://ids.pinoygame.net/facebook/login?m=1"
#define kURLPinoyLoginGoogle   @"http://ids.pinoygame.net/google/login?m=1"
#define kURLPinoyLoginDeviceID @"http://ids.pinoygame.net/api/client"
#define kURLPinoyLogout        @"http://ids.pinoygame.net/users/logout"
#define kGoogleClientID          @"496374930911-be2kehkr1qbi3mf19b9usmqth17pieg7.apps.googleusercontent.com"
#define kGoogleServerID          @"496374930911-quqepni67ve4c43e1p9a3onjnpnc36ik.apps.googleusercontent.com"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];

    // Init the CCEAGLView
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                         pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                         depthFormat: cocos2d::GLViewImpl::_depthFormat
                                  preserveBackbuffer: NO
                                          sharegroup: nil
                                       multiSampling: NO
                                     numberOfSamples: 0 ];

    // Use RootViewController manage CCEAGLView
    _viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
    //_viewController.wantsFullScreenLayout = YES;
    _viewController.view = eaglView;

    // Set RootViewController to window
    if ( [[UIDevice currentDevice].systemVersion floatValue] < 6.0)
    {
        // warning: addSubView doesn't work on iOS6
        [window addSubview: _viewController.view];
    }
    else
    {
        // use this method on ios6
        [window setRootViewController:_viewController];
    }

    // GA setup
    GoogleAnalyticsTracker::setup();

    [window makeKeyAndVisible];
    NSUUID *strUniqueIdentifier = [[UIDevice currentDevice] identifierForVendor];
    uDeviceID = [strUniqueIdentifier UUIDString];
    NSLog(@"device id: %@", uDeviceID);
    [uDeviceID retain];
    [[UIApplication sharedApplication] setStatusBarHidden:true];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    me = self;

    // You previously set kClientId in the "Initialize the Google+ client" step
    [GPPSignIn sharedInstance].clientID = kGoogleClientID;

    // Your server's OAuth 2.0 client ID
    [GPPSignIn sharedInstance].homeServerClientID = kGoogleServerID;
    // Uncomment one of these two statements for the scope you chose in the previous step
    [GPPSignIn sharedInstance].scopes = @[kGTLAuthScopePlusLogin];

    //Google plus login
    [GPPSignIn sharedInstance].shouldFetchGooglePlusUser = YES;
    [GPPSignIn sharedInstance].shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    [GPPSignIn sharedInstance].useClientIDForURLScheme = NO;
    // Optional: declare signIn.actions, see "app activities"
    [GPPSignIn sharedInstance].delegate = me;

    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    cocos2d::Director::getInstance()->setDisplayStats(false);
    cocos2d::Application::getInstance()->run();
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandledFB = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];

    // You can add your app-specific url handling code here if needed
    BOOL wasHandledGP = [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    return wasHandledFB && wasHandledGP;
}

//request response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //_responseData = [[NSMutableData alloc] init];

    NSHTTPCookie *cookie;
    NSString* sessionID;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [cookieJar cookies])
    {
        NSLog(@"Login session id1 %@", cookie.name);
        if ([cookie.name isEqualToString:@"SESSa32639e00374d719e31425e62cf17ed3"])
        {
            sessionID = [NSString stringWithFormat:@"%@",[cookie value]];
        }
    }
    NSLog(@"Login session id2 %@", sessionID);
    GlobalVariable::m_sSID  = std::string([sessionID UTF8String]);
    ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
    SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
}

//start login

void loginByDeviceID()
{
    NSLog(@"loginByDeviceID");
    if (uDeviceID != NULL)
    {
        ASIFormDataRequest* requestLogout = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLogout]];
        [requestLogout setCompletionBlock:^{
            ASIFormDataRequest* requestLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLoginDeviceID]];
            NSString* deviceId = [uDeviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
            //0: iPhone; 1: iPad; 2: Android; 3: Tablet
            [requestLogin setPostValue:@"guestMode" forKey:@"action"];
            [requestLogin setPostValue:deviceId forKey:@"device_id"];
            [requestLogin setPostValue:@"0" forKey:@"device_type"];
            [requestLogin setCompletionBlock:^{
                NSData* data = [requestLogin responseData];
                NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"login: %@", returnString);
                NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
                NSString  *sessionID;
                int uid = 0;
                uid = [[jsonDataDict objectForKey:@"uid"] integerValue];
                if (uid != 0)
                {
                    sessionID = [jsonDataDict objectForKey:@"sid"];
                    GlobalVariable::m_sSID  = std::string([sessionID UTF8String]);
                    ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
                    SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
                }
                else
                {
                    //status = 0, dang nhap that bai
                    [[[UIAlertView alloc] initWithTitle:@"loginByDeviceID"
                                                message:@"Login by DeviceID fail!"
                                               delegate:me
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil] show];
                }
            }];
            [requestLogin setFailedBlock:^{
                NSLog(@"loginByDeviceID requestLogin fail 1");
                NSError *error = [requestLogin error];
                NSLog(@"loginByDeviceID requestLogin fail 1 %@", error);
                logoutByFacebook();
                SFSConnection::getInstance()->disconnectToServer();
                SceneManager::getInstance()->switchScene(kSceneLogin);
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [requestLogin startAsynchronous];
            });
        }];
        [requestLogout setFailedBlock:^{
            NSLog(@"loginByDeviceID requestLogout fail 1");
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestLogout startAsynchronous];
        });
    }
    else
    {
        NSLog(@"loginByDeviceID login Error");
    }
}

//login facebook
void loginByFacebook()
{
    NSLog(@"loginByFacebook");
    if (FBSession.activeSession.isOpen)
    {
        [me sendFacebookLogin];
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
         {
             __block NSString *alertText;
             __block NSString *alertTitle;
             if (!error)
             {
                 // If the session was opened successfully
                 if (state == FBSessionStateOpen)
                 {
                     // Your code here
                     [me sendFacebookLogin];

                 }
                 else
                 {
                     // There was an error, handle it
                     if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
                     {
                         // Error requires people using an app to make an action outside of the app to recover
                         // The SDK will provide an error message that we have to show the user
                         alertTitle = @"Something went wrong1";
                         alertText = [FBErrorUtility userMessageForError:error];
                         [[[UIAlertView alloc] initWithTitle:alertTitle
                                                     message:alertText
                                                    delegate:me
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil] show];

                     }
                     else
                     {
                         // If the user cancelled login
                         if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
                         {
                             alertTitle = @"Login cancelled";
                             alertText = @"Your birthday will not be entered in our calendar because you didn't grant the permission.";
                             [[[UIAlertView alloc] initWithTitle:alertTitle
                                                         message:alertText
                                                        delegate:me
                                               cancelButtonTitle:@"OK!"
                                               otherButtonTitles:nil] show];

                         }
                         else
                         {
                             /*
                              // For simplicity, in this sample, for all other errors we show a generic message
                              // You can read more about how to handle other errors in our Handling errors guide
                              // https://developers.facebook.com/docs/ios/errors/
                              NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
                              objectForKey:@"body"]
                              objectForKey:@"error"];
                              alertTitle = @"Something went wrong2";
                              alertText = [NSString stringWithFormat:@"Please retry. \n If the problem persists contact us and mention this error code: %@",
                              [errorInformation objectForKey:@"message"]];
                              [[[UIAlertView alloc] initWithTitle:alertTitle
                              message:alertText
                              delegate:me
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil] show];
                              */
                         }
                     }
                 }
             }
             else
             {
                 NSLog(@"login facebook error");
                 // There was an error, handle it
                 if ([FBErrorUtility shouldNotifyUserForError:error] == YES)
                 {
                     // Error requires people using an app to make an action outside of the app to recover
                     // The SDK will provide an error message that we have to show the user
                     alertTitle = @"Something went wrong3";
                     alertText = [FBErrorUtility userMessageForError:error];
                     [[[UIAlertView alloc] initWithTitle:alertTitle
                                                 message:alertText
                                                delegate:me
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil] show];

                 }
                 else
                 {
                     // If the user cancelled login
                     if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
                     {
                         alertTitle = @"Login cancelled";
                         alertText = @"Your birthday will not be entered in our calendar because you didn't grant the permission.";
                         [[[UIAlertView alloc] initWithTitle:alertTitle
                                                     message:alertText
                                                    delegate:me
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil] show];

                     }
                     else
                     {
                         // For simplicity, in this sample, for all other errors we show a generic message
                         // You can read more about how to handle other errors in our Handling errors guide
                         // https://developers.facebook.com/docs/ios/errors/
                         NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"]
                                                            objectForKey:@"body"]
                                                           objectForKey:@"error"];
                         alertTitle = @"Something went wrong4";
                         alertText = [NSString stringWithFormat:@"Please retry. \n If the problem persists contact us and mention this error code: %@",
                                      [errorInformation objectForKey:@"message"]];
                         [[[UIAlertView alloc] initWithTitle:alertTitle
                                                     message:alertText
                                                    delegate:me
                                           cancelButtonTitle:@"OK!"
                                           otherButtonTitles:nil] show];
                     }
                 }
             }
         }];
    }
}

-(void)sendFacebookLogin
{
    if (FBSession.activeSession.isOpen)
    {
        NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
        NSLog(@"fbAccessToken: %@", fbAccessToken);
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error)
         {
             if (!error)
             {
                 ASIFormDataRequest* requestLogout = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLogout]];
                 [requestLogout setCompletionBlock:^{
                     ASIFormDataRequest* requestLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLoginFacebook]];
                     [requestLogin setPostValue:fbAccessToken forKey:@"access_token"];
                     [requestLogin setCompletionBlock:^{
                         NSData* data = [requestLogin responseData];
                         NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                         NSLog(@"login: %@", returnString);
                         NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
                         NSString  *sessionID;
                         int status = [[jsonDataDict objectForKey:@"status"] integerValue];
                         if (status == 1)
                         {
                             //status = 1, dang nhap thanh cong
                             sessionID = [jsonDataDict objectForKey:@"sid"];
                             GlobalVariable::m_sSID  = std::string([sessionID UTF8String]);
                             ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
                             //add only pusoy
//                             GlobalVariable::m_iCurrentGame = kGameSusun;
//                             GlobalVariable::m_iCurrentZone = 1;
                             SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
                         }
                         if (status == 0)
                         {
                             NSString* message = [jsonDataDict objectForKey:@"message"];
                             string msg = std::string([message UTF8String]);
                             LoginHandler::getInstance()->getAccountFail(msg);
                         }
                     }];
                     [requestLogin setFailedBlock:^{
                         NSError *error    = [requestLogin error];
                         NSString* message = [NSString stringWithFormat:@"%@", error];
                         string msg        = std::string([message UTF8String]);
                         LoginHandler::getInstance()->getAccountFail(msg);
                         logoutByFacebook();
                         SFSConnection::getInstance()->disconnectToServer();
                         SceneManager::getInstance()->switchScene(kSceneLogin);

                     }];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [requestLogin startAsynchronous];
                     });
                 }];
                 [requestLogout setFailedBlock:^{
                     LoginHandler::getInstance()->getAccountFail("Facebook RequestLogout Fail");
                 }];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [requestLogout startAsynchronous];
                 });
             }
             else
             {
                 LoginHandler::getInstance()->getAccountFail("Facebook Login Error");
             }
         }];
    }
}

void logoutByFacebook()
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
}

void loginByGooglePlus()
{
    [[GPPSignIn sharedInstance] authenticate];
}

void logoutByGooglePlus()
{
    [[GPPSignIn sharedInstance] disconnect];
}

void sendIAP(string sku)
{
    NSLog(@"sku: %s", sku.c_str());
    NSString* strSKU = [NSString stringWithFormat:@"%s", sku.c_str()];
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  strSKU,
                                  nil];
    [[RageIAPHelper sharedInstance] initWithProductIdentifiers:productIdentifiers];
    [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products)
     {
         if (success)
         {
             SKProduct *product = nil;
             NSLog(@"success...");
             for(int i = 0; i <  products.count; i++)
             {
                 product = products[i];
                 if([strSKU isEqualToString:product.productIdentifier])
                 {
                     NSLog(@"Buying %@...", product.productIdentifier);
                     [[RageIAPHelper sharedInstance  ] buyProduct:product];
                 }
             }
         }
     }];
}

-(void)sendGooglePlusLogin
{
    NSString* code = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
    NSURL *url = [[NSURL alloc] initWithString:kURLPinoyLoginGoogle];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url
                                                            cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                        timeoutInterval:30] ;
    [req setHTTPShouldHandleCookies:YES];
    [req setHTTPMethod:@"POST"];
    NSMutableData *body = [NSMutableData data];
    NSString *info = [NSString stringWithFormat:@"code=%@", code];
    [body appendData:[[NSString stringWithString:info] dataUsingEncoding:NSUTF8StringEncoding]];
    [req setHTTPBody:body];
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"returnString  %@", returnString);
            NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            NSString  *sessionID;
            int status = [[jsonDataDict objectForKey:@"status"] integerValue];
            if (status == 1)
            {
                //status = 1, dang nhap thanh cong
                sessionID = [jsonDataDict objectForKey:@"sid"];
                GlobalVariable::m_sSID  = std::string([sessionID UTF8String]);
                ZoneData* zoneData = GlobalVariable::m_vGameServerData->at(GlobalVariable::m_iCurrentGame)->m_vZoneArray->at(GlobalVariable::m_iCurrentZone);
                SFSConnection::getInstance()->connectToServer(zoneData->m_sHostIp.c_str(), zoneData->m_iPort);
                [[GPPSignIn sharedInstance] disconnect];
            }
            if (status == 0)
            {
                //status = 0, dang nhap that bai
                [[[UIAlertView alloc] initWithTitle:@"Google"
                                            message:@"Login Google fail!"
                                           delegate:me
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }

}
/*
 -(void)sendGooglePlusLogin
 {
 NSString* code = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
 NSURL *url = [[NSURL alloc] initWithString:@"http://ids.Pinoy.com/google/login?m=1"];
 //NSURL *url = [[NSURL alloc] initWithString:@"http://thapthanh.com/user/login"];
 NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url
 cachePolicy:NSURLRequestReloadIgnoringCacheData
 timeoutInterval:30] ;
 [req setHTTPShouldHandleCookies:YES];
 [req setHTTPMethod:@"POST"];
 NSMutableData *body = [NSMutableData data];
 NSString *info = [NSString stringWithFormat:@"code=%@", code];
 [body appendData:[[NSString stringWithString:info] dataUsingEncoding:NSUTF8StringEncoding]];
 [req setHTTPBody:body];
 NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
 NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
 NSLog(@"returnString  %@", returnString);}
 */

- (void) finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error) {
        // Do some error handling here.
    } else {
        NSString *serverCode = [GPPSignIn sharedInstance].homeServerAuthorizationCode;
        NSLog(@"finishedWithAuth code %@", serverCode);
        [self sendGooglePlusLogin];
    }
}

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    //NSMutableData* _responseData = [[NSMutableData alloc] init];
    //[_responseData appendData:data];
    //NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    // Print out new string
    //NSLog(@"%@",strData);
}

void loginByAccountBase(string username, string password)
{
    ASIFormDataRequest* requestLogout = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLogout]];
    [requestLogout setCompletionBlock:^{
        ASIFormDataRequest* requestLogin = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kURLPinoyLoginDeviceID]];
        NSString* email = [NSString stringWithFormat:@"%s", username.c_str()];
        NSString* pw = [NSString stringWithFormat:@"%s", password.c_str()];
        //0: iPhone; 1: iPad; 2: Android; 3: Tablet
        NSLog(@"loginAccountBase username: %@ password: %@", email, pw);
        [requestLogin setPostValue:@"login" forKey:@"action"];
        [requestLogin setPostValue:email forKey:@"email"];
        [requestLogin setPostValue:pw forKey:@"password"];
        [requestLogin setCompletionBlock:^{
            NSData* data = [requestLogin responseData];
            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"login: %@", returnString);
            NSDictionary *jsonDataDict = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: nil];
            NSString  *sessionID;
            int uid = 0;
            uid = [[jsonDataDict objectForKey:@"uid"] integerValue];
            if (uid != 0)
            {
                sessionID = [jsonDataDict objectForKey:@"sid"];
                string sid = std::string([sessionID UTF8String]);
                LoginHandler::getInstance()->getAccountSuccessed(sid);
            }
            else
            {
                NSString* message = [jsonDataDict objectForKey:@"message"];
                string msg = std::string([message UTF8String]);
                LoginHandler::getInstance()->getAccountFail(msg);
            }
        }];
        [requestLogin setFailedBlock:^{
            NSError *error    = [requestLogin error];
            NSString* message = [NSString stringWithFormat:@"%@", error];
            string msg        = std::string([message UTF8String]);
            LoginHandler::getInstance()->getAccountFail(msg);
            SFSConnection::getInstance()->disconnectToServer();
            SceneManager::getInstance()->switchScene(kSceneLogin);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestLogin startAsynchronous];
        });
    }];
    [requestLogout setFailedBlock:^{
        LoginHandler::getInstance()->getAccountFail("loginAccountBase requestLogout fail");
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [requestLogout startAsynchronous];
    });
}

void makeCallSupport(std::string number)
{
    NSLog(@"makeCallSupport");
    NSString* phone = [NSString stringWithFormat:@"%s", number.c_str()];
    NSString* phoneNumber = [@"telprompt://" stringByAppendingString:phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

void makeOpenFanpage(std::string url)
{
    NSLog(@"makeOpenFanpage");
    NSString* str    = [NSString stringWithFormat:@"%s", url.c_str()];
    NSURL *fanPageURL = [NSURL URLWithString:@"fb://profile/325655987621702"];
    
    if (![[UIApplication sharedApplication] openURL: fanPageURL]) {
        //fanPageURL failed to open.  Open the website in Safari instead
        NSURL *webURL = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL: webURL];
    }
}

void saveScreenShot(std::string imgSSPath)
{
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString* fileName = [NSString stringWithUTF8String:imgSSPath.c_str()];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage* imgSS = [UIImage imageWithContentsOfFile:filePath];
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

    if (status == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                // INSERT CODE TO PERFORM WHEN USER TAPS OK eg. :
                NSLog(@"Clicked ok");
                UIImageWriteToSavedPhotosAlbum(imgSS, nil, nil, nil);
                return;
            }
            *stop = TRUE;
        } failureBlock:^(NSError *error) {
            // INSERT CODE TO PERFORM WHEN USER TAPS DONT ALLOW, eg. :
            NSLog(@"User dont allow");
            //show alert for asking the user to give permission
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Info"
                                  message: @"You need allow game access Photos by:\n Settings > Privacy > Photos"
                                  delegate: nil
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }];
    }
    else
    {
        UIImageWriteToSavedPhotosAlbum(imgSS, nil, nil, nil);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    //We don't need to call this method any more. It will interupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->pause(); */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    //We don't need to call this method any more. It will interupt user defined game pause&resume logic
    /* cocos2d::Director::getInstance()->resume(); */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    cocos2d::Application::getInstance()->applicationDidEnterBackground();
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
    cocos2d::Application::getInstance()->applicationWillEnterForeground();
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
