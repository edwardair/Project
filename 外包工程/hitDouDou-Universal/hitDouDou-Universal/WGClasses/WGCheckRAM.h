//
//  HelloWorldLayer.h
//  内存检测
//
//  Created by YJ Z on 12-9-6.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "WGCocos2d.h"
#include <sys/sysctl.h>
#include <mach/mach.h>

// HelloWorldLayer
@interface WGCheckRAM : CCLayer {
    CCLabelTTF *label;
}

@end
