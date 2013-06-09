//
//  WGDirector.h
//  Learn
//
//  Created by Apple on 13-6-5.
//
//

#ifndef __Learn__WGDirector__
#define __Learn__WGDirector__

#include "cocos2d.h"

#define Director CCDirector::sharedDirector()
#define WinSize WGDirector::winSize();
#define WinCenterX WGDirector::winCenterX();
#define WinCenterY WGDirector::winCenterY();
#define WinCenter WGDirector::WinCenter();

using namespace cocos2d;

class WGDirector :public cocos2d::CCNode{
public:
    static CCSize winSize();
    static float winCenterX();
    static float winCenterY();
    static CCPoint winCenter();
    
    static CCTexture2D *textureWithCString(const char *stringName);
    static CCSpriteFrame *spriteFrameWithCString(const char *stringName);
    static CCSpriteFrame *spriteFrameWithTexture(CCTexture2D *texture);
    
};

#endif /* defined(__Learn__WGDirector__) */
