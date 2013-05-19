//
//  用于cocos2d中模拟 重力（可自定义）情况下 的 运动  如：抛物线
//  
//
//  Created by ZYJ on 12-10-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

struct CGSpeed {//cocos2d 扩展  速度 结构体
    CGFloat x;
    CGFloat y;
};
typedef struct CGSpeed CGSpeed;

CG_INLINE CGSpeed
CGSpeedMake(CGFloat x, CGFloat y)
{
    CGSpeed s; s.x = x; s.y = y; return s;
}



struct CGGravity {//cocos2d 扩展  重力 结构体
    CGFloat x;
    CGFloat y;
};
typedef struct CGGravity CGGravity;

CG_INLINE CGGravity
CGGravityMake(CGFloat x, CGFloat y)
{
    CGGravity g; g.x = x; g.y = y; return g;
}




@interface c2dMoveWithGravity : CCActionInterval <NSCopying>{
    CGPoint startPosition_;
    CGPoint delta_;
    CGGravity analogGravity_;
    CGSpeed startSpeed_;
    ccTime lastTime_;
}

/** creates the action */
+(id) actionWithDuration:(ccTime)duration speed:(CGSpeed)speed withGravity:(CGGravity )g;
/** initializes the action */
-(id) initWithDuration:(ccTime)duration speed:(CGSpeed)speed withGravity:(CGGravity )g;
@end
