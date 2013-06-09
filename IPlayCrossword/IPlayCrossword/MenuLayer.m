//
//  MenuLayer.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MenuLayer.h"
#import "TheStaticGameLayer.h"
#import "MainLayer.h"
#define Small_Count(x) [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"Small_%d",x]]
#define Big_Count(x) [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"Big_%d",x]]
#define SubSmall(x) [[NSUserDefaults standardUserDefaults] setInteger:(Small_Count(x)-1) forKey:[NSString stringWithFormat:@"Small_%d",x]]
#define SubBig(x) [[NSUserDefaults standardUserDefaults] setInteger:(Big_Count(x)-1) forKey:[NSString stringWithFormat:@"Big_%d",x]]

@implementation MenuLayer
@synthesize delegate;
+(id )initializeWithIndex:(int )index{
    return [[[[self class] alloc]initWithNumber:index] autorelease]  ;
}
- (id )initWithNumber:(int )index{
    if (self == [super init]) {
        
        __block CCMenuItemFont *menu;
        
        WGSprite *menuSprite = [WGSprite spriteWithFile:@"MenuSprite.png"];
        [self addChild:menuSprite z:1];
        menuSprite.anchorPoint = ccp(0, 1);
        menuSprite.position = ccp(0, WinHeight);
        menuSprite.scale= 0;
        
        {//加载在menuSprite上的menuFonts
            CCMenuItemFont *mainMenu = [CCMenuItemFont itemWithString:@"主菜单" block:^(id sender) {
//                [[[TheStaticGameLayer shareGameLayer] answerInterface] loadView].hidden = YES;
                
                [Director replaceScene:[CCTransitionMoveInL transitionWithDuration:.5f scene:[MainLayer node]]];
//                [TheStaticGameLayer unShareTheStaticGameLayer];
            }];
            mainMenu.position = ccp(menuSprite.contentSize.width/2, menuSprite.contentSize.height/2+30);

            CCMenuItemFont *save = [CCMenuItemFont itemWithString:@"保存" block:^(id sender) {
                menu.isEnabled = YES;
                [self.delegate saveCurPuzzleWithIndex:index];
                [menuSprite runAction:[CCScaleTo actionWithDuration:.5f scale:0]];
            }];
            
            save.position = ccp(menuSprite.contentSize.width/2, menuSprite.contentSize.height/2);

            CCMenuItemFont *submit = [CCMenuItemFont itemWithString:@"交卷" block:^(id sender) {
                menu.isEnabled = YES;

                [self.delegate submitPuzzle];
                [menuSprite runAction:[CCScaleTo actionWithDuration:.5f scale:0]];
            }];
            submit.position = ccp(menuSprite.contentSize.width/2, menuSprite.contentSize.height/2-30);

            CCMenu *menuParent = [CCMenu menuWithItems:mainMenu,save,submit, nil];
            [menuSprite addChild:menuParent];
            menuParent.color = ccBLACK;
            menuParent.position = CGPointZero;
        }
        
        menu = [CCMenuItemFont itemWithString:@"菜单" block:^(id sender) {
            menu.isEnabled = NO;
            [menuSprite runAction:[CCScaleTo actionWithDuration:.5f scale:1]];
        }];
        menu.anchorPoint = CGPointMake(0, 1);
        menu.position = ccp(0, WinHeight);
        menu.scale = .7f;
        
        CCMenuItemFont *xiaoChao = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"小抄%d",Small_Count(index)] block:^(id sender) {
            //TODO: 显示小抄
            if (Small_Count(index)>0) {
                SubSmall(index);
                [sender setString:[NSString stringWithFormat:@"小抄%d",Small_Count(index)]];
                [self.delegate showXiaoChao];
            }
        }];
        xiaoChao.anchorPoint = CGPointMake(0, 1);
        xiaoChao.position = ccp(100, WinHeight);
        xiaoChao.scale = .7f;

        CCMenuItemFont *daChao = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"大抄%d",Big_Count(index)] block:^(id sender) {
            //TODO: 显示大抄
            if (Big_Count(index)) {
                SubBig(index);
                [sender setString:[NSString stringWithFormat:@"大抄%d",Big_Count(index)]];
                [self.delegate showDaChao];
            }
        }];
        daChao.anchorPoint = CGPointMake(0, 1);
        daChao.position = ccp(200, WinHeight);
        daChao.scale = .7f;

        
        CCMenu *menus = [CCMenu menuWithItems:menu,xiaoChao,daChao, nil];
        [self addChild:menus];
        menus.position = CGPointZero;
        menus.color = ccBLACK;
    }
    return self;
}
//- (void)popCurScene{
////    [[[TheStaticGameLayer shareGameLayer] answerInterface] loadView].hidden = YES;
//    for (UIView *subView in [[[TheStaticGameLayer shareGameLayer] answerInterface] loadView].subviews) {
//        [subView removeFromSuperview];
//        [subView release];
//        subView = nil;
//    }
//    [Director popScene];
//
//}
- (void)dealloc{
    
    [super dealloc];
}
@end
