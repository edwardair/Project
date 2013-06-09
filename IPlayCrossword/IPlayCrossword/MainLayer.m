//
//  MainLayer.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "TheStaticGameLayer.h"

#define File(x) [NSString stringWithFormat:@"File%d.png",[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"File%d",x]]]
//m为 状态值  0 题库未做过/ 1 及格/ 2 不及格
//n为 哪套题库  1-10套
#define SetFile(m,n) [[NSUserDefaults standardUserDefaults] setInteger:m forKey:[NSString stringWithFormat:@"File%d",n]]

//mainLayer 只会有一个 所以使用静态类
static MainLayer *staticMainLayer = nil;

@implementation MainLayer
+(MainLayer *)shareStaticMainLayer{
    if (!staticMainLayer) {
        staticMainLayer = [[MainLayer alloc]init];
    }
    return staticMainLayer;
}
- (id )init{
    if (self == [super init]) {
        self.backGroundImage = [CCSprite spriteWithFile:@"B1.png"];
                
//        SetFile(0,1);
//        SetFile(0,2);
//        SetFile(0,3);
//        SetFile(0,4);
//        SetFile(0,5);
//        SetFile(0,6);
//        SetFile(0,7);
//        SetFile(0,8);
//        SetFile(0,9);
//        SetFile(0,10);
        
        CCSprite *title = [CCSprite spriteWithFile:@"Title.png"];
        [self addChild:title];
        title.position = ccp(WinWidth/2, WinHeight-title.contentSize.height/2);
        
        for (int i = 1; i < 11; i++) {
            WGSprite *file = [WGSprite spriteWithFile:File(i)];
            [self addChild:file];
            file.tag = i;
            file.position = ccp( WinWidth/2 + 100*(i%3-1) , WinHeight/2 + (WinHeight>480?160:110) - (100*(i-1)/3) );
            file.scale = .6f;
//            [WGDirector addTarg/etedDelegate:file priority:0 swallowsTouches:YES];
            [file addTarget:self selector:@selector(filePressed:) withObject:file];
        }
                
    }
    return self;
}
- (void)filePressed:(WGSprite *)file{
    [Director replaceScene:[CCTransitionMoveInR transitionWithDuration:.5f scene:[TheStaticGameLayer initWithIndex:file.tag]]];
}

//重置file所显示的样式  未做过、及格、不及格
- (void)resetFilesStyle{
    for (int i = 1; i < 11; i++) {
        WGSprite *file = (WGSprite *)[self getChildByTag:i];
        CCSpriteFrame *frame = [WGDirector spriteFrameWithString:File(i)];
        [file setDisplayFrame:frame];
    }
}
@end
