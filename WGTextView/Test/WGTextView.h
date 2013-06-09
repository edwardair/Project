//
//  UITextViewExtend.h
//  abs
//
//  Created by Apple on 13-6-8.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DefaultFontSize 18.0f

@interface WGTextView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) float lineHeight;
@property (nonatomic,copy) UIFont *font;
@end
