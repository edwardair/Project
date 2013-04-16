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
@property (nonatomic,assign) int meetingId;
@property (strong,nonatomic) NSMutableArray *downMenus;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) SEL selector;
@property (strong,nonatomic) NSMutableArray *showDataArray;

- (void)initializeButton;
@end
