//
//  WGDirector.m
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGDirector.h"

@implementation WGDirector

//屏幕 size
CGSize winSize(){
    return Director.winSize;
}
//屏幕 width
CGFloat winWidth(){
    return winSize().width;
}
//屏幕 height
CGFloat winHeight(){
    return winSize().height;
}
//屏幕 center
CGPoint winCenter(){
    return ccpMult(ccp(winWidth(), winHeight()), .5);
}

//获取 场景 数组
//+(NSMutableArray *)getAllExistScene{
//    return Director.scenesStack;
//}

//给 delegate_ 注册 触摸
+ (void)addTargetedDelegate:(id )delegate_ priority:(int )priority_ swallowsTouches:(BOOL )couldSwallTouches{
    [[Director touchDispatcher] addTargetedDelegate:delegate_ priority:priority_ swallowsTouches:couldSwallTouches];
}

//根据 UITouch 获取触摸点坐标
//当前触摸点
+(CGPoint )curTouchLocation:(UITouch *)touch_{
    CGPoint touchLocation = [touch_ locationInView:[touch_ view]];
    touchLocation = [Director convertToGL:touchLocation];
    return touchLocation;
}
//上次触摸点
+(CGPoint)preTouchLocation:(UITouch *)touch_{
    CGPoint preLocation = [touch_ previousLocationInView:[touch_ view]];
    preLocation = [Director convertToGL:preLocation];
    return preLocation;
}

#pragma mark *****************************
+ (CCTexture2D *)textureWithString:(NSString *)name_{
    return [[CCTextureCache sharedTextureCache] addImage:name_];
}
+ (CCSpriteFrame *)spriteFrameWithString:(NSString *)name_{
    CCTexture2D *t = [self textureWithString:name_];
    return [CCSpriteFrame frameWithTexture:t rect:CGRectMake(0, 0, t.contentSize.width, t.contentSize.height)];
}
+ (CCSpriteFrame *)spriteFrameWithTexutre:(CCTexture2D *)texture{
    return [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)];
}

#pragma mark *****************************


@end
