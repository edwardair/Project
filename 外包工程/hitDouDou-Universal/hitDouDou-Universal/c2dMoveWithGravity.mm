//
//  UserDefinedAction.m
//  UserDefined_ActionInterval
//
//  Created by ZYJ on 12-10-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "c2dMoveWithGravity.h"
#define PTM_RATIO 32.0
@implementation c2dMoveWithGravity
+(id )actionWithDuration:(ccTime)t speed:(CGSpeed)speed  withGravity:(CGGravity )g{
    return [[[self alloc]initWithDuration:t speed:speed withGravity:g] autorelease];
}
- (id)initWithDuration:(ccTime)t speed:(CGSpeed)speed  withGravity:(CGGravity )g{
    if( (self=[super initWithDuration: t]) ){
        startSpeed_ = speed;
        lastTime_ = t;
        analogGravity_ = g;
        
    }
	return self;
    
    
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] speed:startSpeed_ withGravity:analogGravity_];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	startPosition_ = [(CCNode*)target_ position];

}

-(void) update: (ccTime) t
{
    ccTime deltaTime_ = t*lastTime_;

	[target_ setPosition: ccp( (startPosition_.x + (startSpeed_.x * 32 + .5 * analogGravity_.x * 32 *deltaTime_) * deltaTime_ ), (startPosition_.y + (startSpeed_.y * PTM_RATIO + .5 * analogGravity_.y * PTM_RATIO *deltaTime_) * deltaTime_ ) )];
}

@end
