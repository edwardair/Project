//
//  MenuLayer.m
//  hitDouDou-Universal
//
//  Created by 丝瓜&冬瓜 on 13-4-27.
//
//

#import "MenuLayer.h"
#import "GameLayer.h"
#import "GameHelper.h"
@implementation MenuLayer
- (void)playBGMusic{
    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BackGroundMusic.mp3"];
    }
}

- (id)init{
    if (self == [super init]) {
        WGSprite *bg = [WGSprite spriteWithFile:[NSString stringWithFormat:@"MenuBG%@.png",DEVICE]];
        [self addChild:bg];
        bg.anchorPoint = CGPointZero;
        
        CCMenuItem *play = [CCMenuItemFont itemWithString:@"开始游戏" block:^(id sender) {
            [Director pushScene:[CCTransitionCrossFade transitionWithDuration:.5f scene:[GameLayer node]]];
        }];
        play.position = ccp(WinWidth/2, WinHeight/2+100.f);
        CCMenuItem *help = [CCMenuItemFont itemWithString:@"游戏帮助" block:^(id sender) {
            [Director pushScene:[CCTransitionCrossFade transitionWithDuration:.5f scene:[GameHelper node]]];
        }];
        help.position = ccp(WinWidth/2, WinHeight/2);

        
        CCMenu *menu = [CCMenu menuWithItems:play,help, nil];
        [self addChild:menu];
        menu.position = CGPointZero;
        [menu setColor:ccBLACK];
        
        [self playBGMusic];
    }
    return self;
}
- (void)checkGameLevel{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    int lv_ = [defaults integerForKey:@"CurrentLV"];
//    
//    if (lv_ != 1) {
//        
//        NSString *msgSave = [[NSString alloc] initWithFormat:@"当前LV%d,是否从此等级开始游戏 ",lv_];
//        
//        UIAlertView *alertSave =[[UIAlertView alloc]
//                                 initWithTitle:nil
//                                 message:msgSave
//                                 delegate:self
//                                 cancelButtonTitle:@"YES"
//                                 otherButtonTitles:@"LV1",nil];
//        [alertSave show];
//        [alertSave release];
//        [msgSave release];
//    }else{
//        [self.delegate gameFirstStart];
//        [self removeAllChildrenWithCleanup:YES];
//    }
}

- (void)dealloc{
    [super dealloc];
}
@end
