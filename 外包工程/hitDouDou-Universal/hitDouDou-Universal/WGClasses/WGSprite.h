//
//  WGSprite.h
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum kType_Touch:NSUInteger{
    kType_Began,
    kType_Moved,
    kType_Ended,
} kType_Touch;


@interface WGSprite : CCSprite<CCTargetedTouchDelegate> {

}

@property (nonatomic,assign) BOOL allowTouch;
@property (nonatomic,assign) CGPoint lastPosition;

@property (nonatomic,assign) SEL selector;
@property (nonatomic,retain) id selectorObj;
@property (nonatomic,retain) id target;

- (void)addTarget:(id )target selector:(SEL)selector;
- (void)addTarget:(id )target selector:(SEL)selector withObject:(id )object;
@end

