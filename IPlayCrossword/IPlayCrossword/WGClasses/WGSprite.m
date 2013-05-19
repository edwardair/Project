//
//  WGSprite.m
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGSprite.h"


@implementation WGSprite

- (void)addTarget:(id )target selector:(SEL)selector{
    _target  = target;
    _selector = selector;
    
    _allowTouch = YES;
}
- (void)addTarget:(id )target selector:(SEL)selector withObject:(id )object{
    _target  = target;
    _selector = selector;
    _selectorObj = object;
    
    _allowTouch = YES;
}
- (CGRect)rect
{
	return CGRectMake(-rect_.size.width / 2, -rect_.size.height / 2, rect_.size.width, rect_.size.height);
}

//- (void)onExit
//{
//	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
//	[super onExit];
//}

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    _lastPosition = self.position;

	if ( ![self containsTouchLocation:touch] || !_allowTouch)
        return NO;
    
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _lastPosition = self.position;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_selector) {
        if (_selectorObj)
            [_target performSelector:_selector withObject:_selectorObj];
        else
            [_target performSelector:_selector];
    }
}
- (void)dealloc{
    self.selectorObj = nil;
    self.target = nil;
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super dealloc];
}
@end
