//
//  GameMenu.m
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-10-30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameMenuLayer.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"
@implementation GameMenuLayer
@synthesize delegate;

- (void)dealloc{
    [super dealloc];
}

- (id)init{
    if (self == [super init]) {
        
        if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
            [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"BackGroundMusic.mp3"];
        }

        
        CGSize size = [[CCDirector sharedDirector] winSize];
                
        CCMenuItem *playGame = [CCMenuItemImage itemWithNormalImage:[NSString stringWithFormat:@"PlayGame%@.png",DEVICE] selectedImage:[NSString stringWithFormat:@"PlayGame_%@.png",DEVICE] target:self selector:@selector(checkGameLevel)];
        playGame.position = ccp(size.width/2, size.height/2);
        CCMenu *menu = [CCMenu menuWithItems:playGame, nil];
        menu.position = CGPointZero;
        [self addChild:menu];

    }
    return self;
}

- (void)checkGameLevel{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int lv_ = [defaults integerForKey:@"CurrentLV"];
    
    if (lv_ != 1) {
        
        NSString *msgSave = [[NSString alloc] initWithFormat:@"当前LV%d,是否从此等级开始游戏 ",lv_];
        
        UIAlertView *alertSave =[[UIAlertView alloc]
                                 initWithTitle:nil
                                 message:msgSave
                                 delegate:self
                                 cancelButtonTitle:@"YES"
                                 otherButtonTitles:@"LV1",nil];
        [alertSave show];
        [alertSave release];
        [msgSave release];
    }else{
        [self.delegate gameFirstStart];
        [self removeAllChildrenWithCleanup:YES];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%d",buttonIndex);
    if (buttonIndex ==1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"CurrentLV"];
    }
    
    [self.delegate gameFirstStart];
    [self removeAllChildrenWithCleanup:YES];
}
@end
