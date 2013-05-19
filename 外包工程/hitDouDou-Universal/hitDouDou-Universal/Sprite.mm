//
//  Sprite.m
//  hitDouDou
//
//  Created by YJ Z on 12-9-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"


@implementation Sprite
@synthesize physicsBody = _physicsBody;

#pragma mark b2Vec2 与 CGPoint  互转
- (CGPoint )b2Vec2ConvertToCGPoint:(b2Vec2 )b2{
    return  ccpMult(CGPointMake(b2.x, b2.y), PTM_RATIO);
}
- (b2Vec2)CGPointConvertTob2Vec2:(CGPoint )point{
    return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}
@end
