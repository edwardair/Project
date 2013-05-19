//
//  CGHelper.h
//  hitDouDuo_iPhone
//
//  Created by ZYJ on 12-9-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject {
//    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}
@property (assign, readonly) BOOL gameCenterAvailable;
+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
@end
