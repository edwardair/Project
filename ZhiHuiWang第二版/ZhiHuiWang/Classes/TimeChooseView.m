//
//  TimeChooseView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-8.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "TimeChooseView.h"

@implementation TimeChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
+(TimeChooseView *)timeChooseView:(id)parent{
    NSArray *ar = [[NSBundle mainBundle] loadNibNamed:@"TimeChooseView" owner:parent options:nil];
    TimeChooseView *view = (TimeChooseView *)ar[0];
    [view.datePicker setLocale:[NSLocale autoupdatingCurrentLocale]];
    [view.datePicker setTimeZone:[NSTimeZone systemTimeZone]];
//    view.datePicker.calendar

    return view;
}
- (void)showNowDate{
    NSDate *date = [NSDate date];
    NSLog(@"%@",date);
}
@end
