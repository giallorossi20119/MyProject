#ifndef DartsScore_GoogleAnalyticsTracker_h
#define DartsScore_GoogleAnalyticsTracker_h

#include "cocos2d.h"

class GoogleAnalyticsTracker
{
public:
    static void setup();
    static void sendScreen(const char* screenName);
};

#endif