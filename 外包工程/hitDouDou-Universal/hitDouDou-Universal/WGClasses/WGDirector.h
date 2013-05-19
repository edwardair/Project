//
//  WGDirector.h
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#pragma mark define --------
#define Director [CCDirector sharedDirector]

#define WinSize [WGDirector winSize]
#define WinWidth [WGDirector winWidth]
#define WinHeight [WGDirector winHeight]
#define WinCenter [WGDirector winCenter]
#define ApplicationBounds [WGDirector applicationBounds]
#define ApplicationSize [WGDirector applicationSize]

#define RunningScene [Director runningScene]

@interface WGDirector : CCNode {
    
}


+ (CGSize )winSize;
+ (CGFloat )winWidth;
+ (CGFloat )winHeight;
+ (CGPoint )winCenter;
+ (CGRect )applicationBounds;
+(CGSize )applicationSize;

//+(NSMutableArray *)getAllExistScene;
+ (void)addTargetedDelegate:(id )delegate_ priority:(int )priority_ swallowsTouches:(BOOL )couldSwallTouches;
+(CGPoint )curTouchLocation:(UITouch *)touch_;
+(CGPoint)preTouchLocation:(UITouch *)touch_;

+ (CCTexture2D *)textureWithString:(NSString *)name_;//获取 CCTexture2D
+ (CCSpriteFrame *)spriteFrameWithString:(NSString *)name_;//获取 CCSpriteFrame
+ (CCSpriteFrame *)spriteFrameWithTexutre:(CCTexture2D *)texture;

@end

