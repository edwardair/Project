//
//  OpenRayCast.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class GameLabel;
#define CURCOUNT [[NSUserDefaults standardUserDefaults] integerForKey:@"TotalRemain"]
#define USED [defaults integerForKey:@"TotalUsed"]
#define ADD [defaults setInteger:CURCOUNT+1 forKey:@"TotalRemain"]
#define SUB [defaults setInteger:CURCOUNT-1 forKey:@"TotalRemain"]
#define USEDADD [defaults setInteger:USED+1 forKey:@"TotalUsed"]
#define OPEN [[NSUserDefaults standardUserDefaults] boolForKey:@"OC"]
#define SETOC [defaults setBool:OPEN?NO:YES forKey:@"OC"]
#define OpenRayCastTag 88888
@interface OpenRayCast : CCLayer {
    
}
@property (nonatomic,retain) GameLabel *labelLayer;
- (void)subCount;
@end
