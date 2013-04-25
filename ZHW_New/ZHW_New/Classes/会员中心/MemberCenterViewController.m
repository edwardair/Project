//
//  MemberCenterViewController.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "CommonMethod.h"

#import "MyCreatedMeetings.h"
#import "MeetingNotification.h"
#import "MeetingApplying.h"
#import "HomePageRecommend.h"

@interface MemberCenterViewController (){
    UIScrollView *bottomScrollView;
}

@end

@implementation MemberCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//codes
- (void)changeViewWithIndexPath:(NSIndexPath *)path{
    UIView *tempView = nil;
    NSString *title = nil;
    switch (path.section) {
        case 0:
            
            break;
        case 1:
            //我是主办方
        {
            if (path.row==0){
                tempView = [MyCreatedMeetings initilaize];
                MyCreatedMeetings *c = (MyCreatedMeetings *)tempView;
                c.parentController = self;
                title = @"我的发起";
            }
            else if (path.row==1){
                tempView = [MeetingNotification initilaize];
                title = @"会议通知";
            }
            else if (path.row==2){
                tempView = [MeetingApplying initilaize];
                title = @"批复申请";
            }
            else if (path.row==3){
                tempView = [HomePageRecommend initilaize];
                title = @"首页推荐";
            }
        }
            break;
        case 2:
            
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
    
    if (tempView) {
        //切换界面
        if (_curPresentView) {
            [_curPresentView removeFromSuperview];
//            [_curPresentView release];
            _curPresentView = nil;
        }
        [self.view addSubview:tempView];
        //发送通知   tempView已经加载上 tempView有superView
        [[NSNotificationCenter defaultCenter] postNotificationName:@"superView" object:nil];
//        if (tempView.superview) {
//            NSLog(@"yes");
//        }
        self.curPresentView = tempView;
        self.parentViewController.navigationItem.leftBarButtonItem.title = title;    
    }

}

@end
