//
//  WGLayer.h
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WGSprite.h"
#import "WGMenu.h"
#import "WGDirector.h"

@interface WGLayer : CCLayer {
    
}
@property (nonatomic,retain) NSMutableArray *areaTouch;
@property (nonatomic,assign) CCSpriteFrameCache *cache;
@property (nonatomic,retain) CCNode *testingMoveNode;

- (id )animation:(NSString *)string aniTime:(ccTime )time;
CCAnimate *handAnimation(NSString *name,int a[],int length,int fps);

- (WGSprite *)layerAddWGSprite:(NSString *)name_;
- (WGSprite *)layerAddWGSprite:(NSString *)name_ zOrder:(int )z_;

- (void)touchMoving:(CCNode *)node_ withUITouch:(UITouch *)touch_;

@end
