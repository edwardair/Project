//
//  SubMenuButton.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubMenuButton : UIButton

@property (strong,nonatomic) UIView *contentView;
@property (nonatomic) BOOL didContentUnfold;
+(id )initWithTitle:(NSString *)title;
@end
