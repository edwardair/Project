//
//  creatNewBall.h
//  打豆豆
//
//  Created by Wei Haoyu on 12-5-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Sprite.h"
#import "AppDelegate.h"

#define UnEffectCrashType   0
#define EffectCrashType     1
#define removeWithNonEffect 2

@interface creatBallSprite : Sprite {
    int _kBallEnum;
    BOOL _isLocked;
}
@property (nonatomic,assign) int kBallEnum;
@property (nonatomic,assign) BOOL isLocked;
@property (nonatomic,assign) b2World *world;
@property (nonatomic,assign) BOOL didSticked;
@property (nonatomic,assign) BOOL isFlaged;
@property (nonatomic,assign) int removeEffect;
+ (id)createBall:(CCNode *)node withWorld:(b2World *)world;
- (void)creatPhysics;
- (void)removeWithType:(int )type;
@end

