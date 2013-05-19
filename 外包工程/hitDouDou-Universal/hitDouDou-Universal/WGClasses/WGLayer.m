//
//  WGLayer.m
//  Classes
//
//  Created by ZYJ on 13-1-21.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGLayer.h"

@interface WGLayer(){
}
@end
@implementation WGLayer
//@synthesize soundId = _soundId;
#pragma mark set  get 方法类
//areaTouch 为 空区域 实现点击触发效果，默认在touchEnd中触发
- (NSMutableArray *)areaTouch{
    if (!_areaTouch) {
        _areaTouch = [[NSMutableArray alloc]init];
    }
    return _areaTouch;
}

//cache
- (CCSpriteFrameCache *)cache{
    if (!_cache) {
        _cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    }
    return _cache;
}

//backGroundImage
- (void)setBackGroundImage:(CCSprite *)backGroundImage{
    if (backGroundImage) {
        [self addChild:backGroundImage z:0];
        backGroundImage.position = WinCenter;
    }else{
        [_backGroundImage removeFromParentAndCleanup:YES];
    }
    _backGroundImage = backGroundImage;
}

#pragma mark *****************************
//MARK: plist and png 通用播放序列动画
- (BOOL) pngInPlistOrNot:(NSString *)pngName{
    if ([self.cache spriteFrameByName:[NSString stringWithFormat:@"%@0001.png",pngName]]) {
        return YES;
    }
    else return NO;
}
- (id )animation:(NSString *)string aniTime:(ccTime )time{
    NSMutableArray *animFrams = [NSMutableArray array];
    [animFrams removeAllObjects];
    int fps = 0;
    if ([self pngInPlistOrNot:string]) {
        for (int i = 1; ; i++) {
            CCSpriteFrame *frame = [self.cache spriteFrameByName:[NSString stringWithFormat:@"%@%04d.png",string,i]];
            
            if (!frame) {
                fps  = --i;
                break;
            }
            [animFrams addObject:frame];
        }
    }else {
        for (int i = 1; ; i++) {
            CCTexture2D *texture = [[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"%@%04d.png",string,i]];
            if (!texture) {
                fps  = --i;
                break;
            }
            [animFrams addObject:[CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texture.contentSize.width, texture.contentSize.height)]];
        }
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrams delay:time/fps];
    id animationAct = [CCAnimate actionWithAnimation:animation];
    return animationAct;
}
#pragma mark *****************************

#pragma mark 离散序列帧的动画
CCAnimate *handAnimation(NSString *name,int a[],int length,int fps){
    NSMutableArray *array_ = [NSMutableArray array];
    for (int i= 0; i < length; i++) {
        CCTexture2D *t = [[CCTextureCache sharedTextureCache]addImage:[NSString stringWithFormat:@"%@%04d.png",name,a[i]]];
        CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:t rect:CGRectMake(0, 0, t.contentSize.width, t.contentSize.height)];
        [array_ addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:array_ delay:1.0/fps];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    return animate;
}


#pragma mark 算法类

#pragma mark *****************************
//获取 value 在数组areaTouch中的 index 值
- (int )getValueIndex:(NSValue *)value_{
    return [self.areaTouch indexOfObject:value_];
}
//触摸点  是否在  数组areaTouch对象的 CGRect 中   返回此对象
- (int )layerTouched:(UITouch *)touch_{
    CGPoint touchLocation = [WGDirector curTouchLocation:touch_];
    for (NSValue *value in self.areaTouch) {
        if (CGRectContainsPoint(value.CGRectValue, touchLocation)) {
            return [self getValueIndex:value];
        }
    }
    return -1;// -1  表示 空
}
//默认情况下的 空区域点击触发效果
- (void)defaultAreaTouch:(UITouch *)touch_{
    int index = [self layerTouched:touch_];
    if (index!=-1) {
        [self areaTouchAction:index];
    }
}
#pragma mark *****************************


#pragma mark 对象添加类
#pragma mark *****************************
//根据素材 name 给layer添加精灵
- (WGSprite *)layerAddWGSprite:(NSString *)name_{
    WGSprite *move = [WGSprite spriteWithFile:name_];
    [self addChild:move];
    
    return move;
}
- (WGSprite *)layerAddWGSprite:(NSString *)name_ zOrder:(int )z_{
    WGSprite *move = [WGSprite spriteWithFile:name_];
    [self addChild:move z:z_];
    
    return move;
}
#pragma mark *****************************

#pragma mark 触摸方法
#pragma mark *****************************
//空区域点击具体实现 使用时 重写方法  index_ 为 areaTouch数组中的下标位置
- (void)areaTouchAction:(int )index_{
}
//CCLayer 的触摸方法
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    if (_testingMoveNode) {
        [self touchMoving:_testingMoveNode withUITouch:touch];
    }
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [self defaultAreaTouch:touch];
}
#pragma mark *****************************

#pragma mark *****************************
//对精灵实现 拖动效果
- (void)touchMoving:(CCNode *)node_ withUITouch:(UITouch *)touch_{
    CGPoint touchLocation = [WGDirector curTouchLocation:touch_];
    CGPoint preLocation = [WGDirector preTouchLocation:touch_];
    CGPoint transition = ccpSub(touchLocation, preLocation);
    
    node_.position = ccpAdd(node_.position, transition);
    
    NSLog(@"%d,%d",(int )node_.position.x,(int )node_.position.y);
}
#pragma mark *****************************





#pragma mark dealloc
- (void)dealloc{
    [_areaTouch release];
    _areaTouch = nil;
    self.backGroundImage = nil;
    [super dealloc];
}

@end
