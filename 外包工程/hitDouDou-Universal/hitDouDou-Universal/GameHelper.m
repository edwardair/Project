//
//  GameHelper.m
//  hitDouDou-Universal
//
//  Created by 丝瓜&冬瓜 on 13-4-27.
//
//

#import "GameHelper.h"
#import "WGCocos2d.h"
@interface GameHelper(){
    UIView *bootView;
    UIScrollView *s;
    UITextView *text;
}
@end
@implementation GameHelper
- (id)init{
    if (self == [super init]) {
        WGSprite *bg = [WGSprite spriteWithFile:[NSString stringWithFormat:@"HelpBG%@.png",DEVICE]];
        self.backGroundImage = bg;
        self.backGroundImage.anchorPoint = ccp(0, 1);
        self.backGroundImage.position = ccp(0, WinHeight);
        
        bootView = [Director view];
        float width = WinWidth-100;
        float height = WinHeight-180;

        s = [[UIScrollView alloc]initWithFrame:CGRectMake(WinWidth/2-width/2, WinHeight/2-height/2-60, width, height)];
        [bootView addSubview:s];
        s.scrollEnabled = YES;
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.bounces = YES;
        s.contentSize = CGSizeMake(0, s.frame.size.height+1);
        s.clipsToBounds = NO;
        
        text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, s.frame.size.width, s.frame.size.height)];
        [s addSubview:text];
        text.text = @"    利用四周墙壁的反弹，将团子打到合适的位置，达到3个以上同色消除。如果射击后未达到消除目的，可是会受到点小小惩罚的哦！\n    游戏中，如果觉得瞄不准，可以开启超级无限瞄准线来辅助射击，也可以依靠瞄准线来玩花样击中目标（ps：为了游戏平衡性，瞄准线的使用上会有限制，各种玩法请在游戏中慢慢体会摸索吧）";
        text.textColor = [UIColor blackColor];
        text.userInteractionEnabled = NO;
        text.textAlignment = UITextAlignmentLeft;
        text.font = [UIFont systemFontOfSize:15.f];
        text.backgroundColor = [UIColor clearColor];
        
        [s release];
        [text release];
        
        s.alpha = 0;
        [UIView animateWithDuration:.5f animations:^{
            s.alpha = 1;
        }];
        
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"Back-iPhone.png" selectedImage:@"Back_-iPhone.png" block:^(id sender) {
            [self callBack];
        }];
        CCMenu *backM = [CCMenu menuWithItems:back, nil];
        [self addChild:backM z:10];
        backM.position = ccp(back.contentSize.width/2,back.contentSize.height/2);

    }
    return self;
}
- (void)dealloc{
    NSLog(@"释放");
    [super dealloc];
}
//返回主菜单
- (void)callBack{
    [s removeFromSuperview];
    s = nil;
    [text removeFromSuperview];
    text = nil;

    [Director popScene];
}
@end
