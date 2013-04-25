//
//  MyCreatedMeetings.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableView.h"
@class MemberCenterViewController;
@interface MyCreatedMeetings : UIView<UITableViewDelegate,UITableViewDataSource,CommonTableViewDelegate>
@property (nonatomic,strong) UIBarButtonItem *add;
+(id)initilaize;
- (void)updateTableViewDataSource;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) IBOutlet UILabel *start;
@property (strong,nonatomic) IBOutlet UILabel *end;
@property (strong,nonatomic) IBOutlet UILabel *addressTitle;
@property (strong,nonatomic) IBOutlet UILabel *address;
@property (strong,nonatomic) IBOutlet UILabel *themeTitle;
@property (strong,nonatomic) IBOutlet UILabel *theme;

@property (strong,nonatomic) MemberCenterViewController *parentController;

@end
