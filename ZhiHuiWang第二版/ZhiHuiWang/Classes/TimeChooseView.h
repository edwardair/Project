//
//  TimeChooseView.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-8.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeChooseView : UIView

@property (strong, nonatomic) IBOutlet UILabel *year;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong,nonatomic) UITextField *timeField;

+(TimeChooseView *)timeChooseView:(id)parent;
- (void)showNowDate;
@end
