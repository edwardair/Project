//
//  TimeChooseView.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-8.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TimeChooseViewShowNotification @"TimeChooseViewShowNotification"
#define TimeChooseViewHideNotification @"TimeChooseViewHideNotification"

@interface TimeChooseView : UIView

//@property (strong, nonatomic) UILabel *year;

@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong,nonatomic) UITextField *timeField;

//@property (nonatomic) float deviatorY;

- (void)dateChanged:(UIDatePicker *)p;
- (void)showPicker:(BOOL)show withField:(UITextField *)field;
- (void)resignTimeChooseView;
@end

