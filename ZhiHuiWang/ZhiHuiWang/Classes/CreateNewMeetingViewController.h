//
//  CreateNewMeetingViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShowDownButton;
@interface CreateNewMeetingViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>

@property (strong,nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong,nonatomic) IBOutlet UIImageView *coverImage;

#pragma mark 新建会议
@property (strong,nonatomic) IBOutlet UITextField *meetingName;//会议名称
@property (strong,nonatomic) IBOutlet UITextField *meetingStartDate;//开始时间
@property (strong,nonatomic) IBOutlet UITextField *meetingEndDate;//结束时间
@property (strong,nonatomic) IBOutlet UITextField *meetingAddress;//会议地址
@property (strong,nonatomic) IBOutlet UITextField *meetingSponsor;//主办方
@property (strong,nonatomic) IBOutlet UITextField *meetingJoiner;//协办方
@property (strong,nonatomic) IBOutlet ShowDownButton *meetingType;//会议类型
@property (strong,nonatomic) IBOutlet UITextView *meetingTheme;//会议主题
@property (strong,nonatomic) IBOutlet UITextView *meetingRequriements;//会议需求
@property (strong,nonatomic) IBOutlet UIButton *finished;
@property (strong,nonatomic) IBOutlet UIButton *reset;

- (IBAction)resignKeyboard:(id)sender;
#pragma mark 人员管理
#pragma mark 群组管理
#pragma mark 议程管理

@end
