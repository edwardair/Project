//
//  ShowDownButton.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-26.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowDownButton : UIButton
//-(void) buttonWithNames: (NSString *) name, ...;
@property (strong,nonatomic) UIScrollView *downScrollView;

- (void)initializeButtonData:(NSMutableArray *)data;
@end
