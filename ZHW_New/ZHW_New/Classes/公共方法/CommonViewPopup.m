//
//  CommonViewPopup.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-15.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonViewPopup.h"
#import "CommonMethod.h"
@implementation CommonViewPopup
-(void )initializeView{
//    CommonViewPopup *view = [[CommonViewPopup alloc]initWithFrame:applicationFrame()];
    [self setFrame:applicationFrame()];
    self.backgroundColor = [UIColor blackColor];
	self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.transform = CGAffineTransformScale(self.transform, .1, .1);
    self.alpha = 0;

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)hideSelfView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hide)];
    self.transform = CGAffineTransformScale(self.transform, .1, .1);
//    self.hidden = YES;
    self.alpha = 0;
    [UIView commitAnimations];
}
- (void)hide{
//    self.hidden = YES;
}
- (void)showAction{
    TapResignKeyBoard *tap = [TapResignKeyBoard shareTapResignKeyBoard];
    [tap addTarget:self action:@selector(hideSelfView) parentView:self];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.2f];
    self.transform = CGAffineTransformScale(self.transform, 10, 10);
//    self.hidden = NO;
    self.alpha = 1;
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (void)dealloc{
////    for (UIView *s in self.subviews) {
////        [s removeFromSuperview];
////        [s release];
////        s = nil;
////    }
//    [super dealloc];
//}
@end
