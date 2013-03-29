//
//  GryBackGroundColorView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "GrayBackGroundColorView.h"

@implementation GrayBackGroundColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    if (self) {
        // Initialization code
//        self.backgroundColor = [UIColor grayColor];
//        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideSelf)];
    }
    return self;
}
- (void)hideSelf{
    self.hidden = YES;
}
- (void)showSelf{
    //TODO: 弹出窗口
//    [UIView ani]
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.frame = [[UIScreen mainScreen] applicationFrame];
    self.backgroundColor = [UIColor grayColor];
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSlef)];
    [self addGestureRecognizer:gesture];
}


@end
