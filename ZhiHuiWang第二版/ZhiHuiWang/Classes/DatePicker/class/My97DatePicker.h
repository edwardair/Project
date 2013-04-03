//
//  My97DatePicker.h
//  htmlDatePickerDemo
//
//  Created by wu xiaoming on 13-1-23.
//  Copyright (c) 2013年 wu xiaoming. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface My97DatePicker : UITextField<UIWebViewDelegate,UITextFieldDelegate>

@property(retain,nonatomic)UIWebView* webViewForSelectDate;
@property(nonatomic,retain)UIView* grayBG;
@property(nonatomic,retain)UIButton* datePickerBtn;


-(id)initWithFrame:(CGRect)frame;
- (void)selectDate;
@end

