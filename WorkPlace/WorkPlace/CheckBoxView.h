//
//  CheckBoxView.h
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UICheckBoxType{
    UICheckBoxTypeDefault,
    
}UICheckBoxType;

@interface CheckBoxView : UIView
@property (nonatomic,retain) UIImageView *boxView;
@property (nonatomic,retain) UILabel *textLabel;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,assign) UICheckBoxType type;
@property (nonatomic,assign) BOOL boxSelected;
+(id )initWithFrame:(CGRect)frame type:(UICheckBoxType )type;
- (void)autoSizeFrame;
@end
