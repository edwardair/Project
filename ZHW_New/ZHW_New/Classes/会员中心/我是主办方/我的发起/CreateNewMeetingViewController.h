//
//  CreateNewMeetingViewController.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CellPushedViewController.h"
#import "CommonMethod.h"
@class ShowDownButton;
@class GroupManagerView;
@class MeetingManagerView;
@class MyCreatedMeetings;
@interface CreateNewMeetingViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,CellPushedViewControllerDelegate,TapResignKeyBoardDelegate>

@property (strong,nonatomic) MyCreatedMeetings *preView;

@property (strong,nonatomic) IBOutlet UIScrollView *bs1;
@property (strong,nonatomic) IBOutlet UIScrollView *bs2;
@property (strong,nonatomic) IBOutlet UIScrollView *bs3;
@property (strong,nonatomic) IBOutlet UIScrollView *bs4;

@property (strong,nonatomic) IBOutlet UIImageView *coverImage;

#pragma mark 新建会议
- (IBAction)CreateNewMeeting:(id )sender;
- (void)CreateNewMeeting_OK;
- (IBAction)CreateNewMeeting_ResetAll;
- (IBAction)resignKeyboard:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *createNewMeetingView;//新建会议 view

@property (strong,nonatomic) IBOutlet UITextField *meetingName;//会议名称
@property (strong,nonatomic) IBOutlet UITextField *meetingStartDate;//开始时间
@property (strong,nonatomic) IBOutlet UITextField *meetingEndDate;//结束时间
@property (strong,nonatomic) IBOutlet UITextField *meetingAddress;//会议地址
@property (strong,nonatomic) IBOutlet UITextField *meetingSponsor;//主办方
@property (strong,nonatomic) IBOutlet UITextField *meetingJoiner;//协办方
@property (strong,nonatomic) IBOutlet ShowDownButton *meetingType;//会议类型
@property (strong,nonatomic) IBOutlet UITextView *meetingTheme;//会议主题
@property (strong,nonatomic) IBOutlet UITextView *meetingRequriements;//会议需求
@property (strong,nonatomic) IBOutlet UIButton *reset;

#pragma mark 人员管理
@property (strong,nonatomic) IBOutlet UIView *tableTitleView;
@property (strong,nonatomic) IBOutlet UIView *memberManageView;//人员管理 view
@property (strong,nonatomic) IBOutlet ShowDownButton *MM_MeetingName;//会议选择按钮
@property (strong,nonatomic) IBOutlet UITableView *MM_MemberList;//会议名单

@property (strong,nonatomic) NSMutableArray *MemberListOfAMeeting;//选中会议的所有成员及属性

- (void)MM_MeetingNameButton;
#pragma mark 群组管理
@property (strong,nonatomic) GroupManagerView *groupManageView;

#pragma mark 议程管理
@property (strong,nonatomic) MeetingManagerView *meetingManageView;

@end
